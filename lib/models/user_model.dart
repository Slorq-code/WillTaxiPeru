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

  UserModel copyWith({
    String name,
    String uid,
    String phone,
    String email,
    String image,
    UserType userType,
    AuthType authType,
  }) {
    return UserModel(
      name: name ?? this.name,
      uid: uid ?? this.uid,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      image: image ?? this.image,
      userType: userType ?? this.userType,
      authType: authType ?? this.authType,
    );
  }
}
