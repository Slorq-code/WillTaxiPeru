import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:injectable/injectable.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/models/place.dart';
import 'package:taxiapp/models/route_map.dart';
import 'package:taxiapp/services/api.dart';

@lazySingleton
class GoogleMapsService {
  final Api _api = locator<Api>();

  Future<RouteMap> getRouteByCoordinates(LatLng l1, LatLng l2) async {
    final response = await _api.getRouteByCoordinates({
      'lat1': l1.latitude,
      'lng1': l1.longitude,
      'lat2': l2.latitude,
      'lng2': l2.longitude,
    });
    Map routes = response['routes'][0];
    Map legs = response['routes'][0]['legs'][0];
    final route = RouteMap(
        points: decodePolyline(routes['overview_polyline']['points']),
        distance: Distance.fromMap(legs['distance']),
        timeNeeded: TimeNeeded.fromMap(legs['duration']),
        endAddress: legs['end_address'],
        startAddress: legs['end_address']);
    return route;
  }

  Future<List<Place>> getDestinationBySearch(String query, LatLng currentPosition) async {
    final response = await _api.findPlaces({
      'query': query,
      'lat': currentPosition.latitude,
      'lng': currentPosition.longitude,
    });
    final routes = response['candidates'] as List;
    var placesFound = <Place>[];
    routes.forEach((place) {
      placesFound.add(Place(
          name: place['name'],
          address: place['formatted_address'],
          latLng: LatLng(place['geometry']['location']['lat'], place['geometry']['location']['lng'])));
    });
    return placesFound;
  }
}
