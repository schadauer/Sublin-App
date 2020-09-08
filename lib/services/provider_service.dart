import 'dart:async';

import 'package:Sublin/models/preferences.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/utils/logging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' as Foundation;

class ProviderService {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Future<List<ProviderUser>> getProviders(List<dynamic> communes) async {
    try {
      if (!Foundation.kReleaseMode) {
        await sublinLogging(Preferences.intLoggingProviderUser);
      }
      return _database
          .collection('providers')
          .where('addresses', arrayContainsAny: communes)
          .where('providerPlan', isEqualTo: 'all')
          .get()
          .then((value) {
        return value.docs.map((e) {
          return ProviderUser.fromMap(e.data());
        }).toList();
      });
    } catch (e) {
      print(e);
      return null;
    }
  }
}
