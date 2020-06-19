import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sublin/models/routing.dart';

class RoutingService {
  final Firestore _database = Firestore.instance;

  Stream<Routing> streamRouting(uid) {
    try {
      return _database
          .collection('routings')
          .document(uid)
          .snapshots()
          .map((snap) {
        return Routing.fromMap(snap.data);
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> requestRoute(
      {uid, endAddress, endId, startAddress, startId}) async {
    try {
      await _database.collection('requests').document(uid).setData({
        'endAddress': endAddress,
        'endId': endId,
        'startAddress': startAddress,
        'startId': startId
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeProviderFromRoute(uid) async {
    try {
      _database.collection('routings').document(uid).setData({'provider': ''});
    } catch (e) {
      print(e);
    }
  }
}
