import 'dart:async';

import 'package:Sublin/services/booking_service.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:Sublin/models/auth.dart';
import 'package:Sublin/models/request.dart';
import 'package:Sublin/screens/user_routing_screen.dart';
import 'package:Sublin/services/auth_service.dart';
import 'package:Sublin/services/google_map_service.dart';
import 'package:Sublin/services/routing_service.dart';

import 'package:Sublin/models/routing.dart';
import 'package:Sublin/widgets/address_search_widget.dart';
import 'package:Sublin/widgets/drawer_side_navigation_widget.dart';

class UserHomeScreen extends StatefulWidget {
  static const routeName = '/userHomeScreen';
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final AuthService _auth = AuthService();
  Request _localRequest = Request();
  bool _geoLocationPermissionIsGranted = false;
  Position _currentLocationLatLng;
  List _currentLocationAutocompleteResults;

  @override
  void initState() {
    _localRequest.startAddress = '';
    _localRequest.startId = '';
    _localRequest.endAddress = '';
    _localRequest.endId = '';
    _isGeoLocationPermissionGranted();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context);
    // final ProviderUser providerUser = Provider.of<ProviderUser>(context);
    return Scaffold(
      appBar: AppbarWidget(title: 'Home'),
      endDrawer: DrawerSideNavigationWidget(
        authService: AuthService(),
      ),
      body: SizedBox(
          height: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              80,
          child: Column(
            children: <Widget>[
              Container(
                height: 30,
              ),
              SizedBox(
                height: 440,
                child: ListView(
                  children: <Widget>[
                    (_geoLocationPermissionIsGranted == false)
                        ? InkWell(
                            onTap: () {
                              openAppSettings();
                            },
                            child: Container(
                              height: 80,
                              color: Color.fromRGBO(201, 228, 202, 1),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  FlatButton(
                                      onPressed: () => openAppSettings(),
                                      child:
                                          Text('Location Service einschalten'))
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    AddressSearchWidget(
                      addressInputFunction: addressInputFunction,
                      isStartAddress: true,
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
                                      await Navigator.pushNamed(
                                        context,
                                        RoutingScreen.routeName,
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
                    // StreamBuilder(
                    //     stream: BookingService().streamBooking(auth.uid),
                    //     builder: (context, snapshot) {
                    //       print(snapshot.data);
                    //       return Text('asdf');
                    //     })
                  ],
                ),
              ),
            ],
          )),
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
      print(_localRequest.startAddress);
      print(_localRequest.endAddress);
      if (isStartAddress) _localRequest.startAddress = input;
      if (isStartAddress) _localRequest.startId = id;
      if (isEndAddress) _localRequest.endAddress = input;
      if (isEndAddress) _localRequest.endId = id;
    });
  }

  Future<void> _getCurrentCoordinates() async {
    if (_geoLocationPermissionIsGranted) {
      try {
        final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
        Position position = await geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.bestForNavigation);
        setState(() {
          _currentLocationLatLng = position;
        });
        String address = await _getPlacemarkFromCoordinates(
            _currentLocationLatLng.latitude, _currentLocationLatLng.longitude);
        _currentLocationAutocompleteResults = await GoogleMapService()
            .getGoogleAddressAutocomplete(input: address);
        setState(() {
          _localRequest.startAddress =
              _currentLocationAutocompleteResults[0]['name'];
          _localRequest.startId = _currentLocationAutocompleteResults[0]['id'];
        });
      } catch (e) {
        print('_getCurrentCoordinates: $e');
      }
    }
  }

  Future<String> _getPlacemarkFromCoordinates(double lat, double lng) async {
    try {
      String address;
      List<Placemark> placemark = await Geolocator()
          .placemarkFromCoordinates(lat, lng, localeIdentifier: 'de_DE');
      placemark.map((e) {
        address = '${e.thoroughfare} ${e.subThoroughfare}, ${e.locality}';
      }).toList();
      return address;
    } catch (e) {
      print('_getPlacemarkFromCoordinates: $e');
      return '';
    }
  }

  Future<void> _isGeoLocationPermissionGranted() async {
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();

    if (geolocationStatus == GeolocationStatus.granted) {
      setState(() {
        _geoLocationPermissionIsGranted = true;
      });
      _getCurrentCoordinates();
    } else {
      setState(() {
        _geoLocationPermissionIsGranted = false;
      });
    }
  }
}
