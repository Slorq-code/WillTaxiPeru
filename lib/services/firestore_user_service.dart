import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:taxiapp/models/app_config_model.dart';
import 'package:taxiapp/models/enums/user_type.dart';
import 'package:taxiapp/models/user_model.dart';

@lazySingleton
class FirestoreUser {
  final databaseReference = FirebaseFirestore.instance;

  final String collectionUser = 'user';
  final String collectionDriver = 'driver';
  final String collectionAppConfig = 'app-config';

  Future<bool> modifyUser(UserModel user) async {
    try {
      await databaseReference.collection(collectionUser).doc(user.uid).update({
        'phone': user.phone,
      });
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> userRegister(UserModel user) async {
    try {
      await databaseReference.collection(collectionUser).doc(user.uid).set({
        'name': user.name,
        'email': user.email.toLowerCase(),
        'phone': user.phone,
        'authType': user.authType.index,
        'userType': user.userType.index,
        'image': user.image,
      });
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> userExists(String uid) async {
    var documentSnapshot =
        await databaseReference.collection(collectionUser).doc(uid).get();
    return documentSnapshot.exists;
  }

  Future<UserModel> userFind(String uid) async {
    try {
      var documentSnapshot =
          await databaseReference.collection(collectionUser).doc(uid).get();

      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        var user = UserModel.fromMap(data);
        user.uid = uid;
        if (user.userType == UserType.Driver) {
          var documentDriverSnapshot = await databaseReference
              .collection(collectionDriver)
              .doc(uid)
              .get();
          if (documentDriverSnapshot.exists) {
            user.aditionaldriveinformation =
                AditionaldriveinformationModel.fromMap(
                    documentDriverSnapshot.data());
          }
        }
        return user;
      }
    } catch (err) {
      print(err);
    }
    return null;
  }

  Future<AppConfigModel> findAppConfig(String key) async {
    try {
      var documentSnapshot = await databaseReference
          .collection(collectionAppConfig)
          .doc(key)
          .get();

      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        return AppConfigModel.fromMap(data);
      }
    } catch (err) {
      print(err);
    }
    return null;
  }
}
