import 'package:Sublin/models/request.dart';
import 'package:Sublin/services/google_map_service.dart';
import 'package:geolocator/geolocator.dart';

class GeolocationService {
  Request _localRequest;
  GeolocationStatus _geoLocationPermissionStatus;
  Position _currentLocationLatLng;
  List _currentLocationAutocompleteResults;

  Future<Request> getCurrentCoordinates() async {
    _geoLocationPermissionStatus = await isGeoLocationPermissionGranted();
    if (_geoLocationPermissionStatus == GeolocationStatus.granted) {
      try {
        final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

        Position position = await geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.bestForNavigation);
        _currentLocationLatLng = position;
        String address = await _getPlacemarkFromCoordinates(
            _currentLocationLatLng.latitude, _currentLocationLatLng.longitude);
        _currentLocationAutocompleteResults = await GoogleMapService()
            .getGoogleAddressAutocomplete(input: address);
        _localRequest = Request(
            startAddress: _currentLocationAutocompleteResults[0]['name'],
            startId: _currentLocationAutocompleteResults[0]['id']);
        _localRequest.startAddress =
            _currentLocationAutocompleteResults[0]['name'];
        _localRequest.startId = _currentLocationAutocompleteResults[0]['id'];
        return _localRequest;
      } catch (e) {
        print('getCurrentCoordinates: $e');
        return null;
      }
    } else
      return null;
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

  Future<GeolocationStatus> isGeoLocationPermissionGranted() async {
    try {
      GeolocationStatus geolocationStatus =
          await Geolocator().checkGeolocationPermissionStatus();
      return geolocationStatus;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
