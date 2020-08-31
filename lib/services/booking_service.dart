import 'dart:async';

import 'package:Sublin/models/booking_completed.dart';
import 'package:Sublin/models/booking_confirmed.dart';
import 'package:Sublin/models/booking_open.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingService {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Stream<List<BookingOpen>> streamOpenBookings(uid) {
    try {
      return _database
          .collection('bookings')
          .doc(uid)
          .collection('open')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((document) {
                return BookingOpen.fromJson(document.data(), document.id);
              }).toList());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<List<BookingConfirmed>> streamConfirmedBookings(uid) {
    try {
      return _database
          .collection('bookings')
          .doc(uid)
          .collection('confirmed')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((document) {
                return BookingConfirmed.fromJson(document.data(), document.id);
              }).toList());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<List<BookingCompleted>> streamCompletedBookings(uid) {
    try {
      return _database
          .collection('bookings')
          .doc(uid)
          .collection('completed')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((document) {
                return BookingCompleted.fromJson(document.data(), document.id);
              }).toList());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> confirmBooking({
    String providerId,
    String userId,
    bool isSublinEndStep,
    int index,
  }) async {
    try {
      _database
          .collection('bookings')
          .doc(providerId)
          .collection('open')
          .doc(userId)
          .set({
        isSublinEndStep ? 'sublinEndStep' : "sublinStartStep": {
          'confirmed': true,
        }
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  Future<void> completedBooking({
    String providerId,
    String userId,
    bool isSublinEndStep,
    int index,
  }) async {
    try {
      _database
          .collection('bookings')
          .doc(providerId)
          .collection('confirmed')
          .doc(userId)
          .set({
        isSublinEndStep ? 'sublinEndStep' : "sublinStartStep": {
          'completed': true,
          'completedTime': DateTime.now().microsecondsSinceEpoch,
        }
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  Future<void> noShowBooking(
      {providerId, String userId, bool isSublinEndStep, int index}) async {
    try {
      _database
          .collection('bookings')
          .doc(providerId)
          .collection('confirmed')
          .doc(userId)
          .set({
        isSublinEndStep ? 'sublinEndStep' : "sublinStartStep": {
          'noShow': true,
          'noShowTime': DateTime.now().microsecondsSinceEpoch,
        }
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }
}
