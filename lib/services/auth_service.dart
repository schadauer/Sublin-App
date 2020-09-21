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

  ProviderUser providerUser = ProviderUser();
  UserCredential userCredential;

  Stream<Auth> get userStream {
    return _auth.authStateChanges().map((User user) {
      return _userfromFirebseUser(user);
    });
  }

  Future<Auth> register({
    String email,
    String password,
    String firstName,
    UserType userType,
  }) async {
    try {
      dynamic result =
          await registerWithEmailAndPassword(email: email, password: password);
      if (result is UserCredential)
        userCredential = result;
      else {
        return null;
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
      // if (!Foundation.kReleaseMode) {
      //   sublinLogging(Preferences.intLoggingUsers);
      // }
      await authUser.sendEmailVerification();

      if (userType == UserType.provider || userType == UserType.sponsor) {
        await ProviderUserService().setProviderUserData(data: providerUser);
      }
      return _userfromFirebseUser(authUser);
    } catch (e) {
      print(e.code);
      return null;
    }
  }

  Future<dynamic> registerWithEmailAndPassword(
      {String email, String password}) async {
    dynamic userCredential;
    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print(e.toString());
    }
    return userCredential;
  }

  Future signIn({String email, String password}) async {
    try {
      password = password ?? getRandomString(20);
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      // if (!Foundation.kReleaseMode) {
      //   await sublinLogging(Preferences.intLoggingUsers);
      // }
      User user = result.user;
      return user;
    } catch (e) {
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
    }
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
      // if (!Foundation.kReleaseMode) {
      //   sublinLogging(Preferences.intLoggingAuth);
      // }
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
