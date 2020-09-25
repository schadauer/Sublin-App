/* Copyright (C) 2020 Andreas Schadauer, andreas@sublin.app - All Rights Reserved */

import 'package:Sublin/models/address_class.dart';
import 'package:Sublin/models/address_info_class.dart';
import 'package:Sublin/models/transportation_type_enum.dart';
import 'package:Sublin/screens/waiting_screen.dart';
import 'package:Sublin/services/address_service.dart';
import 'package:Sublin/utils/get_formatted_city_from_formatted_station.dart';
import 'package:Sublin/utils/get_list_of_address_info_from_list_of_provider_users_and_user.dart';
import 'package:Sublin/widgets/user_my_sublin_start_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

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
import 'package:Sublin/utils/get_readable_address_from_formatted_address.dart';
import 'package:Sublin/utils/get_formatted_city_from_formatted_address.dart';
import 'package:Sublin/utils/get_readable_address_part_of_formatted_address.dart';
import 'package:Sublin/utils/is_route_completed.dart';
import 'package:Sublin/utils/is_route_confirmed.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/user_my_sublin_card_widget.dart';
import 'package:Sublin/widgets/navigation_bar_widget.dart';

enum Filter {
  taxisOnly,
  excludeTaxis,
  excludeStartAddress,
  excludeIfNotPartner
}

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
  int _lengthProviderUsersOfAvailables;
  int _lengthProviderUsersWithUnavailables;
  GeolocationStatus _geolocationStatus;
  Request _localRequest = Request();
  AddressAvailablilty _startAddressAvailability =
      AddressAvailablilty.notRequested;
  AddressAvailablilty _endAddressAvailablity = AddressAvailablilty.notRequested;
  List<ProviderUser> _providerUsersList;
  List<AddressInfo> _addressInfoList;

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
    final User user = Provider.of<User>(context);
    final Routing routingService = Provider.of<Routing>(context);
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/

    final double itemHeight =
        (size.height > 700 ? 700 : size.height - kToolbarHeight - 24) /
            (size.height > 700 ? 2.8 : 2.4);
    final double itemWidth = size.width / 2;
    return Scaffold(
      bottomNavigationBar: NavigationBarWidget(
          isProvider: user.userType != UserType.user, setNavigationIndex: 0),
      appBar: AppbarWidget(title: 'Meine Shuttles'),
      body: SafeArea(
        child: Container(
          color: Colors.black38,
          child: FutureBuilder<List<List<ProviderUser>>>(
              // future: ProviderService().getProviders(communes: user.communes),
              future: Future.wait([
                ProviderUserService()
                    .getProvidersFromCommunes(communes: user.communes),
                ProviderUserService().getProvidersEmailOnly(email: user.email),
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

                  print(_providerUsersList.length);
                  _providerUsersList.forEach((element) {
                    print(ProviderUser().toMap(element));
                  });
                  // We convert the list to a list of Addressinfo instances
                  _addressInfoList =
                      getListOfAddressInfoFromListOfProviderUsersAndUser(
                          providerUserList: _providerUsersList, user: user);
                  // Now we filter out the addresses that are within the area of the current position
                  List<ProviderUser> _providerUsersListForCurrentPosition =
                      _applyFilterFromList(
                          providerUsers: _providerUsersList,
                          filter: Filter.excludeStartAddress,
                          localRequest: _localRequest);

                  print(getListOfAddressInfoFromListOfProviderUsersAndUser(
                      providerUserList: _providerUsersList, user: user));

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
                            UserMySublinStartCardWidget(
                              startAddress: _localRequest.startAddress,
                              user: user,
                              addressInputFunction: _addressInputFunction,
                              addressInfoList:
                                  getListOfAddressInfoFromListOfProviderUsersAndUser(
                                      providerUserList: _providerUsersList,
                                      user: user),
                            ),
                            Expanded(
                              flex: 10,
                              child: Padding(
                                padding: ThemeConstants.smallPadding,
                                child: GridView.builder(
                                  itemCount:
                                      _providerUsersListForCurrentPosition
                                              .length +
                                          1,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 2.0,
                                    mainAxisSpacing: 2.0,
                                    childAspectRatio: (itemWidth / itemHeight),
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index <
                                        _providerUsersListForCurrentPosition
                                            .length) {
                                      ProviderUser _providerUser =
                                          _providerUsersListForCurrentPosition[
                                              index];
                                      MyCardFormat _myCardFormat =
                                          MyCardFormat.available;

                                      return UserMySublinCardWidget(
                                        transportationType:
                                            TransportationType.sublin,
                                        localRequest: _localRequest,
                                        providerUser: _providerUser,
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
                                      return UserMySublinCardWidget(
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
                  return WaitingScreen(
                    user: user,
                    title: 'Wir suchen deine Angebote...',
                  );
                }
              }),
        ),
      ),
    );
  }

  Future<void> _addressInputFunction({
    String userUid,
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
    bool _startAddressAccepted = false;
    // First we check if an address from the list of available addresses or
    // from the list of user requestedAddresses are picked
    if (_addressInfoList.length != 0) {
      _addressInfoList.forEach((address) {
        if (address.formattedAddress == addressInfo.formattedAddress)
          setState(() {
            _localRequest.startAddress = addressInfo.formattedAddress;
            _startAddressAccepted = true;
          });
      });
    }
    if (!_startAddressAccepted) {
      // We try to find addresses fro
      // TODO We need to filter out the emailOnly offers
      List<ProviderUser> _providerUsersForStartAddress =
          await ProviderUserService().getProvidersFromFormattedAddress(
              address: addressInfo.formattedAddress);
      if (_providerUsersForStartAddress.length > 0) {
        _startAddressAvailability = AddressAvailablilty.available;
      } else {
        _startAddressAvailability = AddressAvailablilty.notAvailable;
        // * We lookup the addresses collection to find the nearest train station for the user
        String _inputFormattedCity =
            getFormattedCityFromFormattedAddress(addressInfo.formattedAddress);
        Address _address = await AddressService()
            .getProvidersFromAddress(formattedCity: _inputFormattedCity);
        if (_address != null && _address.stations.length > 0) {
          _address.stations.where((station) {
            return getFormattedCityFromFormattedStation(station) ==
                _inputFormattedCity;
          }).toList();
          // If we find a train station
          setState(() {
            _startAddressAvailability = AddressAvailablilty.station;
            _localRequest.startAddress = _address.stations[0];
            addStringToSF(Preferences.stringLocalRequestStartAddress,
                _localRequest.startAddress);
          });
        } else {
          // We don't find a train station
          setState(() {
            _localRequest.startAddress = input;
            _startAddressAvailability = AddressAvailablilty.notAvailable;
          });
        }
      }
    }
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

// bool _transportationTypeOfAddress(String formattedAddress) {
//   String _formattedCity =
//       getFormattedCityFromFormattedAddress(formattedAddress);
// }

List<ProviderUser> _applyFilterFromList(
    {List<ProviderUser> providerUsers, Filter filter, Request localRequest}) {
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
      case Filter.excludeStartAddress:
        if (!providerUser.communes.contains(
            getFormattedCityFromFormattedAddress(localRequest.startAddress)))
          isTrue = true;
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
