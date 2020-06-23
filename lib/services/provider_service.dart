import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sublin/models/provider_user.dart';

class ProviderService {
  final Firestore _database = Firestore.instance;

  Stream<ProviderUser> streamProvider(uid) {
    try {
      return _database
          .collection('providers')
          .document(uid)
          .snapshots()
          .map((snap) {
        return ProviderUser.fromMap(snap.data);
      });
    } catch (e) {
      print(e);
      return null;
    }
  }
}
