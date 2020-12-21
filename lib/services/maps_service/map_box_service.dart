import 'dart:async';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:injectable/injectable.dart';
import 'package:taxiapp/models/map_box/reverse_query_response.dart';

import 'package:taxiapp/models/map_box/search_response.dart';
import 'package:taxiapp/models/map_box/traffic_response.dart';
import 'package:taxiapp/models/place.dart';
import 'package:taxiapp/models/route_map.dart';
import 'package:taxiapp/utils/debouncer.dart';

@lazySingleton
class MapBoxService {
  final _dio = Dio();
  final debouncer = Debouncer<String>(duration: const Duration(milliseconds: 400));

  final StreamController<SearchResponse> _sugerentionsStreamController = StreamController<SearchResponse>.broadcast();
  Stream<SearchResponse> get sugerenciasStream => _sugerentionsStreamController.stream;

  final _baseUrlDir = 'https://api.mapbox.com/directions/v5';
  final _baseUrlGeo = 'https://api.mapbox.com/geocoding/v5';
  final _apiKey = 'pk.eyJ1IjoiZ3VpbGxlcm1vZGxjbyIsImEiOiJjazB2Z3NqNzEweW1pM2JsdzAwa3Q2M3JpIn0.SN1W_mpg5v9G6G_h4wj0cA';

  Future<DrivingResponse> getCoordsStartAndDestination(LatLng start, LatLng destination) async {
    final coordString = '${start.longitude},${start.latitude};${destination.longitude},${destination.latitude}';
    final url = '${_baseUrlDir}/mapbox/driving/$coordString';

    final resp = await _dio.get(url, queryParameters: {
      'alternatives': 'true',
      'geometries': 'polyline6',
      'steps': 'false',
      'access_token': _apiKey,
      'language': 'es',
    });

    final data = DrivingResponse.fromJson(resp.data);

    return data;
  }

  Future<SearchResponse> getResultsByQuery(String search, LatLng proximity) async {
    final url = '${_baseUrlGeo}/mapbox.places/$search.json';

    try {
      final resp = await _dio.get(url, queryParameters: {
        'access_token': _apiKey,
        'autocomplete': 'true',
        'proximity': '${proximity.longitude},${proximity.latitude}',
        'language': 'es',
      });

      final searchResponse = searchResponseFromJson(resp.data);

      return searchResponse;
    } catch (e) {
      return SearchResponse(features: []);
    }
  }

  void getSugerationsByQuery(String search, LatLng proximity) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final resultados = await getResultsByQuery(value, proximity);
      _sugerentionsStreamController.add(resultados);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      debouncer.value = search;
    });

    Future.delayed(const Duration(milliseconds: 201)).then((_) => timer.cancel());
  }

  Future<ReverseQueryResponse> getCoordsInfo(LatLng destinationCoords) async {
    final url = '${_baseUrlGeo}/mapbox.places/${destinationCoords.longitude},${destinationCoords.latitude}.json';

    final resp = await _dio.get(url, queryParameters: {
      'access_token': _apiKey,
      'language': 'es',
    });

    final data = reverseQueryResponseFromJson(resp.data);

    return data;
  }

  Future<RouteMap> getRouteByCoordinates(LatLng start, LatLng destination) async {
    var response = await getCoordsStartAndDestination(start, destination);
    final routeMap = RouteMap(
      points: decodePolyline(response.routes[0].geometry, accuracyExponent: 6),
      distance: Distance.fromMap({'value': response.routes[0].distance}),
      timeNeeded: TimeNeeded.fromMap({'value': response.routes[0].duration}),
      startAddress: response.waypoints[0].name,
      endAddress: response.waypoints[1].name,
    );

    return routeMap;
  }

  Future<List<Place>> getDestinationBySearch(String query, LatLng currentPosition) async {
    final response = await getResultsByQuery(query, currentPosition);

    var placesFound = <Place>[];
    response.features.forEach((place) {
      placesFound.add(
        Place(
          name: place.text,
          address: place.placeName,
          latLng: LatLng(place.geometry.coordinates[1], place.geometry.coordinates[0]),
        ),
      );
    });
    return placesFound;
  }
}
