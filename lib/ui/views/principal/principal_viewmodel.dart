import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/app/router.gr.dart';
import 'package:taxiapp/models/enums/ride_status.dart';
import 'package:taxiapp/models/enums/user_type.dart';
import 'package:taxiapp/models/enums/vehicle_type.dart';
import 'package:taxiapp/models/place.dart';
import 'package:taxiapp/models/ride_request_model.dart';
import 'package:taxiapp/models/route_map.dart';
import 'package:taxiapp/models/user_location.dart';
import 'package:taxiapp/models/user_model.dart';
import 'package:taxiapp/services/app_service.dart';
import 'package:taxiapp/services/auth_social_network_service.dart';
import 'package:taxiapp/services/firestore_user_service.dart';
import 'package:taxiapp/services/location_service.dart';
import 'package:taxiapp/services/maps_service/maps_general_service.dart';
import 'package:taxiapp/ui/views/principal/widgets/check_ride_details.dart';
import 'package:taxiapp/ui/views/principal/widgets/driver_ride_details.dart';
import 'package:taxiapp/ui/views/principal/widgets/floating_search.dart';
import 'package:taxiapp/ui/views/principal/widgets/manual_pick_in_map.dart';
import 'package:taxiapp/ui/views/principal/widgets/new_route_driver.dart';
import 'package:taxiapp/ui/views/principal/widgets/ride_requests_by_client.dart';
import 'package:taxiapp/ui/views/principal/widgets/search_field_bar.dart';
import 'package:taxiapp/ui/views/principal/widgets/selection_vehicle.dart';
import 'package:taxiapp/ui/widgets/helpers.dart';

class PrincipalViewModel extends ReactiveViewModel {
  final AppService _appService = locator<AppService>();
  final LocationService _locationService = locator<LocationService>();
  final MapsGeneralService _mapsService = locator<MapsGeneralService>();
  final AuthSocialNetwork _authSocialNetwork = locator<AuthSocialNetwork>();
  final FirestoreUser _firestoreUser = locator<FirestoreUser>();
  PrincipalState _state = PrincipalState.loading;
  StreamSubscription ridesSubscription;
  // final bool _mapReady = false;
  // final bool _drawRoute = false;
  // final bool _followLocation = false;
  bool apiSelected = false;
  LatLng _centralLocation;
  String addressCurrentPosition;
  Place _destinationSelected;
  Map<String, Polyline> _polylines = {};
  Map<String, Marker> _markers = {};
  List<Place> _placesFound = [];
  final List<Widget> _switchSearchWidgets = [const FloatingSearch(), const SearchFieldBar(), const ManualPickInMap(), const NewRouteDriver()];
  final List<Widget> _switchRideWidgets = [const SizedBox(), const SelectionVehicle(), const CheckRideDetails(), const SizedBox()];
  final List<Widget> _switchDriverRideWidgets = [const RideRequestsByClient(), const DriverRideDetails()];
  GoogleMapController _mapController;
  Widget _currentSearchWidget = const SizedBox();
  Widget _currentRideWidget = const SizedBox();
  Widget _currentDriverRideWidget = const SizedBox();
  VehicleType _vehicleSelected = VehicleType.moto;
  RouteMap _routeMap;
  RideRequestModel _rideRequest;
  UserModel _driverForRide;
  UserModel _clientForRide;
  num ridePrice = 0;
  DateTime _destinationArrive;
  bool _searchingDriver = false;
  RideStatus _rideStatus = RideStatus.none;
  DriverRequestFlow _driverRequestFlow = DriverRequestFlow.none;
  bool _enableServiceDriver = false;
  List<RideRequestModel> _listRideRequest = [];

  // * Getters
  UserModel get user => _appService.user;
  PrincipalState get state => _state;
  UserLocation get userLocation => _locationService.location;
  LatLng get centralLocation => _centralLocation;
  Widget get currentSearchWidget => _currentSearchWidget;
  Widget get currentRideWidget => _currentRideWidget;
  Widget get currentDriverRideWidget => _currentDriverRideWidget;
  List<Place> get placesFound => _placesFound;
  Place get destinationSelected => _destinationSelected;
  Map<String, Polyline> get polylines => _polylines;
  Map<String, Marker> get markers => _markers;
  VehicleType get vehicleSelected => _vehicleSelected;
  DateTime get destinationArrive => _destinationArrive;
  bool get isSearchingDriver => _searchingDriver;
  UserModel get driverForRide => _driverForRide;
  UserModel get clientForRide => _clientForRide;
  RideRequestModel get rideRequest => _rideRequest;
  RideStatus get rideStatus => _rideStatus;
  DriverRequestFlow get driverRequestFlow => _driverRequestFlow;
  bool get enableServiceDriver => _enableServiceDriver;
  List<RideRequestModel> get listRideRequest => _listRideRequest;

