class RideSummaryModel {
  int dayRides;
  double dayIncome;
  DateAfiliate dateAfiliate;
  int totalRides;
  double totalIncome;

  RideSummaryModel(
      {this.dayRides,
      this.dayIncome,
      this.dateAfiliate,
      this.totalRides,
      this.totalIncome});

  RideSummaryModel.fromJson(Map<String, dynamic> json) {
    dayRides = json['dayRides'];
    dayIncome = json['dayIncome'];
    dateAfiliate = json['dateAfiliate'] != null
        ? DateAfiliate.fromJson(json['dateAfiliate'])
        : null;
    totalRides = json['totalRides'];
    totalIncome = json['totalIncome'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['dayRides'] = dayRides;
    data['dayIncome'] = dayIncome;
    if (dateAfiliate != null) {
      data['dateAfiliate'] = dateAfiliate.toJson();
    }
    data['totalRides'] = totalRides;
    data['totalIncome'] = totalIncome;
    return data;
  }
}

class DateAfiliate {
  int seconds;
  int nanos;

  DateAfiliate({this.seconds, this.nanos});

  DateAfiliate.fromJson(Map<String, dynamic> json) {
    seconds = json['seconds'];
    nanos = json['nanos'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['seconds'] = seconds;
    data['nanos'] = nanos;
    return data;
  }
}