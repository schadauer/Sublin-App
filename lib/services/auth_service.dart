import 'package:Sublin/models/user_type.dart';
import 'package:Sublin/utils/get_random_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Sublin/models/auth.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/user.dart' as sublin;
import 'package:Sublin/services/provider_user_service.dart';
import 'package:Sublin/services/user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ProviderUser providerUser = ProviderUser();

  Stream<Auth> get userStream {
    return _auth
        .authStateChanges()
        .map((User user) => _userfromFirebseUser(user));
  }

  Future<Auth> register({
    String email,
    String password,
    String firstName,
    UserType userType,

    // String providerAddress,
    // String providerType,
  }) async {
    try {
      final sublin.User user = sublin.User(
        email: email,
        firstName: firstName,
        userType: userType,
        isRegistrationCompleted: userType == UserType.user ? true : false,
      );
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User authUser = result.user;
      // await Firestore.instance.collection('users').document(user.uid).setData({
      //   // 'firstName': firstName,
      //   'email': email,
      // });
      await UserService().writeUserData(uid: authUser.uid, data: user);
      await authUser.sendEmailVerification();

      print(authUser.uid);
      print(providerUser);

      if (userType == UserType.provider || userType == UserType.sponsor) {
        await ProviderService()
            .setProviderUserData(uid: authUser.uid, data: providerUser);
      }
      return _userfromFirebseUser(authUser);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future signIn({String email, String password}) async {
    try {
      password = password ?? getRandomString(20);
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } catch (e) {
      print(e);
      return null;
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
