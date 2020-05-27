import 'package:firebase_auth/firebase_auth.dart';
import 'package:sublin/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userfromFirebseUser(FirebaseUser user) {
    if (user != null) {
      return User(user.uid);
    } else {
      return null;
    }
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _userfromFirebseUser(user));
  }

  Future register(String email, String password, String firstName) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      await Firestore.instance
          .collection('user')
          .document(user.uid)
          .setData({'firstName': firstName, 'email': email});
      return _userfromFirebseUser(user);
    } catch (e) {
      return null;
    }
  }

  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return (user);
    } catch (error) {
      print(error.toString());
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
}
