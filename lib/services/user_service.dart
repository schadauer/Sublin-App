import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:Sublin/models/user.dart';

class UserService {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Stream<User> streamUser(uid) {
    try {
      return _database.collection('users').doc(uid).snapshots().map((snap) {
        return User.fromJson(snap.data());
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> writeUserData({String uid, User data}) async {
    try {
      await _database.collection('users').doc(uid).set(
            User().toJson(data),
          );
    } catch (e) {
      print(e);
    }
  }
}