  // * Functions

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_locationService, _appService];

  Future<void> initialize() async {
    _currentSearchWidget = _switchSearchWidgets[0];
    _currentDriverRideWidget = _switchDriverRideWidgets[0];
    if (await Geolocator().isLocationServiceEnabled()) {
      _state = PrincipalState.accessGPSEnable;
      _locationService.startTracking();
    } else {
      _state = PrincipalState.accessGPSDisable;
    }
    _appService.updateUser(_authSocialNetwork.user);
    if (UserType.Driver == _authSocialNetwork.user.userType){
      getRides();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _locationService.cancelTracking();
    ridesSubscription?.cancel();
    super.dispose();
  }

  void getRides() {
    runZoned(() async {
      ridesSubscription = _firestoreUser.findRides().listen((event) { 
        _listRideRequest = event;
        notifyListeners();
      });
    }, onError: (e, stackTrace) {
      print(stackTrace);
    });
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
    if (_currentDriverRideWidget is DriverRideDetails) {
      _driverRequestFlow = DriverRequestFlow.none;
      cleanRoute();
      updateCurrentDriverRideWidget(DriverRideWidget.rideRequestByClient);
      updateCurrentSearchWidget(SearchWidget.floatingSearch);
      return false;
    } else if (_currentRideWidget is SelectionVehicle) {
      updateCurrentRideWidget(RideWidget.clear);
      return false;
    } else if (_currentRideWidget is CheckRideDetails) {
      updateCurrentRideWidget(RideWidget.selectionVehicle);
      return false;
    } else if (_currentSearchWidget is SearchFieldBar) {
      updateCurrentSearchWidget(SearchWidget.floatingSearch);
      return false;
    } else if (_currentSearchWidget is ManualPickInMap) {
      updateCurrentSearchWidget(SearchWidget.searchFieldBar);
      return false;
    } else {
      logout();
      return true;
    }
  }

  void searchDestination(String destinationAddress) async {
    _placesFound = await _mapsService.getDestinationBySearch(destinationAddress, userLocation.location);
    notifyListeners();
  }

  void confirmManualPickDestination(LatLng destinationPosition, BuildContext context) async {
    final destinationPlace = await _locationService.getAddress(destinationPosition);
    makeRoute(Place(latLng: destinationPosition, address: destinationPlace), context);
  }

  void makeRoute(Place place, BuildContext context, {bool isDriver = false}) async {
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
    !isDriver ? _showSecondSearchWidget() : _showFourthSearchWidget();
    _showSelectVehicle();
    await updateRouteCamera();
    notifyListeners();
  }

  Future<void> updateRouteCamera() async {
    final source = userLocation.location;
    final destination = destinationSelected.latLng;
    await _mapsService.updateCameraLocation(source, destination, _mapController);
  }

  void _showSecondSearchWidget() => _currentSearchWidget = _switchSearchWidgets[SearchWidget.searchFieldBar.index];

  void _showFourthSearchWidget() => _currentSearchWidget = _switchSearchWidgets[SearchWidget.newRouteDriver.index];

  void _showSelectVehicle() => _currentRideWidget = _switchRideWidgets[RideWidget.selectionVehicle.index];

  void updateApiSelection(bool status) {
    apiSelected = status;
    _mapsService.selectApi(status ? ApiMap.mapBox : ApiMap.google);
    notifyListeners();
  }

  void updateCurrentSearchWidget(SearchWidget widget) {
    _currentSearchWidget = _switchSearchWidgets[widget.index];
    notifyListeners();
  }

  void updateCurrentRideWidget(RideWidget widget) {
    _currentRideWidget = _switchRideWidgets[widget.index];
    notifyListeners();
  }

  void updateCurrentDriverRideWidget(DriverRideWidget widget) {
    _currentDriverRideWidget = _switchDriverRideWidgets[widget.index];
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
    _destinationArrive = _getDestinationArrive();
    updateCurrentRideWidget(RideWidget.checkRideDetails);
    getPriceRide();
  }

  DateTime _getDestinationArrive() => DateTime.now().add(Duration(seconds: _routeMap.timeNeeded.value.toInt()));

  // * Mockup implementation
  Future<void> getPriceRide() async {
    setBusyForObject(ridePrice, true);
    await Future.delayed(const Duration(seconds: 2));
    ridePrice = 20;
    setBusyForObject(ridePrice, false);
  }

  // * Mockup implementation
  Future<void> confirmRide() async {
    _searchingDriver = true;
    notifyListeners();
    driverFound();
  }

  // * Mockup implementation
  void driverFound() async {
    await Future.delayed(const Duration(seconds: 3));
    _searchingDriver = false;
    _rideStatus = RideStatus.waitingDriver;
    _driverForRide = UserModel(
      name: 'Paul Rider',
      image: 'https://manofmany.com/wp-content/uploads/2019/06/50-Long-Haircuts-Hairstyle-Tips-for-Men-2.jpg',
      uid: 'dasdsagfdgdfgdffgd234234',
    );
    _rideRequest = RideRequestModel(
      driverId: 'dasdsagfdgdfgdffgd234234',
      secondsArrive: 350,
      id: 'sdagfgdfgfdgfdgf',
      userId: _appService.user.uid,
      price: ridePrice,
    );
    notifyListeners();
    startRide();
  }

  // * Mockup implementation
  void startRide() async {
    await Future.delayed(const Duration(seconds: 5));
    if (_rideRequest != null) {
      _rideStatus = RideStatus.inProgress;
      updateCurrentSearchWidget(SearchWidget.floatingSearch);
      arriveToDestination();
    }
  }

  // * Mockup implementation
  void startRidebyDriver() async {
    _driverRequestFlow = DriverRequestFlow.inProgress;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 5));

    _driverRequestFlow = DriverRequestFlow.finished;
    notifyListeners();
  }

  // * Mockup implementation
  Future<void> cancelRide() async {
    _rideRequest = null;
    _driverForRide = null;
    _destinationArrive = _getDestinationArrive();
    notifyListeners();
  }

  // * Mockup implementation
  void arriveToDestination() async {
    await Future.delayed(const Duration(seconds: 5));
    _rideStatus = RideStatus.finished;
  }

  void cleanRoute() {
    _polylines.clear();
    _markers.clear();
    notifyListeners();
  }

  void finishRide() {
    _rideStatus = RideStatus.none;
    _rideRequest = null;
    _driverForRide = null;
    _destinationSelected = null;
    updateCurrentRideWidget(RideWidget.clear);
  }

  void logout() async {
    setBusy(true);
    await _authSocialNetwork.logout();
    await ExtendedNavigator.root.pushAndRemoveUntil(Routes.loginViewRoute, (route) => false);
    setBusy(false);
  }

  Future<void> restoreMap() async {
    await _mapController.setMapStyle('[]');
    notifyListeners();
    await _mapController.setMapStyle(await getMapTheme());
    notifyListeners();
    if (userLocation.location != null) {
      final position = CameraPosition(target: userLocation.location, zoom: 16.5);
      await _mapController.animateCamera(CameraUpdate.newCameraPosition(position));
    }
  }

  void updateServiceDriver(bool status) {
    _enableServiceDriver = status;
    notifyListeners();
  }

  void selectRideRequest(RideRequestModel rideRequest, BuildContext context) async {
    _rideRequest = rideRequest;

    _clientForRide = await _firestoreUser.findUserById(_rideRequest.userId);

    // replace for destination ride
    final destinationPosition = LatLng(_rideRequest.destination.position.latitude, _rideRequest.destination.position.longitude);

    final destinationPlace = _rideRequest.destination.address;

    _destinationSelected = Place(latLng: destinationPosition, address: destinationPlace, name: _rideRequest.destination.name);

    _destinationArrive = DateTime.now().add(Duration(seconds: _rideRequest.secondsArrive));

    await makeRoute(_destinationSelected, context, isDriver: true);
    updateCurrentDriverRideWidget(DriverRideWidget.driverRideDetails);
  }

  void acceptRideRequest() {
    _driverRequestFlow = DriverRequestFlow.accept;
    notifyListeners();
    // TODO: implement update ride request
    drivingToStartPoint();
  }

  void cancelRideRequestByDriver() {
    _driverRequestFlow = DriverRequestFlow.none;
    // TODO : Update cancel state ride request
  }

  // * Mockup implementation
  Future<void> drivingToStartPoint() async {
    await Future.delayed(const Duration(seconds: 5));
    _driverRequestFlow = DriverRequestFlow.onStartPoint;
    notifyListeners();
  }

  void finishRideByDriver() {
    _driverRequestFlow = DriverRequestFlow.finished;
    notifyListeners();
    // TODO: implement update ride request
    onBack();
  }
}

enum PrincipalState {
  loading,
  accessGPSDisable,
  accessGPSEnable,
}

enum SearchWidget {
  floatingSearch,
  searchFieldBar,
  manualPickInMap,
  newRouteDriver,
}

enum RideWidget {
  clear,
  selectionVehicle,
  checkRideDetails,
}

enum DriverRideWidget {
  rideRequestByClient,
  driverRideDetails,
}

enum DriverRequestFlow {
  none,
  accept,
  onStartPoint,
  inProgress,
  finished,
  canceled,
}
