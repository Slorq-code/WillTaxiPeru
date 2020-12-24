import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserLocation {
  bool existLocation;
  LatLng location;
  String descriptionAddress;
  UserLocation({
    this.existLocation = false,
    this.location,
    this.descriptionAddress = '',
  });

  UserLocation copyWith({
    bool existLocation,
    LatLng location,
    String descriptionAddress,
  }) {
    return UserLocation(
      existLocation: existLocation ?? this.existLocation,
      location: location ?? this.location,
      descriptionAddress: descriptionAddress ?? this.descriptionAddress,
    );
  }
}
