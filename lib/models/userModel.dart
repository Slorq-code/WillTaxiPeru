import 'package:taxiapp/models/enums/auth_type.dart';

import 'enums/user_type.dart';

class UserModel {
  String name;
  String uid;
  String phone;
  String email;
  String image = '';
  UserType userType;
  AuthType authType;

  UserModel({this.name, this.uid, this.phone, this.email, this.image, this.userType, this.authType});

  UserModel.fromMap(Map<String, dynamic> data) {
    name = data['name'] ?? '';
    uid = data['uid'] ?? '';
    phone = data['phone'] ?? '';
    email = data['email'] ?? '';
    image = data['imagen'] ?? '';
    userType = UserType.values[data['userType'] ?? 0];
    authType = AuthType.values[data['authType'] ?? 0];
  }
  
}
