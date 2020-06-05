import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sublin/models/routing.dart';
// import 'package:sublin/services/auth_service.dart';

class RoutingService {
  final Firestore _database = Firestore.instance;
  // final AuthService _auth = AuthService();

  Stream<Routing> streamRouting(uid) {
    try {
      return _database
          .collection('routings')
          .document(uid)
          .snapshots()
          .map((snap) {
        print(snap.data);
        return Routing(endAddress: 'Halllllooooo');
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> requestRoute(
      {uid, endAddress, endId, startAddress, startId}) async {
    try {
      _database.collection('requests').document(uid).setData({
        'endAddress': endAddress,
        'endId': endId,
        'startAddress': startAddress,
        'startId': startId
      });
    } catch (e) {
      print(e);
    }
  }
}
