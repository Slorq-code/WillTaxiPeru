import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/models/place.dart';
import 'package:taxiapp/models/user_location.dart';
import 'package:taxiapp/services/location_service.dart';
import 'package:taxiapp/services/maps_service/maps_general_service.dart';
import 'package:taxiapp/ui/widgets/helpers.dart';

class PrincipalViewModel extends ReactiveViewModel {
  final LocationService _locationService = locator<LocationService>();
  final MapsGeneralService _mapsService = locator<MapsGeneralService>();
  PrincipalState _state = PrincipalState.loading;
  final bool _mapReady = false;
  final bool _drawRoute = false;
  final bool _followLocation = false;

  bool apiSelected = false;

  LatLng _centralLocation;
  bool isSearching = false;
  bool _isManualSearch = false;

  String addressCurrentPosition;

  Map<String, Polyline> _polylines = {};
  Map<String, Marker> _markers = {};
  List<Place> placesFound = [];

  GoogleMapController _mapController;

  // * Getters
  PrincipalState get state => _state;
  UserLocation get userLocation => _locationService.location;
  bool get isManualSearch => _isManualSearch;
  LatLng get centralLocation => _centralLocation;

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
    final result = await _mapsService.getDestinationBySearch(destinationAddress, userLocation.location);

    placesFound = result;
    notifyListeners();
  }

  void makeRoute(Place place) async {
    _isManualSearch = false;
    final route = await _mapsService.getRouteByCoordinates(userLocation.location, place.latLng);
    final routePoints = route.points.map((point) => LatLng(point[0], point[1])).toList();
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
          title: 'My Location', //TODO: translate
          snippet: 'Time route: ${(route.timeNeeded.value / 60).floor()} minutes', //TODO: translate
        ));

    final markerDestination = Marker(
        markerId: MarkerId('destination'),
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
      _mapController.showMarkerInfoWindow(MarkerId('start'));
      _mapController.showMarkerInfoWindow(MarkerId('destination'));
    });

    _polylines = currentPolylines;
    _markers = newMarkers;
    isSearching = false;
    notifyListeners();
  }

  void updateManualSearchState(bool state) {
    _isManualSearch = state;
    isSearching = false;
    notifyListeners();
  }

  void updateApiSelection(bool status) {
    apiSelected = status;
    _mapsService.selectApi(status ? ApiMap.mapBox : ApiMap.google);
    notifyListeners();
  }
}

enum PrincipalState {
  loading,
  accessGPSDisable,
  accessGPSEnable,
}
