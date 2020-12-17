import 'package:flutter/services.dart' show rootBundle;

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/services/location_service.dart';

class PrincipalViewModel extends ReactiveViewModel {
  final LocationService _locationService = locator<LocationService>();
  PrincipalState _state = PrincipalState.loading;
  bool _mapReady = false;
  bool _drawRoute = false;
  bool _followLocation = false;

  LatLng _centralLocation;

  Map<String, Polyline> _polylines = {};
  Map<String, Marker> _markers = {};

  GoogleMapController _mapController;

  // * Getters
  PrincipalState get state => _state;
  LatLng get currentLocation => _locationService.location;
  bool get existLocation => _locationService.existLocation;
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
}

enum PrincipalState {
  loading,
  accessGPSDisable,
  accessGPSEnable,
}
