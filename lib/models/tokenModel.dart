class TokenModel {

  String uid;
  String name;
  bool emailVerified;

  TokenModel({this.uid, this.name, this.emailVerified});

  TokenModel.fromMap(Map<String, dynamic> data) {
    uid = data['uid'] ?? '';
    name = data['name'] ?? '';
    emailVerified = data['emailVerified'] ?? '';
  }

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
    name: json['name'],
    uid: json['uid'],
    emailVerified: json['emailVerified']
  );
  
}
