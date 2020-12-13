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
  UserModel user = UserModel();

  void logout() async{

    if (isLoggedIn) {

      if (user.userType.index == AuthType.Google.index) {

        if (_googleSignIn != null) {
          await _googleSignIn.signOut();
        }

      } else if (user.userType.index == AuthType.Facebook.index) {

      }

    }

    isLoggedIn = false;
    user = UserModel();
  }

  void login(String email, String password, AuthType authType) async {
    if (isLoggedIn) {
      
      print('THE USER IS ALREADY LOGGED IN');

    } else {
      
      UserCredential userCredential;
      user = UserModel();

      if (authType.index == AuthType.User.index) {

        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

      } else if (authType.index == AuthType.Google.index) {

        var googleSignInAccount = await _googleSignIn.signIn();

        if (googleSignInAccount != null) {
          final googleAuth =
              await googleSignInAccount.authentication;

          final GoogleAuthCredential googleCredential =
              GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          userCredential = await _auth.signInWithCredential(googleCredential);
        }
        
      } else if (authType.index == AuthType.Facebook.index) {}

      if (userCredential != null) {

        // SI LA AUTENTICACION FUE EXITOSA
        var now = DateTime.now();

        var dateFormat = DateFormat('yyyyMMdd');
        var timeFormat = DateFormat('HHmmss');

        await _databaseReference.collection('login').add({
          'email': userCredential.user.email,
          'date': dateFormat.format(now),
          'hour': timeFormat.format(now),
        });

        user.name =  userCredential.user.displayName;
        user.email = userCredential.user.email;
        user.uid = userCredential.user.uid;
        user.authType = authType;

        isLoggedIn = true;

      }

    }
  }
}
