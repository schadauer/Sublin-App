import 'package:geolocator/geolocator.dart';

Future<bool> isLocationPermissionGranted() async {
  try {
    LocationPermission geolocationStatus = await Geolocator.checkPermission();
    return [LocationPermission.always, LocationPermission.whileInUse]
        .contains(geolocationStatus);
  } catch (e) {
    print(e);
    return null;
  }
}
