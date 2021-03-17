import 'dart:async';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:Sublin/models/preferences_enum.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/models/user_type_enum.dart';
import 'package:Sublin/services/geolocation_service.dart';
import 'package:Sublin/services/shared_preferences_service.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/navigation_bar_widget.dart';
import 'package:Sublin/models/auth_class.dart';
import 'package:Sublin/models/request_class.dart';
import 'package:Sublin/screens/user_routing_screen.dart';
import 'package:Sublin/services/routing_service.dart';
import 'package:Sublin/models/routing_class.dart';
import 'package:Sublin/widgets/address_search_widget.dart';

class UserRequestScreen extends StatefulWidget {
  static const routeName = '/userRequestScreen';
  @override
  _UserRequestScreenState createState() => _UserRequestScreenState();
}

class _UserRequestScreenState extends State<UserRequestScreen>
    with WidgetsBindingObserver {
  Request _localRequest = Request();
  LocationPermission _geolocationStatus;

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
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context);
    final User user = Provider.of<User>(context);

    return Scaffold(
      bottomNavigationBar:
          NavigationBarWidget(isProvider: user.userType == UserType.provider),
      appBar: AppbarWidget(title: 'Meine Fahrt'),
      body: SingleChildScrollView(
        child: SizedBox(
            height: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                80,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 440,
                  child: ListView(
                    children: <Widget>[
                      (_geolocationStatus == LocationPermission.denied)
                          ? InkWell(
                              onTap: () {
                                openAppSettings();
                              },
                              child: Container(
                                padding: EdgeInsets.all(15),
                                height: 60,
                                color: Color.fromRGBO(201, 228, 202, 1),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: AutoSizeText(
                                        'Standortbestimmung ausgeschaltet',
                                        maxLines: 2,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: FlatButton(
                                          onPressed: () => openAppSettings(),
                                          child: AutoSizeText(
                                            'Einschalten',
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .button,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      AddressSearchWidget(
                        addressInputFunction: addressInputFunction,
                        isStartAddress: true,
                        showGeolocationOption: true,
                        address: _localRequest.startAddress,
                      ),
                      AddressSearchWidget(
                        addressInputFunction: addressInputFunction,
                        isEndAddress: true,
                        address: _localRequest.endAddress,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              onPressed: (_localRequest.endAddress != '' &&
                                      _localRequest.startAddress != '')
                                  ? () async {
                                      try {
                                        await addBoolToSF(
                                            Preferences.boolHasRatedTrip,
                                            false);
                                        await addBoolToSF(
                                            Preferences.boolActiveRoute, true);
                                        await RoutingService().requestRoute(
                                          uid: auth.uid,
                                          startAddress:
                                              _localRequest.startAddress,
                                          endAddress: _localRequest.endAddress,
                                          timestamp: DateTime.now(),
                                        );
                                        await Navigator.pushReplacementNamed(
                                          context,
                                          UserRoutingScreen.routeName,
                                          arguments: Routing(),
                                        );
                                      } catch (e) {
                                        print(e);
                                      }
                                    }
                                  : null,
                              child: Text('Deine Verbindung finden'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void addressInputFunction(
      {String userUid,
      String input,
      String id,
      bool isCompany,
      List<dynamic> terms,
      bool isStartAddress,
      bool isEndAddress}) {
    setState(() {
      if (isStartAddress) _localRequest.startAddress = input;
      if (isEndAddress) _localRequest.endAddress = input;
    });
  }

  Future<void> _getStartAddressFromGeolocastion() async {
    try {
      if (!await GeolocationService().isGeoLocationPermissionGranted()) {
        throw StateError(":ocation servive is not enabled");
      }
      Request _geolocation = await GeolocationService().getCurrentCoordinates();
      setState(() async {
        _geolocationStatus = await Geolocator.checkPermission();
        if (_geolocation != null) {
          _localRequest = _geolocation;
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
