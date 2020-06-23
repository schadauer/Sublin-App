import 'package:firebase_auth/firebase_auth.dart';
import 'package:sublin/models/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<Auth> get user {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _userfromFirebseUser(user));
  }

  Future<Auth> register({
    String email,
    String password,
    String firstName,
    String type,
    String providerName,
    String providerAddress,
    String providerType,
  }) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      await Firestore.instance.collection('users').document(user.uid).setData({
        // 'firstName': firstName,
        'email': email,
      });
      await user.sendEmailVerification();
      if (type == 'provider') {
        await Firestore.instance
            .collection('providers')
            .document(user.uid)
            .setData({
          'requestOperation': true,
        });
      }

      return _userfromFirebseUser(user);
    } catch (e) {
      return null;
    }
  }

  Future signIn(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  Auth _userfromFirebseUser(FirebaseUser user) {
    if (user != null) {
      return Auth(uid: user.uid, isEmailVerified: user.isEmailVerified);
    } else {
      return null;
    }
  }

  // Future signInAnon() async {
  //   try {
  //     AuthResult result = await _auth.signInAnonymously();
  //     FirebaseUser user = result.user;
  //     return (user);
  //   } catch (error) {
  //     print(error.toString());
  //     return null;
  //   }
  // }
}
