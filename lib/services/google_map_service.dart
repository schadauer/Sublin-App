import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:convert';

class GoogleMapService {
  final int sessionToken = new Random().hashCode;
  static const autocompleteUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static const key = 'AIzaSyDIq5WwJZUG-b_UKlOGaLl4532A9XxY8Lw';

  List output;
  List strippedOutput;
  String type;

  Future<List> getGoogleAddressAutocomplete(
    String input,
    String restrictions,
  ) async {
    var client = http.Client();

    try {
      type = (restrictions != '') ? 'types=establishment' : '';
      var response = await client.get(
          '$autocompleteUrl?key=$key&sessiontoken=$sessionToken&input=$input&$type&types=address&components=country:at&language=de');
      output = jsonDecode(response.body)['predictions'];
      strippedOutput = output.map((val) {
        return {
          'name': val['description']
              .replaceAll(new RegExp(r"(, ?Österreich| ?\d{4} ?)"), "")
              .toString(),
          'id': val['place_id'],
        };
      }).toList();
      // print(strippedOutput);
      return strippedOutput;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
