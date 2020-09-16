import 'dart:async';
import 'dart:convert';

import 'package:Sublin/models/provider_plan_enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:Sublin/models/provider_user.dart';

class ProviderUserService {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Stream<ProviderUser> streamProviderUser(String uid) {
    try {
      // if (!Foundation.kReleaseMode) {
      //   sublinLogging(Preferences.intLoggingUsers);
      // }
      return _database.collection('providers').doc(uid).snapshots().map((snap) {
        return ProviderUser.fromJson(snap.data());
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> setProviderUserData({String uid, ProviderUser data}) async {
    try {
      // if (!Foundation.kReleaseMode) {
      //   await sublinLogging(Preferences.intLoggingUsers);
      // }
      await _database
          .collection('providers')
          .doc(uid)
          .set(ProviderUser().toMap(data));
    } catch (e) {
      print('updateProviderUser: $e');
    }
  }

  Future<void> updateProviderUserData({String uid, ProviderUser data}) async {
    try {
      // if (!Foundation.kReleaseMode) {
      //   await sublinLogging(Preferences.intLoggingUsers);
      // }
      await _database
          .collection('providers')
          .doc(uid)
          .update(ProviderUser().toMap(data));
    } catch (e) {
      print('updateProviderUser: $e');
    }
  }

  Future<List<ProviderUser>> getProviders({
    List<dynamic> communes,
  }) async {
    try {
      // if (!Foundation.kReleaseMode) {
      //   await sublinLogging(Preferences.intLoggingProviderUser);
      // }
      return _database
          .collection('providers')
          .where('communes',
              arrayContainsAny: communes.length == 0 ? [''] : communes)
          .where('providerPlan', isEqualTo: 'all')
          .get()
          .then((value) {
        return value.docs.map((e) {
          return ProviderUser.fromJson(e.data());
        }).toList();
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<ProviderUser>> getProvidersAsPartners({
    String uid,
  }) async {
    try {
      // if (!Foundation.kReleaseMode) {
      //   await sublinLogging(Preferences.intLoggingProviderUser);
      // }
      return _database
          .collection('providers')
          .where('partners', arrayContains: uid)
          .get()
          .then((value) {
        return value.docs.map((e) {
          return ProviderUser.fromJson(e.data());
        }).toList();
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ProviderUser> getProviderUser(String uid) async {
    try {
      // if (!Foundation.kReleaseMode) {
      //   await sublinLogging(Preferences.intLoggingUsers);
      // }
      return await _database
          .collection('providers')
          .doc(uid)
          .get()
          .then((value) {
        return ProviderUser.fromJson(value.data());
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<ProviderUser>> getProvidersEmailOnly({
    String email,
  }) async {
    try {
      // if (!Foundation.kReleaseMode) {
      //   await sublinLogging(Preferences.intLoggingProviderUser);
      // }
      return _database
          .collection('providers')
          .where('providerPlan', isEqualTo: 'emailOnly')
          .where('targetGroup',
              arrayContains: sha256.convert(utf8.encode(email)).toString())
          .get()
          .then((value) {
        return value.docs.map((e) {
          return ProviderUser.fromJson(e.data());
        }).toList();
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> updateProviderPlanProviderUserData(
      {String uid, ProviderPlan providerPlan}) async {
    try {
      String _providerPlanString = providerPlan.toString();
      // if (!Foundation.kReleaseMode) {
      //   await sublinLogging(Preferences.intLoggingUsers);
      // }
      await _database.collection('providers').doc(uid).set({
        'providerPlan': _providerPlanString.substring(
            _providerPlanString.indexOf('.') + 1, _providerPlanString.length),
      }, SetOptions(merge: true));
    } catch (e) {
      print('updateProviderUser: $e');
    }
  }

  Future<void> updatePartnersProviderUser(
      {String uid, List<String> partners}) async {
    try {
      // if (!Foundation.kReleaseMode) {
      //   await sublinLogging(Preferences.intLoggingUsers);
      // }
      await _database.collection('providers').doc(uid).set({
        'partners': partners,
      }, SetOptions(merge: true));
    } catch (e) {
      print('updateProviderUser: $e');
    }
  }

  Future<void> updateTargetGroupProviderUser(
      {String uid, List<dynamic> targetGroupList}) async {
    try {
      // if (!Foundation.kReleaseMode) {
      //   await sublinLogging(Preferences.intLoggingUsers);
      // }
      await _database.collection('providers').doc(uid).set({
        'targetGroup': targetGroupList,
      }, SetOptions(merge: true));
    } catch (e) {
      print('updateProviderUser: $e');
    }
  }
}
