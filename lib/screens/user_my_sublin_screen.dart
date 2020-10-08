import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'package:Sublin/models/address_class.dart';
import 'package:Sublin/models/address_info_class.dart';
import 'package:Sublin/models/transportation_type_enum.dart';
import 'package:Sublin/services/address_service.dart';
import 'package:Sublin/services/user_service.dart';
import 'package:Sublin/utils/add_city_to_user_communes_and_addresses.dart';
import 'package:Sublin/utils/get_formatted_city_from_formatted_station.dart';
import 'package:Sublin/utils/get_formatted_city_from_formatted_station_with_commune.dart';
import 'package:Sublin/utils/get_list_of_address_info_from_list_of_provider_users_and_user.dart';
import 'package:Sublin/widgets/user_my_sublin_start_widget.dart';
import 'package:Sublin/widgets/waiting_widget.dart';
import 'package:Sublin/models/delimiter_class.dart';
import 'package:Sublin/models/preferences_enum.dart';
import 'package:Sublin/models/my_card_format_enum.dart';
import 'package:Sublin/models/provider_type_enum.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/request_class.dart';
import 'package:Sublin/models/routing_class.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/models/user_type_enum.dart';
import 'package:Sublin/screens/address_input_screen.dart';
import 'package:Sublin/screens/user_routing_screen.dart';
import 'package:Sublin/services/geolocation_service.dart';
import 'package:Sublin/services/provider_user_service.dart';
import 'package:Sublin/services/shared_preferences_service.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/utils/get_formatted_city_from_formatted_address.dart';
import 'package:Sublin/utils/is_route_completed.dart';
import 'package:Sublin/utils/is_route_confirmed.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/user_my_sublin_end_widget.dart';
import 'package:Sublin/widgets/navigation_bar_widget.dart';

enum Filter { taxisOnly, excludeTaxis, excludeIfNotPartner }

enum AddressAvailablilty {
  notRequested,
  available,
  station,
  publiclyAvailable,
  notAvailable,
}

class UserMySublinScreen extends StatefulWidget {
  const UserMySublinScreen({Key key, this.setNavigationIndex})
      : super(key: key);

  final int setNavigationIndex;

  static const routeName = './userFreeRidecreenState';
  @override
  _UserMySublinScreenState createState() => _UserMySublinScreenState();
}

