import 'package:cloud_firestore/cloud_firestore.dart';

class RideRequestModel {
  String _id;
  String _username;
  String _userId;
  String _driverId;
  String _status;
  int _secondsArrive;
  num _price;
  Map _position;
  Map _destination;
  DateRide _dateRide;

  // * TEMPORAL constructor for test
  RideRequestModel({
    String id,
    String username,
    String userId,
    String driverId,
    String status,
    int secondsArrive,
    num price,
    Map position,
    Map destination,
    DateRide dateRide,
  })  : _id = id,
        _username = username,
        _userId = userId,
        _driverId = driverId,
        _status = status,
        _secondsArrive = secondsArrive,
        _price = price,
        _position = position,
        _destination = destination,
        _dateRide = dateRide;

  String get id => _id;
  String get username => _username;
  String get userId => _userId;
  String get driverId => _driverId;
  String get status => _status;
  int get secondsArrive => _secondsArrive;
  num get price => _price;
  Map get position => _position;
  Map get destination => _destination;
  DateRide get dateRide => _dateRide;

  RideRequestModel.json(Map data) {
    _id = data['id'];
    _username = data['username'];
    _userId = data['userId'];
    _driverId = data['driverId'];
    _status = data['status'];
    _position = data['position'];
    _price = data['price'];
    _destination = data['destination'];
    _dateRide = data['dateRide'] != null ? DateRide.fromJson(data['dateRide']) : null;
  }

  RideRequestModel.fromJson(Map<String, dynamic> data) {
    _id = data['id'];
    _username = data['username'];
    _userId = data['userId'];
    _driverId = data['driverId'];
    _status = data['status'];
    _position = data['position'];
    _price = data['price'];
    _destination = data['destination'];
    _dateRide = data['dateRide'] != null ? DateRide.fromJson(data['dateRide']) : null;
  }
}

class DateRide {
  int seconds;
  int nanos;

  DateRide({this.seconds, this.nanos});

  DateRide.fromJson(Map<String, dynamic> json) {
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
