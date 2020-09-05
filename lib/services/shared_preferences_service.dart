import 'package:Sublin/models/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isKeyPresentSF(key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.containsKey(key);
}

Future<void> addStringToSF(Preferences key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key.toString(), value);
}

Future<void> addIntToSF(Preferences key, int value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt(key.toString(), value);
}

Future<void> addDoubleToSF(Preferences key, double value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setDouble(key.toString(), value);
}

Future<void> addBoolToSF(Preferences key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key.toString(), value);
}

Future<String> getStringValuesSF(Preferences key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String stringValue = prefs.getString(key.toString()) ?? '';
  return stringValue;
}

Future<bool> getBoolValuesSF(Preferences key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return bool
  bool boolValue = prefs.getBool(key.toString()) ?? false;
  return boolValue;
}

Future<int> getIntValuesSF(Preferences key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return int
  int intValue = prefs.getInt(key.toString()) ?? 0;
  return intValue;
}

Future<double> getDoubleValuesSF(Preferences key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return double
  double doubleValue = prefs.getDouble(key.toString()) ?? 0.0;
  return doubleValue;
}

Future<void> removeFromSF(key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(key.toString());
}
