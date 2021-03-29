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
  DriverInfoModel driverInfo;
  String token;

  UserModel({
    this.name,
    this.uid,
    this.phone,
    this.email,
    this.image,
    this.userType,
    this.authType,
    this.driverInfo,
    this.token,
  });

  UserModel.fromJson(Map<String, dynamic> data) {
    name = data['name'] ?? '';
    uid = data['uid'] ?? '';
    phone = data['phone'] ?? '';
    email = data['email'] ?? '';
    image = data['image'] ?? '';
    userType = UserType.values[data['userType'] ?? UserType.Client];
    authType = AuthType.values[data['authType'] ?? AuthType.User];
    var driverInfoModel = data['driverInfo'];
    if (driverInfoModel != null) {
      driverInfo = DriverInfoModel.fromMap(driverInfoModel);
    }
    token = data['token'] ?? '';
  }

  UserModel copyWith(
      {String name,
      String uid,
      String phone,
      String email,
      String image,
      UserType userType,
      AuthType authType,
      String token}) {
    return UserModel(
      name: name ?? this.name,
      uid: uid ?? this.uid,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      image: image ?? this.image,
      userType: userType ?? this.userType,
      authType: authType ?? this.authType,
      token: token ?? this.token,
    );
  }
}

class DriverInfoModel {
  String document;
  String documentType;
  String fabrishYear;
  String marc;
  String model;
  String plate;
  double rating;
  String token;
  int trips;
  int typeService;
  int votes;

  DriverInfoModel(
      {this.documentType,
      this.document,
      this.typeService,
      this.plate,
      this.marc,
      this.model,
      this.fabrishYear});

  DriverInfoModel.fromMap(Map<String, dynamic> data) {
    document = data['document'] ?? '';
    documentType = data['documentType'] ?? '';
    fabrishYear = data['fabrishYear'] ?? '';
    marc = data['marc'] ?? '';
    model = data['model'] ?? '';
    plate = data['plate'] ?? '';
    rating = data['rating'] ?? 0;
    token = data['token'] ?? '';
    trips = data['trips'] ?? 0;
    typeService = data['typeService'] ?? 0;
    votes = data['votes'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['documentType'] = documentType;
    data['document'] = document;
    data['typeService'] = typeService;
    data['plate'] = plate;
    data['marc'] = marc;
    data['model'] = model;
    data['fabrishYear'] = fabrishYear;
    return data;
  }
}
