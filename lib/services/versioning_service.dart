import 'package:Sublin/models/versioning_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VersioningService {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Stream<Versioning> streamVersioning() {
    try {
      // if (!Foundation.kReleaseMode) {
      //   sublinLogging(Preferences.intLoggingUsers);
      // }
      return _database
          .collection('versioning')
          .doc('latest')
          .snapshots()
          .map((snap) {
        return Versioning.fromJson(snap.data());
      });
    } catch (e) {
      print('streamVersioning: $e');
      return null;
    }
  }
}
