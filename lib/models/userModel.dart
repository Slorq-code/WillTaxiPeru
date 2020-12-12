import 'package:taxiapp/models/enums/auth_type.dart';

import 'enums/user_type.dart';

class UserModel {
  String name;
  String googleID;
  String documentNumber;
  String phone;
  String email;
  String image;
  UserType userType;
  AuthType authType;

  UserModel({this.name, this.googleID, this.documentNumber, this.phone, this.email, this.image, this.userType, this.authType});

  UserModel.fromMap(Map<String, dynamic> data) {
    name = data['nombre'] ?? '';
    googleID = data['_id'] ?? '';
    documentNumber = data['ci'] ?? '';
    phone = data['telefono'] ?? '';
    email = data['usuario'] ?? '';
    image = data['imagen'] ?? '';
    userType = UserType.Client;
    authType = AuthType.User;
  }
}
