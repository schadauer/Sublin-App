import 'dart:async';

import 'package:Sublin/models/delimiter.dart';
import 'package:Sublin/models/preferences.dart';
import 'package:Sublin/utils/logging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' as Foundation;

class AutocompleteStationsService {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Future<List<dynamic>> getStations(String input) async {
    try {
      if (!Foundation.kReleaseMode) {
        await sublinLogging(Preferences.intLoggingAutocomplete);
      }
      return _database
          .collection('stations')
          .limit(5)
          .where('terms', arrayContains: input)
          .get()
          .then((value) {
        return value.docs.map((e) {
          return {
            'name': Delimiter.station + e.data()['name'],
            'id': '',
            'terms': [],
            'isCompany': false,
          };
        }).toList();
      });
    } catch (e) {
      print(e);
      return null;
    }
  }
}
