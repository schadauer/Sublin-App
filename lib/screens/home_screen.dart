import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:sublin/models/user.dart';
import 'package:sublin/services/auth_service.dart';
import 'package:sublin/services/routing_service.dart';
import 'package:sublin/widgets/address_search_widget.dart';

import 'package:sublin/models/routing.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthService _auth = AuthService();
  Routing _localRouting = Routing();
  bool _geoLocationPermissionIsGranted = false;
  TextEditingController _startLocationController = TextEditingController();
  Position _currentLocationLatLng;
  String _startLocation;

  @override
  void initState() {
    _isGeoLocationPermissionGranted();
    _localRouting.startAddress = '';
    _localRouting.startId = '';
    _localRouting.endAddress = '';
    _localRouting.endId = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final routing = Provider.of<Routing>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Deine Fahrt'),
        ),
        endDrawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              RaisedButton(
                  onPressed: () => _auth.signOut(), child: Text('Ausloggen')),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            if (_currentLocationLatLng != null && false) // remove false
              GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(_currentLocationLatLng.latitude,
                        _currentLocationLatLng.longitude),
                    zoom: 1),
              ),
            SizedBox(
                height: MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    80,
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
                      textInputFunction: textInputFunction,
                      startAddress: true,
                      address: _localRouting.startAddress,
                    ),
                    AddressSearchWidget(
                      textInputFunction: textInputFunction,
                      endAddress: true,
                      address: _localRouting.endAddress,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        try {
                          RoutingService().requestRoute(
                            uid: user.uid,
                            startAddress: _localRouting.startAddress,
                            startId: _localRouting.startId,
                            endAddress: _localRouting.endAddress,
                            endId: _localRouting.endId,
                          );
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text('Get it'),
                    )
                  ],
                )),
          ],
        ));
  }

  void textInputFunction(
      String input, String id, bool startAddress, bool endAddress) {
    setState(() {
      if (startAddress) _localRouting.startAddress = input;
      if (startAddress) _localRouting.startId = id;
      if (endAddress) _localRouting.endAddress = input;
      if (endAddress) _localRouting.endId = id;
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
        await _getPlacemarkFromCoordinates(
            _currentLocationLatLng.latitude, _currentLocationLatLng.longitude);
      } catch (e) {
        print('_getCurrentCoordinates: $e');
      }
    }
  }

  Future<void> _getPlacemarkFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemark = await Geolocator()
          .placemarkFromCoordinates(lat, lng, localeIdentifier: 'de_DE');
      placemark.map((e) {
        setState(() {
          _localRouting.startAddress =
              '${e.thoroughfare} ${e.subThoroughfare}, ${e.locality}';
        });
      }).toList();
      setState(() {
        _startLocationController.text = _startLocation;
        _localRouting.startAddress = _startLocation;
      });
    } catch (e) {
      print('_getPlacemarkFromCoordinates: $e');
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
