class AppConfigModel {

  String central;
  int timeWaitingDriver;
  int distancePickUpCustomer;

  AppConfigModel({this.central, this.timeWaitingDriver, this.distancePickUpCustomer});

  AppConfigModel.fromMap(Map<String, dynamic> data) {
    central = data['central'] ?? '';
    timeWaitingDriver = data['timeWaitingDriver'] ?? 60;
    distancePickUpCustomer = data['distancePickUpCustomer'] ?? 1000;
  }

  factory AppConfigModel.fromJson(Map<String, dynamic> json) => AppConfigModel(
    central: json['central'],
    timeWaitingDriver: json['timeWaitingDriver'] ?? 60,
    distancePickUpCustomer: json['distancePickUpCustomer'] ?? 1000
  );
  
}
