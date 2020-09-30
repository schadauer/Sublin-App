import 'dart:async';

import 'package:Sublin/models/address_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddressService {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Future<void> updateStationToAddresses(
      {String city, String formattedStation}) async {
    try {
      await _database.collection('addresses').doc(city).set({
        'stations': [formattedStation],
      }, SetOptions(merge: true));
    } catch (e) {
      print('addStationToAddresses: $e');
    }
  }

  Future<Address> getAddressesFromAddress({
    String formattedCity,
  }) async {
    try {
      return _database
          .collection('addresses')
          .doc(formattedCity)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists && documentSnapshot.data() != null) {
          return Address.fromJson(documentSnapshot.data());
        } else
          return null;
      });
    } catch (e) {
      print('getProvidersFromAddress: $e');
      return Address();
    }
  }
}
