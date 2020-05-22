import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:convert';

class Autocomplete {
  final int sessionToken = new Random().hashCode;
  static const url =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static const key = 'AIzaSyDG57-j11dg5rva-4dtjSzKN26WtTutYW8';
  String input = '';
  List output;

  Future<List> getGoogleAddressAutocomplete(String input) async {
    var client = http.Client();
    try {
      var response = await client.get(
          '$url?key=$key&sessiontoken=$sessionToken&input=$input&types=address&components=country:at&language=de');
      output = jsonDecode(response.body)['predictions'];

      // Todo: Strip country from suggestions
      // List strippedOutput = [];
      // output.replaceAll(new RegExp(", ?Österreich"), "")
      print(response.request);
      return output;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
