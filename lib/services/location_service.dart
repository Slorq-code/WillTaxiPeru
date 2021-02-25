import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:injectable/injectable.dart';
import 'package:observable_ish/value/value.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/models/user_location.dart';
import 'package:taxiapp/services/api.dart';

@lazySingleton
class LocationService with ReactiveServiceMixin {
  final Api _api = locator<Api>();

  LocationService() {
    listenToReactiveValues([_userLocation]);
  }

  final _geolocator = Geolocator();
  StreamSubscription<Position> _positionSubscription;

  bool tracking;
  final RxValue<UserLocation> _userLocation =
      RxValue<UserLocation>(initial: UserLocation());

  UserLocation get location => _userLocation.value;

  set location(userLocation) {
    _userLocation.value = userLocation;
  }

  void startTracking({Function callbackZoomMap}) async {
    final locationOptions = const LocationOptions(
        accuracy: LocationAccuracy.high, distanceFilter: 10);
    _positionSubscription = _geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) async {
      await updateLocation(LatLng(position.latitude, position.longitude));
        callbackZoomMap();
    });
  }

  Future<Position> getCurrentPosition() async {
    return _geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void cancelTracking() {
    _positionSubscription?.cancel();
  }

  void updateLocation(LatLng newlocation) async {
    var userLocationTemp = _userLocation.value.copyWith();
    userLocationTemp.location = newlocation;
    userLocationTemp.descriptionAddress = await getAddress(newlocation);
    userLocationTemp.existLocation = true;
    _userLocation.value = userLocationTemp;
  }

  Future<String> getAddress(LatLng position) async {
    try {
      final response = await _api
          .getAddress({'lat': position.latitude, 'lng': position.longitude});
      if (response['results'] != null && response['results'].isNotEmpty) {
        return response['results'][0]['formatted_address'];
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }
}
