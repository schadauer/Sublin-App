import 'dart:async';

import 'package:Sublin/models/preferences_enum.dart';
import 'package:Sublin/utils/logging.dart';
import 'package:flutter/foundation.dart' as Foundation;

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:Sublin/models/user_class.dart';

class UserService {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Stream<User> streamUser(uid) {
    try {
      // if (!Foundation.kReleaseMode) {
      //   sublinLogging(Preferences.intLoggingUsers);
      // }
      return _database.collection('users').doc(uid).snapshots().map((snap) {
        return User.fromJson(snap.data());
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> updateHomeAddress({String uid, String address}) async {
    try {
      if (!Foundation.kReleaseMode) {
        await sublinLogging(Preferences.intLoggingUsers);
      }
      await _database.collection('users').doc(uid).set({
        'homeAddress': address,
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  Future<User> getUser(String uid) async {
    try {
      if (!Foundation.kReleaseMode) {
        await sublinLogging(Preferences.intLoggingUsers);
      }
      return await _database.collection('users').doc(uid).get().then((value) {
        return User.fromJson(value.data());
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> writeUserData({String uid, User data}) async {
    try {
      if (!Foundation.kReleaseMode) {
        await sublinLogging(Preferences.intLoggingUsers);
      }
      await _database.collection('users').doc(uid).set(
            User().toJson(data),
          );
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUserDataIsRegistrationCompleted({String uid}) async {
    try {
      if (!Foundation.kReleaseMode) {
        await sublinLogging(Preferences.intLoggingUsers);
      }
      await _database.collection('users').doc(uid).set({
        'isRegistrationCompleted': true,
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateTargetGroupUserData(
      {String uid, List<dynamic> targetGroupList}) async {
    try {
      if (!Foundation.kReleaseMode) {
        await sublinLogging(Preferences.intLoggingUsers);
      }
      await _database.collection('users').doc(uid).set({
        'targetGroup': targetGroupList,
      }, SetOptions(merge: true));
    } catch (e) {
      print('updateProviderUser: $e');
    }
  }
}
