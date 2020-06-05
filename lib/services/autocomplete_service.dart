import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:convert';

class Autocomplete {
  final int sessionToken = new Random().hashCode;
  static const url =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static const key = 'AIzaSyDIq5WwJZUG-b_UKlOGaLl4532A9XxY8Lw';
  String input = '';
  List output;
  List strippedOutput;

  Future<List> getGoogleAddressAutocomplete(String input) async {
    var client = http.Client();
    try {
      var response = await client.get(
          '$url?key=$key&sessiontoken=$sessionToken&input=$input&types=address&components=country:at&language=de');
      output = jsonDecode(response.body)['predictions'];
      strippedOutput = output.map((val) {
        return {
          'name': val['description']
              .replaceAll(new RegExp(r"(, ?Österreich| ?\d{4} ?)"), "")
              .toString(),
          'id': val['place_id'],
        };
      }).toList();
      return strippedOutput;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
