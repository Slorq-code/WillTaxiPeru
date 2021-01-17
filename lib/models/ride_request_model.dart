import 'dart:convert';

class RideRequestModel {
  String _id;
  String _username;
  String _userId;
  String _driverId;
  String _status;
  int _secondsArrive;
  num _price;
  Map _position;
  Destination _destination;
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
    Destination destination,
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
  Destination get destination => _destination;
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

class Destination {
  String name;
  String address;
  LatLngPosition latLng;

  Destination({
    this.name,
    this.address,
    this.latLng,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'latLng': latLng?.toMap(),
    };
  }

  factory Destination.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Destination(
      name: map['name'],
      address: map['address'],
      latLng: LatLngPosition.fromMap(map['latLng']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Destination.fromJson(String source) => Destination.fromMap(json.decode(source));
}

class LatLngPosition {
  num latitude;
  num longitude;

  LatLngPosition({
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory LatLngPosition.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return LatLngPosition(
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LatLngPosition.fromJson(String source) => LatLngPosition.fromMap(json.decode(source));
}
