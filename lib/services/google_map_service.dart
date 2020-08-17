import 'dart:io';

import 'package:Sublin/models/delimiter.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:convert';

class GoogleMapService {
  final int sessionToken = new Random().hashCode;
  static const autocompleteUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static const placeUrl =
      'https://maps.googleapis.com/maps/api/place/details/json';
  static const key = 'AIzaSyDIq5WwJZUG-b_UKlOGaLl4532A9XxY8Lw';
  String type;

  Future<List> getGoogleAddressAutocomplete({
    String input,
    String restrictions = '',
    bool cityOnly = false,
    bool isStation = false,
  }) async {
    List output;
    List strippedOutput;
    var client = http.Client();
    try {
      input = (restrictions != '')
          ? restrictions +
              ' ' +
              _removeRestrictionString(input: input, restriction: restrictions)
          : input;
      var response = await client.get(
          '$autocompleteUrl?key=$key&sessiontoken=$sessionToken&input=$input&components=country:at&language=de');
      output = jsonDecode(response.body)['predictions'];
      strippedOutput = output.map((val) {
        String name = val['description']
            .replaceAll(new RegExp(r"(, ?Österreich| ?\d{4} ?)"), "")
            .toString();
        return {
          'name': _convertGoogleToFormattedAddress(
            description: val['description'],
            terms: val['terms'],
            types: val['types'],
            isStation: isStation,
          ),
          'id': val['place_id'],
          'terms': val['terms'],
          'isCompany': val['types'].indexOf('establishment') != -1
        };
        // return {
        //   'name': name,
        //   'id': val['place_id'],
        //   'terms': val['terms'],
        //   'isCompany': val['types'].indexOf('establishment') != -1
        // };
      }).toList();
      return strippedOutput;
    } on SocketException {
      print('No internet connection');
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Future<String> getFormattedAddressWithGooglePlace(
  //   String googleId,
  // ) async {
  //   List output;
  //   String formattedAddress = '';
  //   var client = http.Client();
  //   try {
  //     var response = await client.get(
  //         '$placeUrl?place_id=$googleId&fields=address_components&key=$key');
  //     output = await jsonDecode(response.body)['result']['address_components'];
  //     for (var i = 0; i < output.length; i++) {
  //       if (output[i]['types'][0] == 'postal_code') {
  //         formattedAddress = formattedAddress + '__' + output[i]['long_name'];
  //       }
  //       if (output[i]['types'][0] == 'route') {
  //         formattedAddress = output[i]['long_name'] + formattedAddress;
  //       }
  //     }
  //     return formattedAddress;
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }
}

String _removeRestrictionString({String input, String restriction = ''}) {
  input = input.toLowerCase();
  restriction = restriction.toLowerCase();
  int restrictionLength = restriction.length;
  if (input.length >= restrictionLength) {
    int pos = input.indexOf(new RegExp(r'' + restriction + ''));
    if (pos != -1) {
      input = input.substring(restrictionLength);
    }
  }
  return input;
}

String _convertGoogleToFormattedAddress({
  String description,
  List<dynamic> terms,
  List<dynamic> types,
  bool isStation = false,
  bool onlyCity = false,
}) {
  // Check if house number is given form Google address pattern

  String numberPart = '';
  String streetPart = '';
  String cityPart = '';
  String countryPart = '';
  String companyPart = '';
  String stationPart = '';

  bool isValidAddress = true;
  bool isCompany = types.indexOf('establishment') != -1 ? true : false;
  bool isAddressStreet = types.indexOf('street_address') != -1 ? true : false;
  int lengthTerms = terms.length;

  if (isStation) {
    stationPart = Delimiter.station + terms[0]['value'];
  } else if (!isStation) {
    if (isAddressStreet && terms.length == 3) {
      // There is street and number in one string
      RegExp regExp = RegExp(r"\d+$");
      String addressWithNumber = terms[0]['value'];

      if (regExp.hasMatch(addressWithNumber)) {
        String number = regExp.stringMatch(addressWithNumber).toString();
        numberPart = Delimiter.number + number;
        int indexOfNumber = addressWithNumber.indexOf(number);
        if (indexOfNumber > 0) {
          streetPart = Delimiter.street +
              addressWithNumber.substring(0, indexOfNumber).trim();
        }
      }
    }
    if (isAddressStreet && terms.length == 4) {
      streetPart = Delimiter.street + terms[0]['value'];
      numberPart = Delimiter.number + terms[1]['value'];
    }
    if (!isAddressStreet && terms.length == 3) {
      streetPart = Delimiter.street + terms[0]['value'];
    }
    if (!isAddressStreet && !isCompany && terms.length == 4) {
      streetPart = Delimiter.street + terms[0]['value'];
      numberPart = Delimiter.number + terms[1]['value'];
    }
    if (isCompany && terms.length == 4) {
      companyPart = Delimiter.company + terms[0]['value'];
      numberPart = Delimiter.street + terms[1]['value'];
    }
  }

  cityPart = Delimiter.city + terms[lengthTerms - 2]['value'];
  countryPart =
      Delimiter.country + _getCountryCode(terms[lengthTerms - 1]['value']);

  if (isAddressStreet && terms.length <= 2) isValidAddress = false;
  // print(terms);
  // print(types);
  print(isValidAddress
      ? stationPart +
          countryPart +
          cityPart +
          streetPart +
          numberPart +
          companyPart
      : '');

  return isValidAddress
      ? stationPart +
          countryPart +
          cityPart +
          streetPart +
          numberPart +
          companyPart
      : '';
}

String _getCountryCode(String country) {
  String code;
  switch (country) {
    case 'Österreich':
    case 'Austria':
      code = 'AT';
      break;
    case 'Deutschland':
      code = 'DE';
      break;
    default:
      code = 'AT';
  }
  return code;
}
