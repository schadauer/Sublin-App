import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sublin/models/user.dart';
import 'package:provider/provider.dart';

import 'package:sublin/services/auth_service.dart';
import 'package:sublin/widgets/address_search_widget.dart';

import 'package:sublin/models/address.dart';
import 'package:sublin/models/routing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthService _auth = AuthService();
  Routing _routing = Routing();
  Address _startAddress = Address();
  Address _endAddress = Address();
  bool _geoLocationPermissionIsGranted = false;
  TextEditingController _startLocationController = TextEditingController();
  Position _currentLocationLatLng;
  String _startLocation;

  //static const kGoogleApiKey = "AIzaSyDNfEtREHF23tv-U8av9N2kDRDzEmCsAeM";

  @override
  void initState() {
    _isGeoLocationPermissionGranted();
    _startAddress.address = '';
    _endAddress.address = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final routing = Provider.of<Routing>(context);

    print(routing.startAddress);

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
                      address: _startAddress.address,
                    ),
                    AddressSearchWidget(
                      textInputFunction: textInputFunction,
                      endAddress: true,
                      address: _endAddress.address,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        try {
                          var snapy = Firestore.instance
                              .collection('users')
                              .document('eFAt4p0I31OjJJNtIyFM8dtY7jR2')
                              .get();

                          // Stream<QuerySnapshot> snapshot = Firestore.instance
                          //     .collection('providers')
                          //     .snapshots();

                          // snapshot.listen((value) {
                          //   value.documents.map((event) {
                          //     print(event.data);
                          //   });
                          // }
                          // );
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

  void textInputFunction(String input, bool startAddress, bool endAddress) {
    setState(() {
      print(input);
      print(endAddress);
      if (startAddress) _startAddress.address = input;
      if (endAddress) _endAddress.address = input;
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
          _startLocation =
              '${e.thoroughfare} ${e.subThoroughfare}, ${e.locality}';
        });
      }).toList();
      setState(() {
        _startLocationController.text = _startLocation;
        _startAddress.address = _startLocation;
        print(_startLocation);
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
