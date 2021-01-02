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
  AditionaldriveinformationModel aditionaldriveinformation;

  UserModel({this.name, this.uid, this.phone, this.email, this.image, this.userType, this.authType, this.aditionaldriveinformation});

  UserModel.fromMap(Map<String, dynamic> data) {
    name = data['name'] ?? '';
    uid = data['uid'] ?? '';
    phone = data['phone'] ?? '';
    email = data['email'] ?? '';
    image = data['image'] ?? '';
    userType = UserType.values[data['userType'] ?? UserType.Client];
    authType = AuthType.values[data['authType'] ?? AuthType.User];
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

class AditionaldriveinformationModel {
  String document;
  String documentType;
  String fabrishYear;
  String marc;
  String model;
  String plate;
  String rating;
  String token;
  String trips;
  String typeService;
  String votes;

  AditionaldriveinformationModel.fromMap(Map<String, dynamic> data) {
    document = data['document'] ?? '';
    documentType = data['documentType'] ?? '';
    fabrishYear = data['fabrishYear'] ?? '';
    marc = data['marc'] ?? '';
    model = data['model'] ?? '';
    plate = data['plate'] ?? '';
    rating = data['rating'] ?? '';
    token = data['token'] ?? '';
    trips = data['trips'] ?? '';
    typeService = data['typeService'] ?? '';
    votes = data['votes'] ?? '';
  }
}
