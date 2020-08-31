import 'package:geolocator/geolocator.dart';

Future<bool> isLocationPermissionGranted() async {
  try {
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
    GeolocationStatus geolocationStatus =
        await geolocator.checkGeolocationPermissionStatus();
    return (geolocationStatus == GeolocationStatus.granted) ? true : false;
  } catch (e) {
    print(e);
    return null;
  }
}
