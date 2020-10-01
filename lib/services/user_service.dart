import 'dart:async';

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
      print('streamUser: $e');
      return null;
    }
  }

  Future<void> updateHomeAddress({String uid, String address}) async {
    try {
      await _database.collection('users').doc(uid).set({
        'homeAddress': address,
      }, SetOptions(merge: true));
    } catch (e) {
      print('updateHomeAddress: $e');
    }
  }

  Future<User> getUser(String uid) async {
    try {
      return await _database.collection('users').doc(uid).get().then((value) {
        return User.fromJson(value.data());
      });
    } catch (e) {
      print('getUser: $e');
      return null;
    }
  }

  Future<void> writeUserData({String uid, User data}) async {
    try {
      await _database.collection('users').doc(uid).set(
            User().toJson(data),
          );
    } catch (e) {
      print('writeUserData: $e');
    }
  }

  Future<void> updateUserDataIsRegistrationCompleted({String uid}) async {
    try {
      await _database.collection('users').doc(uid).set({
        'isRegistrationCompleted': true,
      }, SetOptions(merge: true));
    } catch (e) {
      print('updateUserDataIsRegistrationCompleted: $e');
    }
  }

  Future<void> updateUserAddressesAndCommunes(
      {String uid, List<String> addresses, List<String> communes}) async {
    try {
      await _database.collection('users').doc(uid).set({
        'addresses': addresses,
        'communes': communes,
      }, SetOptions(merge: true));
    } catch (e) {
      print('updateUserAddressesAndCommunes $e');
    }
  }

  Future<void> updateTargetGroupUserData(
      {String uid, List<String> targetGroupList}) async {
    try {
      await _database.collection('users').doc(uid).set({
        'targetGroup': targetGroupList,
      }, SetOptions(merge: true));
    } catch (e) {
      print('updateTargetGroupUserData: $e');
    }
  }
}
