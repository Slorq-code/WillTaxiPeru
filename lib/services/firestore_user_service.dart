import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:taxiapp/models/app_config_model.dart';
import 'package:taxiapp/models/enums/user_type.dart';
import 'package:taxiapp/models/user_model.dart';
import 'package:taxiapp/utils/firestore_helper_util.dart';

@lazySingleton
class FirestoreUser {
  final databaseReference = FirebaseFirestore.instance;
  final _fHelper = FirestoreHelperUtil.instance;

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
      print('modifyUser');
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
      print('userRegister');
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
        return user;
      }
    } catch (err) {
      print('userFind');
      print(err);
    }
    return null;
  }

  Stream<UserModel> userFindStream(String uid) async* {
    yield* _fHelper.documentStream(
      path: collectionUser,
      builder: (data) => UserModel.fromMap(data),
    );
  }

  Future<AppConfigModel> findAppConfig() async {
    try {
      var documentSnapshot = await databaseReference
          .collection(collectionAppConfig)
          .get();

      if (documentSnapshot.docs != null || documentSnapshot.docs.isNotEmpty) {
        return AppConfigModel.fromMap(documentSnapshot.docs.first.data());
      }
    } catch (err) {
      print('findAppConfig');
      print(err);
    }
    return null;
  }
}
