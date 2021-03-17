import 'package:Sublin/models/preferences_enum.dart';
import 'package:Sublin/models/request_class.dart';
import 'package:Sublin/services/google_map_service.dart';
import 'package:Sublin/utils/logging.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart' as Foundation;

class GeolocationService {
  Request _localRequest;
  LocationPermission _geoLocationPermissionStatus;
  Position _currentLocationLatLng;
  List _currentLocationAutocompleteResults;

  Future<Request> getCurrentCoordinates() async {
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

      try {
        if (!Foundation.kReleaseMode) {
          await sublinLogging(Preferences.intLoggingCoordinats);
        }
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.bestForNavigation);
        _currentLocationLatLng = position;
        String address = await _getPlacemarkFromCoordinates(
            _currentLocationLatLng.latitude, _currentLocationLatLng.longitude);
        _currentLocationAutocompleteResults = await GoogleMapService()
            .getGoogleAddressAutocomplete(input: address);
        _localRequest = Request(
            startAddress: _currentLocationAutocompleteResults[0]['name']);
        _localRequest.startAddress =
            _currentLocationAutocompleteResults[0]['name'];

        return _localRequest;
      } catch (e) {
        print('getCurrentCoordinates: $e');
        return null;
      }
  }

  Future<String> _getPlacemarkFromCoordinates(double lat, double lng) async {
    try {
      if (!Foundation.kReleaseMode) {
        await sublinLogging(Preferences.intLoggingCoordinats);
      }
      String address;
      List<Placemark> placemark = await placemarkFromCoordinates(lat, lng, localeIdentifier: 'de_DE');
      placemark.map((e) {
        address = '${e.thoroughfare} ${e.subThoroughfare}, ${e.locality}';
      }).toList();
      return address;
    } catch (e) {
      print('_getPlacemarkFromCoordinates: $e');
      return '';
    }
  }

  Future<bool> isGeoLocationPermissionGranted() async {
    var permission = await Geolocator.checkPermission();
    return ![LocationPermission.denied, LocationPermission.deniedForever].contains(permission);
  }
}
