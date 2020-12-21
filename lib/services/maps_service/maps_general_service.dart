import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/models/place.dart';
import 'package:taxiapp/models/route_map.dart';
import 'package:taxiapp/services/maps_service/google_maps_service.dart';
import 'package:taxiapp/services/maps_service/map_box_service.dart';

@lazySingleton
class MapsGeneralService {
  final MapBoxService _mapBoxService = locator<MapBoxService>();
  final GoogleMapsService _googleMapsService = locator<GoogleMapsService>();
  ApiMap _apiSelected = ApiMap.google;

  Future<RouteMap> getRouteByCoordinates(LatLng start, LatLng destination) async {
    switch (_apiSelected) {
      case ApiMap.google:
        return await _googleMapsService.getRouteByCoordinates(start, destination);
      case ApiMap.mapBox:
        return await _mapBoxService.getRouteByCoordinates(start, destination);
      default:
        return await _googleMapsService.getRouteByCoordinates(start, destination);
    }
  }

  Future<List<Place>> getDestinationBySearch(String query, LatLng currentPosition) async {
    switch (_apiSelected) {
      case ApiMap.google:
        return await _googleMapsService.getDestinationBySearch(query, currentPosition);
      case ApiMap.mapBox:
        return await _mapBoxService.getDestinationBySearch(query, currentPosition);
      default:
        return await _googleMapsService.getDestinationBySearch(query, currentPosition);
    }
  }

  void selectApi(ApiMap apiMap) {
    _apiSelected = apiMap;
  }
}

enum ApiMap {
  google,
  mapBox,
}
