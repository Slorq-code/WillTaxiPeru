import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/models/place.dart';
import 'package:taxiapp/models/user_location.dart';
import 'package:taxiapp/services/google_maps_service.dart';
import 'package:taxiapp/services/location_service.dart';
import 'package:taxiapp/ui/widgets/helpers.dart';

class PrincipalViewModel extends ReactiveViewModel {
  final LocationService _locationService = locator<LocationService>();
  final GoogleMapsService _googleMapsService = locator<GoogleMapsService>();
  PrincipalState _state = PrincipalState.loading;
  bool _mapReady = false;
  bool _drawRoute = false;
  bool _followLocation = false;

  LatLng _centralLocation;
  bool isSearching = false;

  String addressCurrentPosition;

  Map<String, Polyline> _polylines = {};
  Map<String, Marker> _markers = {};
  List<Place> placesFound = [];

  GoogleMapController _mapController;

  // * Getters
  PrincipalState get state => _state;
  UserLocation get userLocation => _locationService.location;

  Map<String, Polyline> get polylines => _polylines;
  Map<String, Marker> get markers => _markers;

  // * Functions

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_locationService];

  Future<void> initialize() async {
    if (await Geolocator().isLocationServiceEnabled()) {
      _state = PrincipalState.accessGPSEnable;
      _locationService.startTracking();
    } else {
      _state = PrincipalState.accessGPSDisable;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _locationService.cancelTracking();
    super.dispose();
  }

  Future accessGPS(PermissionStatus status) async {
    switch (status) {
      case PermissionStatus.granted:
        _state = PrincipalState.accessGPSEnable;
        _locationService.startTracking();
        notifyListeners();
        break;

      case PermissionStatus.undetermined:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        await openAppSettings().then((response) {
          if (response) {
            _state = PrincipalState.accessGPSEnable;
          } else {
            _state = PrincipalState.accessGPSDisable;
          }
        });
        notifyListeners();
    }
  }

  void initMapa(GoogleMapController controller) async {
    _mapController = controller;
    await _mapController.setMapStyle(await getMapTheme());
  }

  void updateCurrentLocation(LatLng center) {
    _centralLocation = center;
  }

  Future<String> getMapTheme() async => rootBundle.loadString('assets/map_theme/map_theme.json');

  void updateSearching(bool state) {
    isSearching = state;
    notifyListeners();
  }

  void searchDestination(String destinationAddress) async {
    final result = await _googleMapsService.getDestinationBySearch(destinationAddress, userLocation.location);

    placesFound = result;
    notifyListeners();
  }

  void makeRoute(Place place) async {
    final route = await _googleMapsService.getRouteByCoordinates(userLocation.location, place.latLng);
    final routePoints = route.points.map((point) => LatLng(point[0], point[1])).toList();
    final myRoute = Polyline(
      polylineId: PolylineId('my_route'),
      width: 4,
      color: Colors.transparent,
    );
    final myDestinationRoute = Polyline(
      polylineId: PolylineId('my_destination_route'),
      width: 4,
      color: Colors.black87,
      points: routePoints,
    );
    ;

    final currentPolylines = _polylines;
    currentPolylines['my_destination_route'] = myDestinationRoute;

    final iconInicio = await getMarkerInicioIcon(route.timeNeeded.value.toInt());

    final iconDestino = await getMarkerDestinoIcon(place.name, route.distance.value.toDouble());

    final markerStart = Marker(
        anchor: const Offset(0.0, 1.0),
        markerId: MarkerId('start'),
        position: routePoints[0],
        icon: iconInicio,
        infoWindow: InfoWindow(
          title: 'My Location',
          snippet: 'Time route: ${(route.timeNeeded.value / 60).floor()} minuts',
        ));

    final markerDestination = Marker(
        markerId: MarkerId('destino'),
        position: routePoints.last,
        icon: iconDestino,
        anchor: const Offset(0.1, 0.90),
        infoWindow: InfoWindow(
          title: place.name,
          snippet: 'Distance: ${route.distance.text}',
        ));

    final newMarkers = {..._markers};
    newMarkers['start'] = markerStart;
    newMarkers['destination'] = markerDestination;

    await Future.delayed(const Duration(milliseconds: 300)).then((value) {
      // _mapController.showMarkerInfoWindow(MarkerId('inicio'));
      // _mapController.showMarkerInfoWindow(MarkerId('destino'));
    });

    _polylines = currentPolylines;
    _markers = newMarkers;
    isSearching = false;
    notifyListeners();
  }
}

enum PrincipalState {
  loading,
  accessGPSDisable,
  accessGPSEnable,
}
