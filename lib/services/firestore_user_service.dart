import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:taxiapp/models/app_config_model.dart';
import 'package:taxiapp/models/ride_request_model.dart';
import 'package:taxiapp/models/user_model.dart';
import 'package:taxiapp/utils/firestore_helper_util.dart';

@lazySingleton
class FirestoreUser {
  final databaseReference = FirebaseFirestore.instance;
  final _fHelper = FirestoreHelperUtil.instance;

  final String collectionUser = 'user';
  final String collectionDriver = 'driver';
  final String collectionAppConfig = 'app-config';
  final String collectionRides = 'rides';

  Future<bool> modifyUser(UserModel user) async {
    try {
      await databaseReference.collection(collectionUser).doc(user.uid).update({
        'phone': user.phone,
      });
      return true;
    } catch (err, stacktrace) {
      print(stacktrace);
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
    } catch (err, stacktrace) {
      print(stacktrace);
      return false;
    }
  }

  Future<bool> userExists(String uid) async {
    var documentSnapshot = await databaseReference.collection(collectionUser).doc(uid).get();
    return documentSnapshot.exists;
  }

  Future<UserModel> findUserById(String uid) async {
    try {
      var documentSnapshot = await databaseReference.collection(collectionUser).doc(uid).get();

      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        var user = UserModel.fromJson(data);
        user.uid = uid;
        return user;
      }
    } catch (err, stacktrace) {
      print(stacktrace);
    }
    return null;
  }

  Stream<UserModel> findUserByIdStream(String uid) async* {
    yield* _fHelper.documentStreamById(
      path: collectionUser,
      id: uid,
      builder: (data) => UserModel.fromJson(data),
    );
  }

  Stream<List<RideRequestModel>> findRides() async* {
    yield* _fHelper.collectionStream(
        path: collectionRides,
        builder: (data,id) {
            data['uid'] = id;
            return RideRequestModel.fromJson(data);
          },
        queryBuilder: (query) => query.where(
              'status',
              isEqualTo: '0',
            )
        //.orderBy('index'),
        );
  }

  Future<AppConfigModel> findAppConfig() async {
    try {
      var documentSnapshot = await databaseReference.collection(collectionAppConfig).get();

      if (documentSnapshot.docs != null || documentSnapshot.docs.isNotEmpty) {
        return AppConfigModel.fromMap(documentSnapshot.docs.first.data());
      }
    } catch (err, stacktrace) {
      print(stacktrace);
    }
    return null;
  }

  void addDeviceToken({String token, String userId}) {
    databaseReference.collection(collectionUser).doc(userId).update({'token': token});
  }

  void createRideRequest({
    String id,
    Map data
  }) {
    databaseReference.collection(collectionRides).doc(id).set(data);
  }

  void updateRideRequest({
    String id,
    Map data
  }) {
    databaseReference.collection(collectionRides).doc(id).update(data);
  }
}
