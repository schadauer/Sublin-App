import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' as Foundation;

import 'package:Sublin/models/preferences.dart';
import 'package:Sublin/utils/logging.dart';
import 'package:Sublin/models/provider_user.dart';

class ProviderService {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Stream<ProviderUser> streamProviderUserData(String uid) {
    try {
      if (!Foundation.kReleaseMode) {
        sublinLogging(Preferences.intLoggingUsers);
      }
      return _database.collection('providers').doc(uid).snapshots().map((snap) {
        return ProviderUser.fromMap(snap.data());
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ProviderUser> getProviderUserData(String uid) async {
    try {
      if (!Foundation.kReleaseMode) {
        await sublinLogging(Preferences.intLoggingUsers);
      }
      final data =
          await _database.collection('providers').doc(uid).get().then((value) {
        return ProviderUser.fromMap(value.data());
      });
      return data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> setProviderUserData({String uid, ProviderUser data}) async {
    try {
      if (!Foundation.kReleaseMode) {
        await sublinLogging(Preferences.intLoggingUsers);
      }
      await _database
          .collection('providers')
          .doc(uid)
          .set(ProviderUser().toMap(data));
    } catch (e) {
      print('updateProviderUser: $e');
    }
  }

  Future<void> updateProviderUserData({String uid, ProviderUser data}) async {
    try {
      if (!Foundation.kReleaseMode) {
        await sublinLogging(Preferences.intLoggingUsers);
      }
      await _database
          .collection('providers')
          .doc(uid)
          .update(ProviderUser().toMap(data));
    } catch (e) {
      print('updateProviderUser: $e');
    }
  }
}
