import 'dart:async';
import 'dart:convert';

import 'package:Sublin/models/provider_plan_enum.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/utils/get_formatted_city_from_formatted_address.dart';
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
      print('streamProviderUser: $e');
      return null;
    }
  }

  Future<void> setProviderUserData(
      {ProviderUser providerUser, String uid}) async {
    try {
      // if (!Foundation.kReleaseMode) {
      //   await sublinLogging(Preferences.intLoggingUsers);
      // }
      await _database
          .collection('providers')
          .doc(uid)
          .set(ProviderUser().toJson(providerUser));
    } catch (e) {
      print('setProviderUserData: $e');
    }
  }

  Future<void> updateProviderUserData({String uid, ProviderUser data}) async {
    try {
      // if (!Foundation.kReleaseMode) {
      //   await sublinLogging(Preferences.intLoggingUsers);
      // }
      await _database.collection('providers').doc(uid).set(
            ProviderUser().toJson(data),
            SetOptions(merge: true),
          );
    } catch (e) {
      print('updateProviderUserData: $e');
    }
  }

  Future<List<ProviderUser>> getProvidersForAnAddressAndForAUser(
      {String formattedAddress, User user}) async {
    List<ProviderUser> providersFromCommunes = await getProvidersFromCommunes(
        communes: [getFormattedCityFromFormattedAddress(formattedAddress)]);
    List<ProviderUser> providersEmailAddress =
        await getProvidersEmailOnly(email: user.email);
    return [
      ...providersFromCommunes,
      ...providersEmailAddress,
      // ...providersFromFormattedAddress
    ];
  }

  Future<List<ProviderUser>> getProvidersFromCommunes({
    List<String> communes,
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
          // .where('providerType',
          //     isEqualTo: ['sponsor', 'sponsorshuttle', 'shuttle'])
          .get()
          .then((value) {
        return value.docs.map((e) {
          return ProviderUser.fromJson(e.data());
        }).toList();
      });
    } catch (e) {
      print('getProviders: $e');
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
      print('getProvidersEmailOnly: $e');
      return null;
    }
  }

  Future<List<ProviderUser>> getProvidersFromFormattedAddress({
    String formattedAddress,
  }) async {
    try {
      // if (!Foundation.kReleaseMode) {
      //   await sublinLogging(Preferences.intLoggingProviderUser);
      // }
      return _database
          .collection('providers')
          .where('addresses', arrayContains: formattedAddress)
          .where('providerType',
              whereIn: ['sponsor', 'sponsorShuttle', 'shuttle'])
          .get()
          .then((value) {
            return value.docs.map((e) {
              return ProviderUser.fromJson(e.data());
            }).toList();
          });
    } catch (e) {
      print('getProvidersFromAddress: $e');
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
      print('getProvidersAsPartners: $e');
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
      print('getProviderUser: $e');
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
      await _database.collection('providers').doc(uid).set(
        {
          'providerPlan': _providerPlanString.substring(
              _providerPlanString.indexOf('.') + 1, _providerPlanString.length),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      print('updateProviderPlanProviderUserData: $e');
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
      print('updatePartnersProviderUser: $e');
    }
  }

  Future<void> updateTargetGroupProviderUser(
      {String uid, List<String> targetGroupList}) async {
    try {
      // if (!Foundation.kReleaseMode) {
      //   await sublinLogging(Preferences.intLoggingUsers);
      // }
      await _database.collection('providers').doc(uid).set({
        'targetGroup': targetGroupList,
      }, SetOptions(merge: true));
    } catch (e) {
      print('updateTargetGroupProviderUser: $e');
    }
  }

  Future<void> updateProviderNameProviderUser(
      {String uid, String providerName}) async {
    try {
      // if (!Foundation.kReleaseMode) {
      //   await sublinLogging(Preferences.intLoggingUsers);
      // }
      await _database.collection('providers').doc(uid).set({
        'providerName': providerName,
      }, SetOptions(merge: true));
    } catch (e) {
      print('updateTargetGroupProviderUser: $e');
    }
  }
}
