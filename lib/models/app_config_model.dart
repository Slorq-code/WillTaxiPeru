class AppConfigModel {

  String central;
  int timeWaitingDriver;

  AppConfigModel({this.central, this.timeWaitingDriver});

  AppConfigModel.fromMap(Map<String, dynamic> data) {
    central = data['central'] ?? '';
    timeWaitingDriver = data['timeWaitingDriver'] ?? 60;
  }

  factory AppConfigModel.fromJson(Map<String, dynamic> json) => AppConfigModel(
    central: json['central'],
    timeWaitingDriver: json['timeWaitingDriver'] ?? 60,
  );
  
}
