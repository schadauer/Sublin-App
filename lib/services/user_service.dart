import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sublin/models/user.dart';

class UserService {
  final Firestore _database = Firestore.instance;

  Stream<User> streamUser(uid) {
    try {
      return _database
          .collection('users')
          .document(uid)
          .snapshots()
          .map((snap) {
        print(snap.data);
        return User.fromMap(snap.data);
      });
    } catch (e) {
      print(e);
      return null;
    }
  }
}
