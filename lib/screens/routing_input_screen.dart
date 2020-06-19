import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sublin/models/address_id_arguments.dart';

import 'package:sublin/models/user.dart';
import 'package:sublin/screens/routing_screen.dart';
import 'package:sublin/services/auth_service.dart';
import 'package:sublin/services/google_map_service.dart';
import 'package:sublin/services/routing_service.dart';

import 'package:sublin/models/routing.dart';
import 'package:sublin/widgets/address_search_widget.dart';

class RoutingInputScreen extends StatefulWidget {
  static const routeName = '/routingInputScreen';

  @override
  _RoutingInputScreenState createState() => _RoutingInputScreenState();
}

class _RoutingInputScreenState extends State<RoutingInputScreen> {
  final AuthService _auth = AuthService();
  Routing _localRouting = Routing();
  bool _geoLocationPermissionIsGranted = false;
  TextEditingController _startLocationController = TextEditingController();
  Position _currentLocationLatLng;
  List _currentLocationAutocompleteResults;
  String _startLocation;

  @override
  void initState() {
    super.initState();
    _localRouting.startAddress = '';
    _localRouting.startId = '';
    _localRouting.endAddress = '';
    _localRouting.endId = '';
    _isGeoLocationPermissionGranted();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);

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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => openAppSettings(),
                                    child: Text('Location Service einschalten'))
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  AddressSearchWidget(
                    textInputFunction: textInputFunction,
                    isStartAddress: true,
                    address: _localRouting.startAddress,
                  ),
                  AddressSearchWidget(
                    textInputFunction: textInputFunction,
                    isEndAddress: true,
                    address: _localRouting.endAddress,
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () async {
                            try {
                              await RoutingService().requestRoute(
                                uid: user.uid,
                                startAddress: _localRouting.startAddress,
                                startId: _localRouting.startId,
                                endAddress: _localRouting.endAddress,
                                endId: _localRouting.endId,
                              );
                              await Navigator.pushNamed(
                                context,
                                RoutingScreen.routeName,
                                arguments: AddressIdArguments(
                                  _localRouting.startId,
                                  _localRouting.endId,
                                ),
                              );
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Text('Deine Verbindung finden'),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                child: Text('adfsdf'),
                color: Colors.white,
                height: 100,
                width: MediaQuery.of(context).size.width,
              )
            ],
          )
        ],
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Text('adfdsf');
        });
  }

  // void _setLocalInputAddresses(Map addresses) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  // }

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
        String address = await _getPlacemarkFromCoordinates(
            _currentLocationLatLng.latitude, _currentLocationLatLng.longitude);
        _currentLocationAutocompleteResults =
            await GoogleMapService().getGoogleAddressAutocomplete(address);
        setState(() {
          _localRouting.startAddress =
              _currentLocationAutocompleteResults[0]['name'];
          _localRouting.startId = _currentLocationAutocompleteResults[0]['id'];
        });

        print(_currentLocationAutocompleteResults);
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
    }
  }

  Future<void> _isGeoLocationPermissionGranted() async {
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();
    // if (geolocationStatus == GeolocationStatus.unknown) {}
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
