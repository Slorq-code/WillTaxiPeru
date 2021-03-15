class PanicModel {
  String descriptionZone;
  String phone;
  PanicModel({this.descriptionZone, this.phone});

  PanicModel.fromMap(Map<String, dynamic> data) {
    descriptionZone = data['descriptionZone'] ?? '';
    phone = data['phone'] ?? '';
  }

  factory PanicModel.fromJson(Map<String, dynamic> json) => PanicModel(
      descriptionZone: json['descriptionZone'] ?? '',
      phone: json['phone'] ?? '');
}
