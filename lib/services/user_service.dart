import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:Sublin/models/user.dart';

class UserService {
  final Firestore _database = Firestore.instance;

  Stream<User> streamUser(uid) {
    try {
      return _database
          .collection('users')
          .document(uid)
          .snapshots()
          .map((snap) {
        return User.fromMap(snap.data);
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> writeUserData({String uid, User data}) async {
    try {
      await _database.collection('users').document(uid).setData(
            User().toMap(data),
          );
    } catch (e) {
      print(e);
    }
  }
}
