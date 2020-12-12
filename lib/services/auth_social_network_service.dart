import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:taxiapp/models/enums/auth_type.dart';
import 'package:taxiapp/models/userModel.dart';

@lazySingleton
class AuthSocialNetwork {

  final _databaseReference = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoggedIn = false;
  UserModel user = new UserModel();

  void logout() async{
    if (isLoggedIn) {
      if (user.userType.index == AuthType.User) {
      } else if (user.userType.index == AuthType.Google) {
        _googleSignIn.signOut();

        if (user.userType.index == AuthType.Facebook) {}
      }
    }
  }

  void login(String email, String password, AuthType authType) async {
    if (isLoggedIn) {
      _googleSignIn.signOut();
      isLoggedIn = false;
    } else {
      UserCredential userCredential;

      if (authType.index == AuthType.User.index) {
        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } else if (authType.index == AuthType.Google.index) {
        GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();

        if (googleSignInAccount != null) {
          final GoogleSignInAuthentication googleAuth =
              await googleSignInAccount.authentication;

          final GoogleAuthCredential googleCredential =
              GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          userCredential = await _auth.signInWithCredential(googleCredential);
        }
      } else if (authType.index == AuthType.Facebook.index) {}

      DateTime now = new DateTime.now();

      DateFormat dateFormat = DateFormat("yyyyMMdd");
      DateFormat timeFormat = DateFormat("HHmmss");

      await _databaseReference.collection('login').add({
        'email': userCredential.user.email,
        'date': dateFormat.format(now),
        'hour': timeFormat.format(now),
      });

      user = new UserModel(
          name: userCredential.user.displayName,
          email: userCredential.user.email);

      isLoggedIn = true;
    }
  }
}
