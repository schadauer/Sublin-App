import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:Sublin/models/preferences.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/utils/logging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' as Foundation;

class ProviderService {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Future<List<ProviderUser>> getProviders({
    List<dynamic> communes,
  }) async {
    try {
      if (!Foundation.kReleaseMode) {
        await sublinLogging(Preferences.intLoggingProviderUser);
      }
      return _database
          .collection('providers')
          .where('communes', arrayContainsAny: communes)
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

  Future<List<ProviderUser>> getProvidersEmailOnly({
    String email,
  }) async {
    try {
      print(sha256.convert(utf8.encode(email)).toString());
      if (!Foundation.kReleaseMode) {
        await sublinLogging(Preferences.intLoggingProviderUser);
      }
      return _database
          .collection('providers')
          .where('providerPlan', isEqualTo: 'emailOnly')
          .where('targetGroup',
              arrayContains: sha256.convert(utf8.encode(email)).toString())
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
