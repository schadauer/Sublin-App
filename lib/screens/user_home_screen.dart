import 'dart:async';

import 'package:Sublin/services/geolocation_service.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:Sublin/models/auth.dart';
import 'package:Sublin/models/request.dart';
import 'package:Sublin/screens/user_routing_screen.dart';
import 'package:Sublin/services/auth_service.dart';
import 'package:Sublin/services/routing_service.dart';

import 'package:Sublin/models/routing.dart';
import 'package:Sublin/widgets/address_search_widget.dart';
import 'package:Sublin/widgets/drawer_side_navigation_widget.dart';

class UserHomeScreen extends StatefulWidget {
  static const routeName = '/userHomeScreen';
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen>
    with WidgetsBindingObserver {
  Request _localRequest = Request();
  GeolocationStatus _geolocationStatus;
  // bool _geoLocationPermissionIsGranted = false;
  // Position _currentLocationLatLng;
  // List _currentLocationAutocompleteResults;
  // AppLifecycleState _notification;

  @override
  void initState() {
    _localRequest.startAddress = '';
    _localRequest.startId = '';
    _localRequest.endAddress = '';
    _localRequest.endId = '';
    _getStartAddressFromGeolocastion();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _getStartAddressFromGeolocastion();
    }
    // setState(() {
    //   _notification = state;
    // });
  }

  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppbarWidget(title: 'Deine Fahrt suchen'),
      endDrawer: DrawerSideNavigationWidget(
        authService: AuthService(),
      ),
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
                      (_geolocationStatus != GeolocationStatus.granted)
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
                                        await RoutingService().requestRoute(
                                          uid: auth.uid,
                                          startAddress:
                                              _localRequest.startAddress,
                                          startId: _localRequest.startId,
                                          endAddress: _localRequest.endAddress,
                                          endId: _localRequest.endId,
                                          timestamp: DateTime.now(),
                                        );
                                        await Navigator.pushReplacementNamed(
                                          context,
                                          UserRoutingScreen.routeName,
                                          arguments: Routing(
                                            startId: _localRequest.startId,
                                            endId: _localRequest.endId,
                                          ),
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
      {String input,
      String id,
      bool isCompany,
      List<dynamic> terms,
      bool isStartAddress,
      bool isEndAddress}) {
    setState(() {
      if (isStartAddress) _localRequest.startAddress = input;
      if (isStartAddress) _localRequest.startId = id;
      if (isEndAddress) _localRequest.endAddress = input;
      if (isEndAddress) _localRequest.endId = id;
    });
  }

  Future<void> _getStartAddressFromGeolocastion() async {
    try {
      GeolocationStatus geolocationStatus =
          await GeolocationService().isGeoLocationPermissionGranted();
      Request _geolocation = await GeolocationService().getCurrentCoordinates();
      setState(() {
        _geolocationStatus = geolocationStatus;
        if (_geolocation != null) {
          _localRequest = _geolocation;
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
