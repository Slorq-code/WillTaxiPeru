import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  String address;
  String name;
  LatLng latLng;
  Place({
    this.address,
    this.name,
    this.latLng,
  });
}
