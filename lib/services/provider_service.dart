import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sublin/models/provider_user.dart';

class ProviderService {
  final Firestore _database = Firestore.instance;

  Stream<ProviderUser> streamProvider(String uid) {
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

  Future<ProviderUser> getAllProviderData(String uid) async {
    try {
      final data = await _database
          .collection('providers')
          .document(uid)
          .get()
          .then((value) {
        return ProviderUser.fromMap(value.data);
      });
      return data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> writeProviderUserData({String uid, ProviderUser data}) async {
    try {
      await _database.collection('providers').document(uid).setData(
            ProviderUser().toMap(data),
          );
    } catch (e) {
      print(e);
    }
  }
}
