import 'dart:io';

import 'package:Sublin/models/delimiter_class.dart';
import 'package:Sublin/models/preferences_enum.dart';
import 'package:Sublin/config/google.gen.dart';
import 'package:Sublin/utils/logging.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:convert';
import 'package:flutter/foundation.dart' as Foundation;

class GoogleMapService {
  final int sessionToken = new Random().hashCode;
  static const autocompleteUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static const placeUrl =
      'https://maps.googleapis.com/maps/api/place/details/json';
  String type;

  Future<List> getGoogleAddressAutocomplete({
    String input,
    String restrictions = '',
    bool cityOnly = false,
    bool isStation = false,
    String addressTypes = '',
  }) async {
    List output;
    List formattedOutput;
    var client = http.Client();
    try {
      if (!Foundation.kReleaseMode) {
        await sublinLogging(Preferences.intLoggingAutocomplete);
      }
      input = (restrictions != '')
          ? restrictions +
              ' ' +
              _removeRestrictionString(input: input, restriction: restrictions)
          : input;
      var response = await client.get(Uri.parse(
          '$autocompleteUrl?key=$googleApiKey&sessiontoken=$sessionToken&input=$input&types=$addressTypes&location&components=country:at&language=de'));
      output = jsonDecode(response.body)['predictions'];
      formattedOutput = output.map((val) {
        Map output = {
          'name': _convertGoogleToFormattedAddress(
              description: val['description'],
              terms: val['terms'],
              types: val['types'],
              isStation: isStation,
              cityOnly: cityOnly),
          'id': val['place_id'],
          'terms': val['terms'],
          'isCompany': val['types'].indexOf('establishment') != -1
        };
        return output;
      }).toList();
      formattedOutput.removeWhere((item) => item['name'] == '');
      return formattedOutput;
    } on SocketException {
      print('No internet connection');
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
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
  bool cityOnly = false,
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
  if (cityOnly == true && terms.length > 2) isValidAddress = false;

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
