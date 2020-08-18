import 'dart:async';

import 'package:Sublin/models/booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingService {
  final Firestore _database = Firestore.instance;

  Stream<List<Booking>> streamOpenBookings(uid) {
    try {
      return _database
          .collection('booking')
          .document(uid)
          .collection('open')
          .snapshots()
          .map((snapshot) => snapshot.documents.map((document) {
                return Booking.fromMap(document.data, document.documentID);
              }).toList());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<List<Booking>> streamConfirmedBookings(uid) {
    try {
      return _database
          .collection('booking')
          .document(uid)
          .collection('confirmed')
          .snapshots()
          .map((snapshot) => snapshot.documents.map((document) {
                return Booking.fromMap(document.data, document.documentID);
              }).toList());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> confirmBooking(
      {uid, String documentId, bool isSublinEndStep}) async {
    try {
      _database
          .collection('booking')
          .document(uid)
          .collection('open')
          .document(documentId)
          .setData({
        isSublinEndStep ? 'sublinEndStep' : "sublinStartStep": {
          'confirmed': true,
        }
      }, merge: true);
    } catch (e) {
      print(e);
    }
  }
}