class _UserMySublinScreenState extends State<UserMySublinScreen>
    with WidgetsBindingObserver {
  Request _localRequest = Request();
  List<ProviderUser> _providerUsersList;
  List<AddressInfo> _addressInfoList;
  List<AddressInfo> _addressInfoListWithCurrentPositionFilter;
  User user;

  @override
  void initState() {
    _getStartAddressFromGeolocastion();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _getStartAddressFromGeolocastion();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final Routing routingService = Provider.of<Routing>(context);
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight =
        (size.height > 700 ? 700 : size.height - kToolbarHeight - 24) /
            (size.height > 700 ? 2.5 : 2.2);
    final double itemWidth = size.width / 2;
    return Scaffold(
      bottomNavigationBar: NavigationBarWidget(
          isProvider: user.userType != UserType.user, setNavigationIndex: 0),
      appBar: AppbarWidget(title: 'Meine Shuttles'),
      body: SafeArea(
        child: Container(
          color: ThemeConstants.backgroundColor,
          child: FutureBuilder<List<List<ProviderUser>>>(
              // future: ProviderService().getProviders(communes: user.communes),
              future: Future.wait([
                ProviderUserService()
                    .getProvidersFromCommunesWithProviderPlanAll(
                        communes: user.communes),
                ProviderUserService()
                    .getProvidersWithProviderPlanEmailOnly(email: user.email),
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data.length != 0) {
                  _providerUsersList = [
                    ...snapshot.data[0],
                    ...snapshot.data[1]
                  ];

                  // We need to filter out taxis
                  _providerUsersList = _applyFilterFromList(
                      providerUsers: _providerUsersList,
                      filter: Filter.excludeTaxis,
                      localRequest: _localRequest);

                  // We need to filter out those that are not partners with a taxi
                  _providerUsersList = _applyFilterFromList(
                      providerUsers: _providerUsersList,
                      filter: Filter.excludeIfNotPartner,
                      localRequest: _localRequest);

                  //* We convert the list to a list of Addressinfo instances
                  //* We need it for the address search as suggestions
                  _addressInfoList =
                      getListOfAddressInfoFromListOfProviderUsersAndUser(
                    providerUserList: _providerUsersList,
                    user: user,
                  );
                  //* This is for the end address selection which should only show addresses
                  //* that are not within the bounds of the start address
                  _addressInfoListWithCurrentPositionFilter =
                      getListOfAddressInfoFromListOfProviderUsersAndUser(
                          providerUserList: _providerUsersList,
                          user: user,
                          localRequest: _localRequest);

                  return Stack(
                    children: [
                      if (isRouteConfirmed(routingService) &&
                          !isRouteCompleted(routingService))
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 100,
                                child: InkWell(
                                  onTap: () async {
                                    await Navigator.pushNamed(
                                        context, UserRoutingScreen.routeName);
                                  },
                                  child: Card(
                                      child: Padding(
                                    padding: ThemeConstants.mediumPadding,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: ThemeConstants
                                                  .sublinMainColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: CircularProgressIndicator()),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: AutoSizeText(
                                            'Du hast bereits eine Fahrt gebucht.',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1,
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Container(
                        padding: EdgeInsets.only(
                            bottom: isRouteConfirmed(routingService) &&
                                    !isRouteCompleted(routingService)
                                ? 100
                                : 0),
                        child: Column(
                          children: [
                            UserMySublinStartWidget(
                              startAddress: _localRequest.startAddress,
                              user: user,
                              addressInputCallback: addressInputCallback,
                              addressInfoList: _addressInfoList,
                            ),
                            Expanded(
                              flex: 10,
                              child: Padding(
                                padding: ThemeConstants.smallPadding,
                                child: GridView.builder(
                                  itemCount:
                                      _addressInfoListWithCurrentPositionFilter
                                              .length +
                                          1,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 1.0,
                                    mainAxisSpacing: 1.0,
                                    childAspectRatio: (itemWidth / itemHeight),
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index <
                                        _addressInfoListWithCurrentPositionFilter
                                            .length) {
                                      AddressInfo _addressInfo =
                                          _addressInfoListWithCurrentPositionFilter[
                                              index];
                                      MyCardFormat _myCardFormat =
                                          MyCardFormat.available;
                                      return UserMySublinEndWidget(
                                        addressInputCallback:
                                            addressInputCallback,
                                        removeRequestedAddressCallback:
                                            _removeRequestedAddressCallback,
                                        transportationType:
                                            TransportationType.sublin,
                                        localRequest: _localRequest,
                                        addressInfo: _addressInfo,
                                        itemWidth: itemWidth,
                                        itemHeight: itemHeight,
                                        user: user,
                                        context: context,
                                        myCardFormat: _myCardFormat,
                                        isRouteBooked: isRouteConfirmed(
                                                routingService) &&
                                            !isRouteCompleted(routingService),
                                      );
                                    } else
                                      return UserMySublinEndWidget(
                                        addressInputCallback:
                                            addressInputCallback,
                                        removeRequestedAddressCallback:
                                            _removeRequestedAddressCallback,
                                        transportationType:
                                            TransportationType.public,
                                        localRequest: _localRequest,
                                        itemWidth: itemWidth,
                                        itemHeight: itemHeight,
                                        user: user,
                                        context: context,
                                        myCardFormat: MyCardFormat.add,
                                        isRouteBooked: isRouteConfirmed(
                                                routingService) &&
                                            !isRouteCompleted(routingService),
                                      );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return WaitingWidget(
                    title: 'Wir suchen deine Angebote...',
                  );
                }
              }),
        ),
      ),
    );
  }

  Future<void> addressInputCallback({
    String userUid,
    User user,
    String input,
    String id,
    bool isCompany,
    List<dynamic> terms,
    bool isStartAddress,
    bool isEndAddress,
    ProviderUser providerUser,
    String station,
    AddressInfo addressInfo,
  }) async {
    //* Here we check if the address that the user was looking for is either
    //* 1. an address for the current list of sublin addresses
    //* 2. any other available Sublin address for the user
    //* 3. a station address
    //* 4. an publicly available address
    //*
    //* This instance of this class will be filled with the right address information
    AddressInfo _addressInfoResult = AddressInfo();
    //* First we check if an address from the list of available addresses or
    //* from the list of user addresses are picked
    if (_addressInfoList != null && _addressInfoList.length != 0) {
      _addressInfoList.forEach((addressInfoItem) {
        if (addressInfoItem.formattedAddress == addressInfo.formattedAddress)
          _addressInfoResult.formattedAddress = addressInfo.formattedAddress;
      });
    }
    //* Now we check if it is any other Sublin address
    if (_addressInfoResult.formattedAddress == null) {
      //* We try to find communes of the addresses from the user input
      List<ProviderUser> _providerUsersForStartAddress =
          await ProviderUserService()
              .getProvidersFromCommunesWithProviderPlanAll(
        communes: [
          getFormattedCityFromFormattedAddress(addressInfo.formattedAddress)
        ],
      );

      if (_providerUsersForStartAddress.length > 0) {
        _addressInfoResult.formattedAddress = addressInfo.formattedAddress;
        await _addToRequestedUserAddressesAndCommunes(
            formattedAddress: _addressInfoResult, user: user);
      }
    }
    // * We lookup the addresses collection to find the nearest train station for the user or
    // * if it is a city with extensive public transportation the user input address should be used
    if (_addressInfoResult.formattedAddress == null) {
      String _inputFormattedCity =
          getFormattedCityFromFormattedAddress(addressInfo.formattedAddress);
      Address _addressFromAddresses = await AddressService()
          .getAddressesFromAddress(formattedCity: _inputFormattedCity);
      if (_addressFromAddresses != null) {
        if (_addressFromAddresses.stations.length > 0) {
          _addressFromAddresses.stations.where((station) {
            return getFormattedCityFromFormattedStationWithCommune(station) ==
                _inputFormattedCity;
          }).toList();
          _addressInfoResult.formattedAddress =
              _addressFromAddresses.stations[0];
        }
        //* If public transportation is available
        else {
          _addressInfoResult.formattedAddress = addressInfo.formattedAddress;
        }
        await _addToRequestedUserAddressesAndCommunes(
            formattedAddress: _addressInfoResult, user: user);
      }
    }

    //* If no train stataions was found in addresses than the user provided one
    //* which we need to trust - so we set it to the start address and
    //* add it to the addresses collection
    if (_addressInfoResult.formattedAddress == null) {
      if (addressInfo.formattedAddress.contains(Delimiter.station)) {
        AddressService().updateStationToAddresses(
            city: getFormattedCityFromFormattedAddress(
                getFormattedCityFromFormattedStation(
                    addressInfo.formattedAddress)),
            formattedStation: getFormattedCityFromFormattedAddress(
                    getFormattedCityFromFormattedStation(
                        addressInfo.formattedAddress)) +
                addressInfo.formattedAddress);
        await _addToRequestedUserAddressesAndCommunes(
            formattedAddress: _addressInfoResult, user: user);
      }
    }

    if (_addressInfoResult.formattedAddress == null) {
      // We don't find a train station
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddressInputScreen(
                  userUid: userUid,
                  user: user,
                  addressInputCallback: addressInputCallback,
                  isEndAddress: isEndAddress,
                  isStartAddress: isStartAddress,
                  showGeolocationOption: true,
                  isStation: true,
                  title: 'Bahnhof',
                  address: input,
                  message:
                      'Für diese Addresse gibt es noch keinen Zubringerdienst zum Bahnhof. Bitte gib deinen nächstgelegenen Bahnhof bekannt, damit wir die Route zu anderen Orten berechnen können.')));
    } else {
      // If this is an available address of any kind we will set the direction and the Shared Preference
      setState(() {
        if (isStartAddress)
          _localRequest.startAddress = _addressInfoResult.formattedAddress;
        if (isEndAddress)
          _localRequest.endAddress = _addressInfoResult.formattedAddress;
      });
      addStringToSF(Preferences.stringLocalRequestStartAddress,
          _addressInfoResult.formattedAddress);
    }
  }

  Future<void> _removeRequestedAddressCallback(
      {AddressInfo addressInfo, User user}) async {
    List<String> addresses = user.addresses;
    List<String> updatedRequestAddresses;
    updatedRequestAddresses = addresses.where((address) {
      if (address == addressInfo.formattedAddress)
        return false;
      else
        return true;
    }).toList();
    await UserService().updateUserAddressesAndCommunes(
        addresses: updatedRequestAddresses, uid: user.uid);
  }

  Future<void> _addToRequestedUserAddressesAndCommunes({
    AddressInfo formattedAddress,
    User user,
  }) async {
    //* Add addresses to the addresses of the user
    User _user = addCityToUserCommunesAndAddresses(
        formattedAddress: formattedAddress.formattedAddress, user: user);
    UserService().updateUserAddressesAndCommunes(
        uid: user.uid, addresses: _user.addresses, communes: _user.communes);
  }

  Future<void> _getStartAddressFromGeolocastion() async {
    try {
      String _localRequestStartAddressFromSF =
          await getStringValuesSF(Preferences.stringLocalRequestStartAddress);
      if (_localRequestStartAddressFromSF != '') {
        setState(() {
          _localRequest.startAddress = _localRequestStartAddressFromSF;
        });
      } else {
        GeolocationStatus geolocationStatus =
            await GeolocationService().isGeoLocationPermissionGranted();
        if (geolocationStatus == GeolocationStatus.granted) {
          Request _geolocation =
              await GeolocationService().getCurrentCoordinates();
          setState(() {
            _localRequest = _geolocation;
          });
          addStringToSF(Preferences.stringLocalRequestStartAddress,
              _localRequest.startAddress);
        }
      }
    } catch (e) {
      print(e);
    }
  }
}

List<ProviderUser> _applyFilterFromList({
  List<ProviderUser> providerUsers,
  Filter filter,
  Request localRequest,
}) {
  List<ProviderUser> _providerUsers;
  _providerUsers = providerUsers.where((providerUser) {
    bool isTrue = false;
    switch (filter) {
      case Filter.excludeTaxis:
        if (providerUser.providerType != ProviderType.taxi) isTrue = true;
        break;
      case Filter.taxisOnly:
        if (providerUser.providerType == ProviderType.taxi) isTrue = true;
        break;
      case Filter.excludeIfNotPartner:
        if (providerUser.providerType == ProviderType.sponsor ||
            providerUser.providerType == ProviderType.sponsorShuttle) {
          if (providerUser.partnershipConfirmed == true) isTrue = true;
        } else
          isTrue = true;
    }
    return isTrue;
  }).toList();
  return _providerUsers;
}
