import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:Sublin/models/routing.dart';

class RoutingService {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Stream<Routing> streamRouting(uid) {
    try {
      return _database.collection('routings').doc(uid).snapshots().map((snap) {
        return Routing.fromMap(snap.data());
      });
    } on SocketException {
      print('no internet');
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<Routing> streamCheck(uid) {
    try {
      return _database.collection('check').doc(uid).snapshots().map((snap) {
        return Routing.fromMap(snap.data());
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> requestRoute(
      {uid,
      endAddress,
      endId,
      startAddress,
      startId,
      checkAddress = false,
      timestamp}) async {
    try {
      // await _database.collection('routings').document(uid).delete();
      await _database.collection('requests').doc(uid).set({
        'endAddress': endAddress,
        'endId': endId,
        'startAddress': startAddress,
        'startId': startId,
        'checkAddress': checkAddress,
        'timestamp': timestamp,
      });
    } on SocketException {
      print('no internet');
    } catch (e) {
      print(e);
    }
  }

  Future<void> bookRoute({uid}) async {
    try {
      await _database.collection('routings').doc(uid).update({
        'booked': true,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<Routing> getRoute(uid) async {
    try {
      return _database.collection('routings').doc(uid).get().then((value) {
        return Routing.fromMap(value.data());
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> checkIfProviderAvailable(uid) async {
    return _database.collection('check').doc(uid).get().then((value) {
      return value.data()['providerAvailable'];
    });
  }

  Future<void> deleteCheck(uid) async {
    try {
      _database.collection('check').doc(uid).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeProviderFromRoute(uid) async {
    try {
      _database.collection('routings').doc(uid).set({'provider': ''});
    } catch (e) {
      print(e);
    }
  }
}
