import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sublin/models/routing.dart';

class RoutingService {
  final Firestore _database = Firestore.instance;

  Stream<Routing> streamRouting(uid) {
    return _database.collection('users').document(uid).snapshots().map((snap) {
      return Routing.fromMap(snap.data['route']);
    });
  }
}
