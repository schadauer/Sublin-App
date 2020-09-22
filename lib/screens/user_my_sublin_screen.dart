/* Copyright (C) 2020 Andreas Schadauer, andreas@sublin.app - All Rights Reserved */

import 'package:Sublin/screens/waiting_screen.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:Sublin/models/delimiter_class.dart';
import 'package:Sublin/models/preferences_enum.dart';
import 'package:Sublin/models/my_card_format_enum.dart';
import 'package:Sublin/models/provider_type.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/request_class.dart';
import 'package:Sublin/models/routing.dart';
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
import 'package:Sublin/utils/get_readable_part_of_formatted_address.dart';
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
        child: Padding(
          padding: ThemeConstants.mediumPadding,
          child: FutureBuilder<List<List<ProviderUser>>>(
              // future: ProviderService().getProviders(communes: user.communes),
              future: Future.wait([
                ProviderUserService().getProviders(communes: user.communes),
                ProviderUserService().getProvidersEmailOnly(email: user.email),
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data.length != 0) {
                  List<ProviderUser> _providerUsersAll = [
                    ...snapshot.data[0],
                    ...snapshot.data[1]
                  ];

                  // Get all available addresses excluding taxis and add one element for user to add new cities
                  // List<ProviderUser> _data = snapshot.data != ? snapshot.data[0] : null;
                  List<ProviderUser> _providerUsersExcludeTaxis =
                      _addUserProviderForUserToAddCity(_applyFilterFromList(
                          providerUsers: _providerUsersAll,
                          filter: Filter.excludeTaxis,
                          localRequest: _localRequest));

                  // --------------------------------------------------------------------- TODO --------------------------------------------------------------
                  // We need to filter out those that are not partners with a taxi
                  _providerUsersExcludeTaxis = _applyFilterFromList(
                      providerUsers: _providerUsersExcludeTaxis,
                      filter: Filter.excludeIfNotPartner,
                      localRequest: _localRequest);

                  // Now we filter out the addresses that are within the area of the current position
                  _providerUsersExcludeTaxis = _applyFilterFromList(
                      providerUsers: _providerUsersExcludeTaxis,
                      filter: Filter.excludeStartAddress,
                      localRequest: _localRequest);

                  _lengthProviderUsersOfAvailables =
                      _providerUsersExcludeTaxis.length - 1;
                  // Now let's add all unavailable cities which are inactive for the user to view
                  List<ProviderUser> _providerUsersWithUnavailables =
                      _addUnavailableCitiesToList(
                          user, _providerUsersExcludeTaxis);
                  _lengthProviderUsersWithUnavailables =
                      _providerUsersWithUnavailables.length;
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
                            Container(
                              height: 80,
                              child: Card(
                                child: Padding(
                                    padding: ThemeConstants.mediumPadding,
                                    child: (_geolocationStatus ==
                                                GeolocationStatus.granted ||
                                            _localRequest.startAddress != '')
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10),
                                                  child: Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        '1',
                                                        style: TextStyle(
                                                          fontSize: 25,
                                                          fontFamily: 'Lato',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    AutoSizeText(
                                                      'Mein Standort',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline1,
                                                    ),
                                                    Expanded(
                                                      child: AutoSizeText(
                                                        '${getReadableAddressFromFormattedAddress(_localRequest.startAddress)}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1,
                                                        maxLines: 2,
                                                        minFontSize: 14,
                                                        // textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AddressInputScreen(
                                                                    userUid:
                                                                        user.uid,
                                                                    addressInputCallback:
                                                                        _addressInputFunction,
                                                                    isEndAddress:
                                                                        false,
                                                                    isStartAddress:
                                                                        true,
                                                                    showGeolocationOption:
                                                                        true,
                                                                    isStation:
                                                                        false,
                                                                    title:
                                                                        'Dein Standort',
                                                                  )));
                                                    },
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.edit,
                                                          size: 25,
                                                        ),
                                                        Text(
                                                          'ändern',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .caption,
                                                        )
                                                      ],
                                                    ),
                                                  ))
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: AutoSizeText(
                                                  'Sublin funktioniert am einfachsten wenn der Ortungsdienst aktiviert ist.',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                  // textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: FlatButton(
                                                    onPressed: () {
                                                      openAppSettings();
                                                    },
                                                    child: AutoSizeText(
                                                      'Einstellungen',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption,
                                                    )),
                                              )
                                            ],
                                          )),
                              ),
                            ),
                            Expanded(
                              flex: 10,
                              child: GridView.builder(
                                itemCount: _lengthProviderUsersWithUnavailables,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: (itemWidth / itemHeight),
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  ProviderUser _providerUser =
                                      _providerUsersWithUnavailables[index];
                                  MyCardFormat _myCardFormat;
                                  if (index < _lengthProviderUsersOfAvailables)
                                    _myCardFormat = MyCardFormat.available;
                                  else if (index ==
                                      _lengthProviderUsersOfAvailables)
                                    _myCardFormat = MyCardFormat.add;
                                  else
                                    _myCardFormat = MyCardFormat.unavailable;
                                  return UserMySublinCardWidget(
                                    localRequest: _localRequest,
                                    providerUser: _providerUser,
                                    itemWidth: itemWidth,
                                    itemHeight: itemHeight,
                                    user: user,
                                    context: context,
                                    myCardFormat: _myCardFormat,
                                    isRouteBooked:
                                        isRouteConfirmed(routingService) &&
                                            !isRouteCompleted(routingService),
                                  );
                                },
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
  }) async {
    setState(() {
      _localRequest.startAddress = input;
    });
    addStringToSF(Preferences.stringLocalRequestStartAddress, input);
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

List<ProviderUser> _addUserProviderForUserToAddCity(
    List<ProviderUser> providerUserList) {
  int whereToInsert = providerUserList.length;
  ProviderUser _listWithAdditionalElement = ProviderUser();
  providerUserList.insert(whereToInsert, _listWithAdditionalElement);
  return providerUserList;
}

List<ProviderUser> _addUnavailableCitiesToList(
    User user, List<ProviderUser> providerUsersExcludeTaxis) {
  // First we need to filter out the addresses that are available
  List<ProviderUser> _providerUsersExcludeTaxisWithUnavailableCities = [
    ...providerUsersExcludeTaxis
  ];
  List<dynamic> communes = user.communes;

  communes = user.communes.where((commune) {
    bool containsElement = false;
    providerUsersExcludeTaxis.forEach((providerUser) {
      if (providerUser.communes.contains(commune)) containsElement = true;
    });
    return !containsElement;
  }).toList();
  communes.forEach((commune) {
    _providerUsersExcludeTaxisWithUnavailableCities.add(ProviderUser(
        providerName:
            getReadablePartOfFormattedAddress(commune, Delimiter.city)));
  });
  return _providerUsersExcludeTaxisWithUnavailableCities;
}

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

// String _getReadableTaxiFromListOfAllProviders(
//     ProviderUser providerUser, List<ProviderUser> providerUsersTaxiOnly) {
//   String _taxi = '';

//   providerUser.partners.forEach((partnerId) {
//     providerUsersTaxiOnly.forEach((providerUser) {
//       if (providerUser.uid == partnerId) {
//         _taxi = providerUser.providerName;
//       }
//     });
//   });
//   return _taxi;
// }
