/* Copyright (C) 2020 Andreas Schadauer, andreas@sublin.app - All Rights Reserved */

import 'package:Sublin/models/delimiter_class.dart';
import 'package:Sublin/models/preferences_enum.dart';
import 'package:Sublin/models/my_card_format_enum.dart';
import 'package:Sublin/models/provider_type.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/request_class.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/models/user_type_enum.dart';
import 'package:Sublin/screens/address_input_screen.dart';
import 'package:Sublin/services/geolocation_service.dart';
import 'package:Sublin/services/provider_user_service.dart';
import 'package:Sublin/services/shared_preferences_service.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/utils/convert_formatted_address_to_readable_address.dart';
import 'package:Sublin/utils/get_readable_part_of_formatted_address.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/user_my_sublin_card_widget.dart';
import 'package:Sublin/widgets/navigation_bar_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

enum Filter { taxisOnly, excludeTaxis }

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
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    print(size.width);
    final double itemHeight =
        (size.height > 700 ? 700 : size.height - kToolbarHeight - 24) /
            (size.height > 700 ? 2.8 : 2.4);
    final double itemWidth = size.width / 2;
    return Scaffold(
      bottomNavigationBar: NavigationBarWidget(
          isProvider: user.userType != UserType.user,
          setNavigationIndex: widget.setNavigationIndex),
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
                  // Get all available addresses excluding taxis and add one element for user to add new cities
                  // List<ProviderUser> _data = snapshot.data != ? snapshot.data[0] : null;
                  List<ProviderUser> _providerUsersExcludeTaxis =
                      _addUserProviderForUserToAddCity(
                          _applyFilterFromListOfAll(
                              [...snapshot.data[0], ...snapshot.data[1]],
                              Filter.excludeTaxis));

                  _lengthProviderUsersOfAvailables =
                      _providerUsersExcludeTaxis.length - 1;
                  // Now let's add all unavailable cities which are inactive for the user to view
                  List<ProviderUser> _providerUsersWithUnavailables =
                      _addUnavailableCitiesToList(
                          user, _providerUsersExcludeTaxis);
                  _lengthProviderUsersWithUnavailables =
                      _providerUsersWithUnavailables.length;
                  return Column(
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
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: AutoSizeText(
                                            'Dein Standort ist ${convertFormattedAddressToReadableAddress(_localRequest.startAddress)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                            // textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: FlatButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                  side: BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor)),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddressInputScreen(
                                                              userUid: user.uid,
                                                              addressInputFunction:
                                                                  _addressInputFunction,
                                                              isEndAddress:
                                                                  false,
                                                              isStartAddress:
                                                                  true,
                                                              showGeolocationOption:
                                                                  true,
                                                              isStation: false,
                                                              title:
                                                                  'Dein Standort',
                                                            )));
                                              },
                                              child: AutoSizeText('ändern')),
                                        )
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
                            else if (index == _lengthProviderUsersOfAvailables)
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
                                myCardFormat: _myCardFormat);
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ),
      ),
    );
  }

  Future<void> _addressInputFunction(
      {String userUid,
      String input,
      String id,
      bool isCompany,
      List<dynamic> terms,
      bool isStartAddress,
      bool isEndAddress}) async {
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

List<ProviderUser> _applyFilterFromListOfAll(
    List<ProviderUser> providerUsers, Filter filter) {
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
