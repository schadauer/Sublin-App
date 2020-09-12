import 'dart:async';
import 'dart:io';

import 'package:Sublin/models/preferences_enum.dart';
import 'package:Sublin/utils/logging.dart';
import 'package:flutter/foundation.dart' as Foundation;

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:Sublin/models/routing.dart';

class RoutingService {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Stream<Routing> streamRouting(uid) {
    try {
      if (!Foundation.kReleaseMode) {
        sublinLogging(Preferences.intLoggingRoutings);
      }
      return _database.collection('routings').doc(uid).snapshots().map((snap) {
        return Routing.fromJson(snap.data());
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
        // if (!Foundation.kReleaseMode) {
        //   sublinLogging(Preferences.intLoggingRoutings);
        // }
        return Routing.fromJson(snap.data());
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
      if (!Foundation.kReleaseMode) {
        await sublinLogging(Preferences.intLoggingRoutings);
      }
    } on SocketException {
      print('no internet');
    } catch (e) {
      print(e);
    }
  }

  Future<void> bookRoute({uid}) async {
    try {
      if (!Foundation.kReleaseMode) {
        await sublinLogging(Preferences.intLoggingRoutings);
      }
      await _database.collection('routings').doc(uid).update({
        'booked': true,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<Routing> getRoute(uid) async {
    try {
      if (!Foundation.kReleaseMode) {
        await sublinLogging(Preferences.intLoggingRoutings);
      }
      return _database.collection('routings').doc(uid).get().then((value) {
        return Routing.fromJson(value.data());
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> checkIfProviderAvailable(uid) async {
    try {
      if (!Foundation.kReleaseMode) {
        await sublinLogging(Preferences.intLoggingRoutings);
      }
      return _database.collection('check').doc(uid).get().then((value) {
        return value.data()['providerAvailable'];
      });
    } catch (e) {
      print('checkIfProviderAvailable catch' + e);
      return null;
    }
  }

  Future<void> deleteCheck(uid) async {
    try {
      if (!Foundation.kReleaseMode) {
        await sublinLogging(Preferences.intLoggingRoutings);
      }
      // _database.collection('check').doc(uid).delete();
    } catch (e) {
      print('deleteCheck catch' + e);
    }
  }

  Future<void> removeProviderFromRoute(uid) async {
    try {
      if (!Foundation.kReleaseMode) {
        await sublinLogging(Preferences.intLoggingRoutings);
      }
      _database.collection('routings').doc(uid).set({'provider': ''});
    } catch (e) {
      print('removeProviderFromRoute catch ' + e);
    }
  }
}
