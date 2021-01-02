import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/models/enums/auth_type.dart';
import 'package:taxiapp/models/enums/user_type.dart';
import 'package:taxiapp/models/enums/vehicle_type.dart';
import 'package:taxiapp/models/place.dart';
import 'package:taxiapp/models/ride_request_model.dart';
import 'package:taxiapp/models/route_map.dart';
import 'package:taxiapp/models/user_location.dart';
import 'package:taxiapp/models/user_model.dart';
import 'package:taxiapp/services/app_service.dart';
import 'package:taxiapp/services/auth_social_network_service.dart';
import 'package:taxiapp/services/location_service.dart';
import 'package:taxiapp/services/maps_service/maps_general_service.dart';
import 'package:taxiapp/ui/views/principal/widgets/check_ride_details.dart';
import 'package:taxiapp/ui/views/principal/widgets/floating_search.dart';
import 'package:taxiapp/ui/views/principal/widgets/manual_pick_in_map.dart';
import 'package:taxiapp/ui/views/principal/widgets/search_field_bar.dart';
import 'package:taxiapp/ui/views/principal/widgets/selection_vehicle.dart';
import 'package:taxiapp/ui/widgets/helpers.dart';

class PrincipalViewModel extends ReactiveViewModel {
  final AppService _appService = locator<AppService>();
  final LocationService _locationService = locator<LocationService>();
  final MapsGeneralService _mapsService = locator<MapsGeneralService>();
  final AuthSocialNetwork _authSocialNetwork = locator<AuthSocialNetwork>();
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
  final List<Widget> _switchSearchWidgets = [const FloatingSearch(), const SearchFieldBar(), const ManualPickInMap()];
  final List<Widget> _switchRideWidgets = [const SizedBox(), const SelectionVehicle(), const CheckRideDetails(), const SizedBox()];
  GoogleMapController _mapController;
  Widget _currentSearchWidget = const SizedBox();
  Widget _currentRideWidget = const SizedBox();
  VehicleType _vehicleSelected = VehicleType.moto;
  RouteMap _routeMap;
  RideRequestModel rideRequest;
  num ridePrice = 0;
  DateTime destinationArrive;

  // * Getters
  UserModel get user => _appService.user;
  PrincipalState get state => _state;
  UserLocation get userLocation => _locationService.location;
  LatLng get centralLocation => _centralLocation;
  Widget get currentSearchWidget => _currentSearchWidget;
  Widget get currentRideWidget => _currentRideWidget;
  Place get destinationSelected => _destinationSelected;
  Map<String, Polyline> get polylines => _polylines;
  Map<String, Marker> get markers => _markers;
  VehicleType get vehicleSelected => _vehicleSelected;

  // * Functions

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_locationService, _appService];

  Future<void> initialize() async {
    _currentSearchWidget = _switchSearchWidgets[0];
    if (await Geolocator().isLocationServiceEnabled()) {
      _state = PrincipalState.accessGPSEnable;
      _locationService.startTracking();
    } else {
      _state = PrincipalState.accessGPSDisable;
    }
    _appService.updateUser(_authSocialNetwork.user);
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
    if (_currentRideWidget is SelectionVehicle) {
      updateCurrentRideWidget(0);
      return false;
    } else if (_currentRideWidget is CheckRideDetails) {
      updateCurrentRideWidget(1);
      return false;
    } else if (_currentSearchWidget is SearchFieldBar) {
      updateCurrentSearchWidget(0);
      return false;
    } else if (_currentSearchWidget is ManualPickInMap) {
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

  void confirmManualPickDestination(LatLng destinationPosition, BuildContext context) async {
    final destinationPlace = await _locationService.getAddress(destinationPosition);
    makeRoute(Place(latLng: destinationPosition, address: destinationPlace), context);
  }

  void makeRoute(Place place, BuildContext context) async {
    _destinationSelected = place;

    _routeMap = await _mapsService.getRouteByCoordinates(userLocation.location, place.latLng);

    final routePoints = _routeMap.points.map((point) => LatLng(point[0], point[1])).toList();
    final myDestinationRoute = Polyline(
      polylineId: PolylineId('my_destination_route'),
      width: 4,
      color: Colors.black87,
      points: routePoints,
    );

    final currentPolylines = _polylines;
    currentPolylines['my_destination_route'] = myDestinationRoute;

    // final iconInicio = await getMarkerInicioIcon(route.timeNeeded.value.toInt());

    // final iconDestino = await getMarkerDestinoIcon(place.name, route.distance.value.toDouble());

    final markerStart = Marker(
      anchor: const Offset(0.5, 0.5),
      markerId: MarkerId('start'),
      position: routePoints[0],
      icon: await bitmapDescriptorFromSvgAsset(context, 'assets/icons/start_location.svg', 25),
      // infoWindow: InfoWindow(
      //   title: Keys.my_location.localize(),
      //   snippet: Keys.route_time_with_minutes.localize(['${(route.timeNeeded.value / 60).floor()}']),
      // ),
    );

    final markerDestination = Marker(
      markerId: MarkerId('destination'),
      position: routePoints.last,
      icon: await bitmapDescriptorFromSvgAsset(context, 'assets/icons/destination_marker.svg', 25),
      // anchor: const Offset(0.1, 0.90),
      // infoWindow: InfoWindow(
      //   title: place.name,
      //   snippet: 'Distance: ${route.distance.text}',
      // ),
    );

    final newMarkers = {..._markers};
    newMarkers['start'] = markerStart;
    newMarkers['destination'] = markerDestination;

    // await Future.delayed(const Duration(milliseconds: 300)).then((value) {
    //   _mapController.showMarkerInfoWindow(MarkerId('start'));
    //   _mapController.showMarkerInfoWindow(MarkerId('destination'));
    // });

    _polylines = currentPolylines;
    _markers = newMarkers;
    _showSecondSearchWidget();
    _showSelectVehicle();
    notifyListeners();
  }

  void _showSecondSearchWidget() => _currentSearchWidget = _switchSearchWidgets[1];

  void _showSelectVehicle() => _currentRideWidget = _switchRideWidgets[1];

  void updateApiSelection(bool status) {
    apiSelected = status;
    _mapsService.selectApi(status ? ApiMap.mapBox : ApiMap.google);
    notifyListeners();
  }

  void updateCurrentSearchWidget(int index) {
    _currentSearchWidget = _switchSearchWidgets[index];
    notifyListeners();
  }

  void updateCurrentRideWidget(int index) {
    _currentRideWidget = _switchRideWidgets[index];
    notifyListeners();
  }

  void clearOriginPosition() {
    // TODO: Make implementation
  }

  void clearDestinationPosition() {
    // TODO: Make implementation
  }

  void updateVehicleSelected(VehicleType vehicleType) {
    _vehicleSelected = vehicleType;
    notifyListeners();
  }

  void confirmVehicleSelection() {
    destinationArrive = DateTime.now().add(Duration(seconds: _routeMap.timeNeeded.value.toInt()));
    updateCurrentRideWidget(2);
    getPriceRide();
  }

  Future<void> getPriceRide() async {
    setBusyForObject(ridePrice, true);
    await Future.delayed(const Duration(seconds: 2));
    ridePrice = 20;
    setBusyForObject(ridePrice, false);
  }
}

enum PrincipalState {
  loading,
  accessGPSDisable,
  accessGPSEnable,
}
