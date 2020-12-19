import 'package:flutter/cupertino.dart';

class RouteMap {
  final List<List<num>> points;
  final Distance distance;
  final TimeNeeded timeNeeded;
  final String startAddress;
  final String endAddress;

  RouteMap({
    @required this.points,
    @required this.distance,
    @required this.timeNeeded,
    @required this.startAddress,
    @required this.endAddress,
  });
}

class Distance {
  String text;
  int value;

  Distance.fromMap(Map data) {
    text = data['text'];
    value = data['value'];
  }

  Map toJson() => {'text': text, 'value': value};
}

class TimeNeeded {
  String text;
  int value;

  TimeNeeded.fromMap(Map data) {
    text = data['text'];
    value = data['value'];
  }
}
