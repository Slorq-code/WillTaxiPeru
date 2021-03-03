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

  Future<void> updateCameraSpecificLocationZoom(LatLng location, double zoom, GoogleMapController mapController) async {
    if (mapController == null) return;
    // zoom range 2 to 21
    final cameraUpdate = CameraUpdate.newLatLngZoom(location, zoom);

    return checkCameraLocation(cameraUpdate, mapController);
  }

  Future<void> updateCameraLocation(LatLng source, LatLng destination, GoogleMapController mapController) async {
    if (mapController == null) return;

    LatLngBounds bounds;

    if (source.latitude > destination.latitude && source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: LatLng(source.latitude, destination.longitude), northeast: LatLng(destination.latitude, source.longitude));
    } else if (source.latitude > destination.latitude) {
      bounds = LatLngBounds(southwest: LatLng(destination.latitude, source.longitude), northeast: LatLng(source.latitude, destination.longitude));
    } else {
      bounds = LatLngBounds(southwest: source, northeast: destination);
    }
    final cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 150);

    return checkCameraLocation(cameraUpdate, mapController);
  }

  Future<void> checkCameraLocation(CameraUpdate cameraUpdate, GoogleMapController mapController) async {
    await mapController.animateCamera(cameraUpdate);
    final l1 = await mapController.getVisibleRegion();
    final l2 = await mapController.getVisibleRegion();

    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      return checkCameraLocation(cameraUpdate, mapController);
    }
  }
}

enum ApiMap {
  google,
  mapBox,
}
