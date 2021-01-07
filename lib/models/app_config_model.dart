class AppConfigModel {

  String central;

  AppConfigModel({this.central});

  AppConfigModel.fromMap(Map<String, dynamic> data) {
    central = data['central'] ?? '';
  }

  factory AppConfigModel.fromJson(Map<String, dynamic> json) => AppConfigModel(
    central: json['central'],
  );
  
}
