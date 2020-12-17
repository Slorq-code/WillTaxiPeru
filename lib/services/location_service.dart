import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:injectable/injectable.dart';
import 'package:observable_ish/value/value.dart';
import 'package:stacked/stacked.dart';

@lazySingleton
class LocationService with ReactiveServiceMixin {
  LocationService() {
    listenToReactiveValues([_location, _existLocation]);
  }

  final _geolocator = Geolocator();
  StreamSubscription<Position> _positionSubscription;

  bool tracking;
  final RxValue<bool> _existLocation = RxValue<bool>(initial: false);
  final RxValue<LatLng> _location = RxValue<LatLng>(initial: null);

  LatLng get location => _location.value;
  bool get existLocation => _existLocation.value;

  void startTracking() {
    final locationOptions = const LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    _positionSubscription = _geolocator.getPositionStream(locationOptions).listen((Position position) {
      updateLocation(LatLng(position.latitude, position.longitude));
    });
  }

  void cancelTracking() {
    _positionSubscription?.cancel();
  }

  void updateLocation(LatLng newlocation) {
    _existLocation.value = true;
    _location.value = newlocation;
  }
}
