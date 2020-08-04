import 'package:Sublin/utils/format_address.dart';
import 'package:Sublin/utils/get_part_of_address.dart';
import 'package:flutter/material.dart';
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
  }) async {
    List output;
    List strippedOutput;
    var client = http.Client();
    try {
      input = (restrictions != '')
          ? restrictions +
              ' ' +
              removeRestrictionString(input: input, restriction: restrictions)
          : input;
      var response = await client.get(
          '$autocompleteUrl?key=$key&sessiontoken=$sessionToken&input=$input&components=country:at&language=de');
      output = jsonDecode(response.body)['predictions'];
      strippedOutput = output.map((val) {
        String name = val['description']
            .replaceAll(new RegExp(r"(, ?Österreich| ?\d{4} ?)"), "")
            .toString();
        return {
          'name': name,
          'id': val['place_id'],
        };
      }).toList();
      return strippedOutput;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> getFormattedAddressWithGooglePlace(
    String googleId,
  ) async {
    List output;
    String formattedAddress = '';
    var client = http.Client();
    try {
      var response = await client.get(
          '$placeUrl?place_id=$googleId&fields=address_components&key=$key');
      output = await jsonDecode(response.body)['result']['address_components'];
      for (var i = 0; i < output.length; i++) {
        if (output[i]['types'][0] == 'postal_code') {
          formattedAddress = formattedAddress + '__' + output[i]['long_name'];
        }
        if (output[i]['types'][0] == 'route') {
          formattedAddress = output[i]['long_name'] + formattedAddress;
        }
      }
      return formattedAddress;
    } catch (e) {
      print(e);
      return null;
    }
  }
}

String removeRestrictionString({String input, String restriction = ''}) {
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
