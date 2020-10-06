import 'package:Sublin/models/sublin_error_enum.dart';
import 'package:Sublin/models/user_type_enum.dart';
import 'package:Sublin/utils/get_random_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Sublin/models/auth_class.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/user_class.dart' as sublin;
import 'package:Sublin/services/provider_user_service.dart';
import 'package:Sublin/services/user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String errorMessage;

  UserCredential userCredential;

  Stream<Auth> get userStream {
    return _auth.authStateChanges().map((User user) {
      return _userfromFirebseUser(user);
    });
  }

  Future<SublinError> register({
    String email,
    String password,
    String firstName,
    UserType userType,
  }) async {
    try {
      dynamic result =
          await registerWithEmailAndPassword(email: email, password: password);
      if (result['userCredential'] is UserCredential &&
          result['userCredential'] != null)
        userCredential = result['userCredential'];
      else {
        return result['sublinError'];
      }
      User authUser = userCredential.user;
      final sublin.User user = sublin.User(
        uid: authUser.uid,
        email: email,
        firstName: firstName,
        userType: userType,
        isRegistrationCompleted: userType == UserType.user ? true : false,
      );
      await UserService().writeUserData(uid: authUser.uid, data: user);
      await authUser.sendEmailVerification();
      ProviderUser providerUser = ProviderUser(uid: authUser.uid);
      if (userType == UserType.provider || userType == UserType.sponsor) {
        await ProviderUserService()
            .setProviderUserData(providerUser: providerUser, uid: authUser.uid);
      }
      return result['sublinError'];
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<dynamic> registerWithEmailAndPassword(
      {String email, String password}) async {
    SublinError sublinError = SublinError.none;
    dynamic userCredential;
    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        sublinError = SublinError.emailAlreadyInUse;
        print('Die E-Mailadresse existiert bereits.');
      }
    }
    return {
      'userCredential': userCredential,
      'sublinError': sublinError,
    };
  }

  Future<SublinError> signIn({String email, String password}) async {
    SublinError sublinError = SublinError.none;
    try {
      sublinError = SublinError.none;
      password = password ?? getRandomString(20);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        sublinError = SublinError.emailNotFound;
        print('Deine E-Mailaddresse wurde nicht gefunden.');
      } else if (e.code == 'wrong-password') {
        sublinError = SublinError.wrongPassword;
        print('Dein Passwort ist nicht korrekt.');
      }
    }
    return sublinError;
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Future<void> signInWithEmailAndLink(String email) async {
  //   return await _auth.sendSignInLinkToEmail(
  //     email: email,
  //     actionCodeSettings: null,
  //     url: 'https://simpledesign.page.link/qL6j',
  //     handleCodeInApp: true,
  //     iOSBundleID: 'io.simpledesign.sublin',
  //     androidPackageName: 'io.simpledesign.sublin',
  //     androidInstallIfNotAvailable: true,
  //     androidMinimumVersion: "1",
  //   );
  // }

  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  Auth _userfromFirebseUser(User user) {
    if (user != null) {
      return Auth(uid: user.uid, isEmailVerified: user.emailVerified);
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
  //
  //     return null;
  //   }
  // }
}
