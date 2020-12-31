import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/extensions/string_extension.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/models/enums/auth_type.dart';
import 'package:taxiapp/models/enums/user_type.dart';
import 'package:taxiapp/models/place.dart';
import 'package:taxiapp/models/user_location.dart';
import 'package:taxiapp/models/user_model.dart';
import 'package:taxiapp/services/app_service.dart';
import 'package:taxiapp/services/location_service.dart';
import 'package:taxiapp/services/maps_service/maps_general_service.dart';
import 'package:taxiapp/ui/views/principal/principal_view.dart';
import 'package:taxiapp/ui/widgets/helpers.dart';

class PrincipalViewModel extends ReactiveViewModel {
  final AppService _appService = locator<AppService>();
  final LocationService _locationService = locator<LocationService>();
  final MapsGeneralService _mapsService = locator<MapsGeneralService>();
  PrincipalState _state = PrincipalState.loading;
  // final bool _mapReady = false;
  // final bool _drawRoute = false;
  // final bool _followLocation = false;

  bool apiSelected = false;

  LatLng _centralLocation;

  String addressCurrentPosition;
  Place _destinationSelected;

  Map<String, Polyline> _polylines = {};
  Map<String, Marker> _markers = {};
  List<Place> placesFound = [];
  final List<Widget> _switchingWidgets = [const FloatingSearch(), const SearchFieldBar(), const ManualMarker()];
  GoogleMapController _mapController;
  Widget _currentSearchWidget = const SizedBox();

  // * Getters
  UserModel get user => _appService.user;
  PrincipalState get state => _state;
  UserLocation get userLocation => _locationService.location;
  LatLng get centralLocation => _centralLocation;
  Widget get currentSearchWidget => _currentSearchWidget;
  Place get destinationSelected => _destinationSelected;

  Map<String, Polyline> get polylines => _polylines;
  Map<String, Marker> get markers => _markers;

  // * Functions

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_locationService, _appService];

  Future<void> initialize() async {
    _currentSearchWidget = _switchingWidgets[0];
    if (await Geolocator().isLocationServiceEnabled()) {
      _state = PrincipalState.accessGPSEnable;
      _locationService.startTracking();
    } else {
      _state = PrincipalState.accessGPSDisable;
    }
    _appService.updateUser(UserModel(
      authType: AuthType.Google,
      email: 'test@gmail.com',
      image: 'https://cdn3.iconfinder.com/data/icons/avatars-round-flat/33/avat-01-512.png',
      name: 'Test Go',
      phone: '999999009',
      uid: 'dsgdjgkdnsfgjkndskjfg',
      userType: UserType.Client,
    ));
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

  bool onBack() {
    if (_currentSearchWidget is SearchFieldBar) {
      updateCurrentSearchWidget(0);
      return false;
    } else if (_currentSearchWidget is ManualMarker) {
      updateCurrentSearchWidget(1);
      return false;
    } else {
      return true;
    }
  }

  void searchDestination(String destinationAddress) async {
    final result = await _mapsService.getDestinationBySearch(destinationAddress, userLocation.location);

    placesFound = result;
    notifyListeners();
  }

  void makeRoute(Place place) async {
    _destinationSelected = place;

    final route = await _mapsService.getRouteByCoordinates(userLocation.location, place.latLng);
    final routePoints = route.points.map((point) => LatLng(point[0], point[1])).toList();
    final myDestinationRoute = Polyline(
      polylineId: PolylineId('my_destination_route'),
      width: 4,
      color: Colors.black87,
      points: routePoints,
    );

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
        title: Keys.my_location.localize(),
        snippet: Keys.route_time_with_minutes.localize(['${(route.timeNeeded.value / 60).floor()}']),
      ),
    );

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
    _currentSearchWidget = _switchingWidgets[0];
    notifyListeners();
  }

  void updateApiSelection(bool status) {
    apiSelected = status;
    _mapsService.selectApi(status ? ApiMap.mapBox : ApiMap.google);
    notifyListeners();
  }

  void updateCurrentSearchWidget(int index) {
    _currentSearchWidget = _switchingWidgets[index];
    notifyListeners();
  }

  void clearOriginPosition() {
    // TODO: Make implementation
  }

  void clearDestinationPosition() {
    // TODO: Make implementation
  }
}

enum PrincipalState {
  loading,
  accessGPSDisable,
  accessGPSEnable,
}
