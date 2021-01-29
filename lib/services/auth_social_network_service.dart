import 'dart:async';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:taxiapp/models/enums/auth_type.dart';
import 'package:taxiapp/models/user_model.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

@lazySingleton
class AuthSocialNetwork {
  final _databaseReference = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookLogin _facebookSignIn = FacebookLogin();

  bool isLoggedIn = false;
  UserModel user = UserModel();
  String idToken = '';

  StreamSubscription userModelSubscription;

  void logout() async {
    if (isLoggedIn) {
      print(user.authType.index);
      if (user.authType.index == AuthType.Google.index) {
        if (_googleSignIn != null) {
          await _googleSignIn.signOut();
        }
      } else if (user.authType.index == AuthType.Facebook.index) {
        if (_facebookSignIn != null) {
          await _facebookSignIn.logOut();
        }
      }
      await _auth.signOut();
    }

    isLoggedIn = false;
    user = UserModel();
    idToken = '';
  }

  void login(String email, String password, AuthType authType) async {
    isLoggedIn = false;
    UserCredential userCredential;
    user = UserModel();
    idToken = '';

    if (authType == AuthType.User) {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } else if (authType == AuthType.Google) {
      var googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final googleAuth = await googleSignInAccount.authentication;

        final GoogleAuthCredential googleCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential = await _auth.signInWithCredential(googleCredential);
      }
    } else if (authType.index == AuthType.Facebook.index) {
      _facebookSignIn.loginBehavior = FacebookLoginBehavior.webViewOnly;
      final result = await _facebookSignIn.logIn(['email']);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final facebookCredential = FacebookAuthProvider.credential(result.accessToken.token);
          userCredential = await _auth.signInWithCredential(facebookCredential);

          break;
        case FacebookLoginStatus.cancelledByUser:
          break;
        case FacebookLoginStatus.error:
          break;
      }

    } else if (authType == AuthType.Apple) {
      final result = await AppleSignIn.performRequests([
        const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      switch (result.status) {
        case AuthorizationStatus.authorized:
          final appleAuth = result.credential;
          final oAuthProvider = OAuthProvider('apple.com');

          final appleCredential =
              oAuthProvider.credential(idToken: String.fromCharCodes(appleAuth.identityToken), accessToken: String.fromCharCodes(appleAuth.authorizationCode));

          userCredential = await _auth.signInWithCredential(appleCredential);
          break;
        case AuthorizationStatus.error:
          break;
        case AuthorizationStatus.cancelled:
          break;
      }
    }

    if (userCredential != null) {
      // SI LA AUTENTICACION FUE EXITOSA

      idToken = await userCredential.user.getIdToken();

      await _databaseReference.collection('login').add({
        'email': userCredential.user.providerData.first.email,
        'datetime': Timestamp.now(),
      });
      // FIREBASE DONT RETURN PHONENUMBER
      // user.phone = userCredential.user.providerData.first.phoneNumber;
      user.name = userCredential.user.providerData.first.displayName;
      user.email = userCredential.user.providerData.first.email;
      user.image = userCredential.user.providerData.first.photoURL;
      user.uid = userCredential.user.uid;
      user.authType = authType;

      isLoggedIn = true;
    }
  }

  Future<UserCredential> createUser(String email, String password) async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  }

  void sendPasswordResetEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  void sendSignInLinkToEmail(String email) async {
    await FirebaseAuth.instance.sendSignInLinkToEmail(email: email, actionCodeSettings: null);
  }

  void modifyPassword(String newPassword) async {
    await FirebaseAuth.instance.currentUser.updatePassword(newPassword);
  }
}
