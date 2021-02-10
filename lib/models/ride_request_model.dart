import 'package:cloud_firestore/cloud_firestore.dart';

class RideRequestModel {
  String _uid;
  String _username;
  String _userId;
  String _driverId;
  String _status;
  int _secondsArrive;
  num _price;
  PositionRide _position;
  DestinationRide _destination;
  DateRide _dateRide;
  String _route;
  DateTime _dateRideT;

  // * TEMPORAL constructor for test
  RideRequestModel({
    String id,
    String username,
    String userId,
    String driverId,
    String status,
    int secondsArrive,
    num price,
    PositionRide position,
    DestinationRide destination,
    DateRide dateRide,
    String route,
    DateTime dateRideT
  })  : _uid = id,
        _username = username,
        _userId = userId,
        _driverId = driverId,
        _status = status,
        _secondsArrive = secondsArrive,
        _price = price,
        _position = position,
        _destination = destination,
        _dateRide = dateRide,
        _route = route,
        _dateRideT = dateRideT;

  String get uid => _uid;
  String get username => _username;
  String get userId => _userId;
  String get driverId => _driverId;
  String get status => _status;
  int get secondsArrive => _secondsArrive;
  num get price => _price;
  PositionRide get position => _position;
  DestinationRide get destination => _destination;
  DateRide get dateRide => _dateRide;
  String get route => _route;

  RideRequestModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data();
    _uid = data['uid'];
    _username = data['username'];
    _userId = data['userId'];
    _driverId = data['driverId'];
    _status = data['status'];
    _price = data['price'];
    _dateRide = data['dateRide'] != null ? DateRide.fromTimeStamp(data['dateRide']) : null;
    _position = data['position'] != null ? PositionRide.fromJson(data['position']) : null;
    _destination = data['destination'] != null ? DestinationRide.fromJson(data['destination']) : null;
    _route = data['route'];
    _secondsArrive = data['secondsArrive'];
  }

  RideRequestModel.fromJson(Map<String, dynamic> data) {
    _uid = data['uid'];
    _username = data['username'];
    _userId = data['userId'];
    _driverId = data['driverId'];
    _status = data['status'];
    _price = data['price'];
    _dateRide =
        data['dateRide'] != null ? (data['dateRide'] is Timestamp ? DateRide.fromTimeStamp(data['dateRide']) : DateRide.fromJson(data['dateRide'])) : null;
    _position = data['position'] != null ? PositionRide.fromJson(data['position']) : null;
    _destination = data['destination'] != null ? DestinationRide.fromJson(data['destination']) : null;
    _route = data['route'];
    _secondsArrive = data['secondsArrive'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['dateRide'] = _dateRideT;
    data['destination'] = destination.toJson();
    data['driverId'] = driverId;
    data['position'] = position.toJson();
    data['price'] = price;
    data['route'] = route;
    data['secondsArrive'] = secondsArrive;
    data['status'] = status;
    data['uid'] = uid;
    data['userId'] = userId;
    data['username'] = username;
    return data;
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

  DateRide.fromTimeStamp(Timestamp timestamp) {
    seconds = timestamp.seconds;
    nanos = timestamp.nanoseconds;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['seconds'] = seconds;
    data['nanos'] = nanos;
    return data;
  }
}

class PositionRide {
  double latitude;
  double longitude;

  PositionRide({this.latitude, this.longitude});

  PositionRide.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class DestinationRide {
  String name;
  String address;
  PositionRide position;

  DestinationRide({this.name, this.address, this.position});

  DestinationRide.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    position = json['position'] != null ? PositionRide.fromJson(json['position']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['position'] = position.toJson();
    return data;
  }
}
