import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:taxiapp/models/enums/auth_type.dart';
import 'package:taxiapp/models/userModel.dart';

@lazySingleton
class FirestoreUser {

  final databaseReference = FirebaseFirestore.instance;

  final String collectionUser = 'user';

  Future<bool> userRegister(UserModel user) async {
    try{
      await databaseReference.collection(collectionUser).doc(user.email).set({
            'name': user.name,
            'email': user.email.toLowerCase(),
            'phone': user.phone,
            'uid': user.uid,
            'authType': user.authType.index,
            'userType': user.userType.index
          });
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> userExists(String email) async {
    var documentSnapshot = await databaseReference.collection(collectionUser).doc(email).get();
    return documentSnapshot.exists;
  }

  Future<UserModel> userFind(String email) async {
    try{
      var documentSnapshot = await databaseReference.collection(collectionUser).doc(email).get();

      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        var user = UserModel.fromMap(data);
        return user;
      }

    } catch (err) {
      print(err);
    }
    return null;
  }

}
