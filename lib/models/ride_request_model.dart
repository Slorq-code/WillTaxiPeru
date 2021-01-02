import 'package:cloud_firestore/cloud_firestore.dart';

class RideRequestModel {
  String _id;
  String _username;
  String _userId;
  String _driverId;
  String _status;
  num _price;
  Map _position;
  Map _destination;

  String get id => _id;
  String get username => _username;
  String get userId => _userId;
  String get driverId => _driverId;
  String get status => _status;
  num get price => _price;
  Map get position => _position;
  Map get destination => _destination;

  RideRequestModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data();
    _id = data['id'];
    _username = data['username'];
    _userId = data['userId'];
    _driverId = data['driverId'];
    _status = data['status'];
    _position = data['position'];
    _price = data['price'];
    _destination = data['destination'];
  }
}
