import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:taxiapp/extensions/string_extension.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/services/api.dart';
import 'package:taxiapp/utils/alerts.dart';
import 'package:taxiapp/utils/utils.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/app/router.gr.dart';
import 'package:taxiapp/models/app_config_model.dart';
import 'package:taxiapp/models/enums/ride_status.dart';
import 'package:taxiapp/models/enums/vehicle_type.dart';
import 'package:taxiapp/models/place.dart';
import 'package:taxiapp/models/ride_request_model.dart';
import 'package:taxiapp/models/route_map.dart';
import 'package:taxiapp/models/user_location.dart';
import 'package:taxiapp/models/user_model.dart';
import 'package:taxiapp/services/app_service.dart';
import 'package:taxiapp/services/auth_social_network_service.dart';
import 'package:taxiapp/services/fcm_service.dart';
import 'package:taxiapp/services/firestore_user_service.dart';
import 'package:taxiapp/services/location_service.dart';
import 'package:taxiapp/services/maps_service/maps_general_service.dart';
import 'package:taxiapp/services/ride_request_service.dart';
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
  final RideRequestService _rideRequestServices = locator<RideRequestService>();
  final FCMService _fcmService = locator<FCMService>();
  final FirestoreUser _firestoreUser = locator<FirestoreUser>();
  final Api _api = locator<Api>();
  PrincipalState _state = PrincipalState.loading;

  String notificationType = '';
  StreamSubscription ridesSubscription;
  // final bool _mapReady = false;
  // final bool _drawRoute = false;
  // final bool _followLocation = false;
  bool apiSelected = false;
  LatLng _centralLocation;
  String addressCurrentPosition;
  Place _originSelected;
  Place _destinationSelected;
  Place _destinationClientSelected;

  Map<String, Polyline> _polylines = {};
  Map<String, Marker> _markers = {};
  List<Place> _placesDestinationFound = [];
  List<Place> _placesOriginFound = [];
  final List<Widget> _switchSearchWidgets = [
    const FloatingSearch(),
    const SearchFieldBar(),
    const ManualPickInMap(),
    const NewRouteDriver()
  ];
  final List<Widget> _switchRideWidgets = [
    const SizedBox(),
    const SelectionVehicle(),
    const CheckRideDetails(),
    const SizedBox()
  ];
  final List<Widget> _switchDriverRideWidgets = [
    const RideRequestsByClient(),
    const DriverRideDetails()
  ];
  static const DRIVER_AT_LOCATION_NOTIFICATION = 'DRIVER_AT_LOCATION';
  static const REQUEST_ACCEPTED_NOTIFICATION = 'REQUEST_ACCEPTED';
  static const TRIP_STARTED_NOTIFICATION = 'TRIP_STARTED';
  static const TRIP_FINISH_NOTIFICATION = 'TRIP_FINISH';
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
  bool driverArrived = false;
  DriverRequestFlow _driverRequestFlow = DriverRequestFlow.none;
  bool _enableServiceDriver = false;
  bool hasNewRideRequest = false;
  RideRequestModel rideRequestModel;
  StreamSubscription<UserModel> _driverStream;
  StreamSubscription<QuerySnapshot> requestStream;
  Timer _periodicTimer;
  List<RideRequestModel> _listRideRequest = [];
  AppConfigModel _appConfigModel;
  bool _selectOrigin = false;
  bool _selectDestination = false;
  final TextEditingController _searchOriginController = TextEditingController();
  final TextEditingController _searchDestinationController =
      TextEditingController();
  PackageInfo packageInfo;
  UserLocation currentLocation;

  // * Getters
  UserModel get user => _appService.user;
  PrincipalState get state => _state;
  UserLocation get userLocation => _locationService.location;
  LatLng get centralLocation => _centralLocation;

  bool get selectDestination => _selectDestination;
  Place get destinationSelected => _destinationSelected;
  List<Place> get placesDestinationFound => _placesDestinationFound;
  TextEditingController get searchDestinationController =>
      _searchDestinationController;

  bool get selectOrigin => _selectOrigin;
  set selectOrigin(value) => _selectOrigin = value;
  Place get originSelected => _originSelected;
  List<Place> get placesOriginFound => _placesOriginFound;
  TextEditingController get searchOriginController => _searchOriginController;

  Place get destinationClienteSelected => _destinationClientSelected;

  Widget get currentSearchWidget => _currentSearchWidget;
  Widget get currentRideWidget => _currentRideWidget;
  Widget get currentDriverRideWidget => _currentDriverRideWidget;

  RideRequestModel get rideRequest => _rideRequest;

  Map<String, Polyline> get polylines => _polylines;
  Map<String, Marker> get markers => _markers;

  VehicleType get vehicleSelected => _vehicleSelected;
  DateTime get destinationArrive => _destinationArrive;
  bool get isSearchingDriver => _searchingDriver;
  UserModel get driverForRide => _driverForRide;
  UserModel get clientForRide => _clientForRide;

  RideStatus get rideStatus => _rideStatus;
  DriverRequestFlow get driverRequestFlow => _driverRequestFlow;
  bool get enableServiceDriver => _enableServiceDriver;
  List<RideRequestModel> get listRideRequest => _listRideRequest;

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_locationService, _appService];

  Future<void> initialize() async {
    _currentSearchWidget = _switchSearchWidgets[0];
    _currentDriverRideWidget = _switchDriverRideWidgets[0];
    if (await Geolocator().isLocationServiceEnabled()) {
      _state = PrincipalState.accessGPSEnable;
      await _locationService.startTracking(callbackZoomMap: updateZoomMap);
      _searchOriginController.text = userLocation.descriptionAddress;
    } else {
      _state = PrincipalState.accessGPSDisable;
    }
    _appService.updateUser(_authSocialNetwork.user);
    await loadAppConfig();
    await _fcmService.initializeFCM(_handleNotificationData);

    var _tokenFCM = await _fcmService.getTokenFCM();
    if (_tokenFCM.isNotEmpty && _appService.user.token != _tokenFCM) {
      await _firestoreUser.addDeviceToken(
          token: _tokenFCM, userId: _appService.user.uid);
    }
    packageInfo = await Utils.getPackageInfo();
    notifyListeners();
  }

  Future<void> _handleNotificationData(Map<String, dynamic> data) async {
    hasNewRideRequest = true;
    var _datos = Map<String, dynamic>.from(data['data']);
    var _notificationType = _datos['type'];
    if (_notificationType == REQUEST_ACCEPTED_NOTIFICATION) {
      driverFound(_datos);
    } else if (_notificationType == TRIP_STARTED_NOTIFICATION) {
      startRide(_datos);
    } else if (_notificationType == TRIP_FINISH_NOTIFICATION) {
      arriveToDestination(_datos);
    } else if (_notificationType == DRIVER_AT_LOCATION_NOTIFICATION) {
      driverToArrived(_datos);
    }
  }

  // * PUSH NOTIFICATION METHODS
  Future handleOnMessage(Map<String, dynamic> data) async {
    hasNewRideRequest = true;
    var _datos = Map<String, dynamic>.from(data['data']);
    var _notificationType = _datos['type'];
    if (_notificationType == REQUEST_ACCEPTED_NOTIFICATION) {
      driverFound(_datos);
    } else if (_notificationType == TRIP_STARTED_NOTIFICATION) {
      startRide(_datos);
    } else if (_notificationType == TRIP_FINISH_NOTIFICATION) {
      arriveToDestination(_datos);
    }
  }

  Future handleOnLaunch(Map<String, dynamic> data) async {
    notificationType = data['data']['type'];
    if (notificationType == DRIVER_AT_LOCATION_NOTIFICATION) {
    } else if (notificationType == TRIP_STARTED_NOTIFICATION) {
    } else if (notificationType == REQUEST_ACCEPTED_NOTIFICATION) {}
    _driverForRide =
        await _firestoreUser.findUserById(data['data']['driverId']);
    _stopListeningToDriverStream();

    _listenToDriver(null);
    notifyListeners();
  }

  Future handleOnResume(Map<String, dynamic> data) async {
    notificationType = data['data']['type'];

    _stopListeningToDriverStream();
    if (notificationType == DRIVER_AT_LOCATION_NOTIFICATION) {
    } else if (notificationType == TRIP_STARTED_NOTIFICATION) {
    } else if (notificationType == REQUEST_ACCEPTED_NOTIFICATION) {}

    _driverForRide =
        await _firestoreUser.findUserById(data['data']['driverId']);
    _periodicTimer.cancel();
    notifyListeners();
  }

  void _listenToDriver(Stream<UserModel> driverStream) {
    _driverStream = driverStream.listen((event) {
      _driverForRide = event;
      notifyListeners();
    });
  }

  void listenToRequest({String id, BuildContext context}) async {
    requestStream = _rideRequestServices
        .requestStream()
        .listen((QuerySnapshot querySnapshot) {
      querySnapshot.docChanges.forEach((document) async {
        if (document.doc.data()['id'] == id) {
          rideRequestModel = RideRequestModel.fromJson(document.doc.data());
          notifyListeners();
          switch (document.doc.data()['status']) {
            case RideStatus.canceled:
              break;
            case RideStatus.accepted:
              _rideStatus = RideStatus.accepted;
              _driverForRide = await _firestoreUser
                  .findUserById(document.doc.data()['driverId']);
              _periodicTimer.cancel();
              cleanRoute();
              _stopListeningToDriverStream();
              _listenToDriver(null); // TODO: set stream
              notifyListeners();
              break;
            case RideStatus.expired:
              // TODO: Show Alert
              break;
            default:
              break;
          }
        }
      });
    });
  }

  void _stopListeningToDriverStream() => _driverStream.cancel();

  @override
  void dispose() {
    _locationService.cancelTracking();
    ridesSubscription?.cancel();
    _searchOriginController?.dispose();
    _searchDestinationController?.dispose();
    super.dispose();
  }

  void loadAppConfig() async {
    _appConfigModel ??= await _firestoreUser.findAppConfig();
  }

  void getRides() {
    runZoned(() async {
      await loadAppConfig();
      ridesSubscription = _firestoreUser.findRides().listen((event) async {
        var listRideFilter = <RideRequestModel>[];
        for (var model in event) {
          var distance = await Geolocator().distanceBetween(
              userLocation.location.latitude,
              userLocation.location.longitude,
              model.position.latitude,
              model.position.longitude);
          if (_appConfigModel != null) {
            // if (distance <= _appConfigModel.distancePickUpCustomer) {
            listRideFilter.add(model);
            // }
          } else {
            // IF NOT RESPONSE CONFIGMODEL, VALIDATE DISTANCE WITH HARDCODE
            if (distance <= 1000) {
              listRideFilter.add(model);
            }
          }
        }
        _listRideRequest = listRideFilter;
        notifyListeners();
      });
    }, onError: (e, stackTrace) {
      print(e);
      print(stackTrace);
    });
  }

  Future accessGPS(PermissionStatus status) async {
    switch (status) {
      case PermissionStatus.granted:
        _state = PrincipalState.accessGPSEnable;
        await _locationService.startTracking(callbackZoomMap: updateZoomMap);
        _searchOriginController.text = userLocation.descriptionAddress;
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

  void updateZoomMap() async {
    final position = CameraPosition(target: userLocation.location, zoom: 16.5);
    await _mapController
        .animateCamera(CameraUpdate.newCameraPosition(position));
  }

  void updateCurrentLocation(LatLng center) async {
    _centralLocation = center;
  }

  Future<String> getMapTheme() async =>
      rootBundle.loadString('assets/map_theme/map_theme.json');

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
    _selectDestination = true;
    _selectOrigin = false;
    _placesDestinationFound = await _mapsService.getDestinationBySearch(
        destinationAddress, userLocation.location);
    notifyListeners();
  }

  void searchOrigin(String originAddress) async {
    _selectOrigin = true;
    _selectDestination = false;
    _placesOriginFound = await _mapsService.getDestinationBySearch(
        originAddress, userLocation.location);
    notifyListeners();
  }

  void confirmManualPick(LatLng position, BuildContext context) async {
    final positionPlace = await _locationService.getAddress(position);
    makeRoute(Place(latLng: position, address: positionPlace), context,
        isOriginSelected: selectOrigin);
  }

  void makeRoute(Place place, BuildContext context,
      {bool isDriver = false, bool isOriginSelected = false}) async {
    if (isOriginSelected) {
      _selectOrigin = false;
      _originSelected = place;
      notifyListeners();
      // _locationService.location = UserLocation(
      //     existLocation: true,
      //     descriptionAddress: place.address,
      //     location: place.latLng);
      if (_destinationSelected == null) {
        // show camera to current position
        await _mapsService.updateCameraSpecificLocationZoom(
            userLocation.location, 16, _mapController);
        return;
      }
    } else {
      _selectDestination = false;
      _destinationSelected = place;
    }
    _routeMap = await _mapsService.getRouteByCoordinates(
        _originSelected.latLng, destinationSelected.latLng);
    final routePoints =
        _routeMap.points.map((point) => LatLng(point[0], point[1])).toList();
    final myDestinationRoute = Polyline(
      polylineId: PolylineId('my_destination_route'),
      width: 4,
      color: Colors.black87,
      points: routePoints,
    );

    final currentPolylines = _polylines;
    currentPolylines['my_destination_route'] = myDestinationRoute;

    var iconStart = 'assets/icons/start_location.svg';
    var iconDestination = 'assets/icons/destination_marker.svg';
    var iconVehicle = 'assets/icons/profile_avatar.svg';

    if (destinationClienteSelected != null) {
      iconDestination = iconStart;
      iconStart = iconVehicle;
    }

    final markerStart = Marker(
      anchor: const Offset(0.5, 0.5),
      markerId: MarkerId('start'),
      position: routePoints[0],
      icon: await bitmapDescriptorFromSvgAsset(context, iconStart, 25),
    );

    final markerDestination = Marker(
      markerId: MarkerId('destination'),
      position: routePoints.last,
      icon: await bitmapDescriptorFromSvgAsset(context, iconDestination, 25),
    );

    final newMarkers = {..._markers};
    newMarkers['start'] = markerStart;
    newMarkers['destination'] = markerDestination;

    _polylines = currentPolylines;
    _markers = newMarkers;
    !isDriver ? _showSecondSearchWidget() : _showFourthSearchWidget();
    _showSelectVehicle();
    await updateRouteCamera();
    notifyListeners();
  }

  Future<void> updateRouteCamera() async {
    final source = originSelected.latLng;
    final destination = destinationSelected.latLng;
    await _mapsService.updateCameraLocation(
        source, destination, _mapController);
  }

  void _showSecondSearchWidget() => _currentSearchWidget =
      _switchSearchWidgets[SearchWidget.searchFieldBar.index];

  void _showFourthSearchWidget() => _currentSearchWidget =
      _switchSearchWidgets[SearchWidget.newRouteDriver.index];

  void _showSelectVehicle() => _currentRideWidget =
      _switchRideWidgets[RideWidget.selectionVehicle.index];

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
    _selectOrigin = false;
    _originSelected = null;
    _searchOriginController.text = '';
    updateCurrentRideWidget(RideWidget.clear);
    cleanRoute();
  }

  void clearDestinationPosition() {
    _selectDestination = false;
    _destinationSelected = null;
    _searchDestinationController.text = '';
    updateCurrentRideWidget(RideWidget.clear);
    cleanRoute();
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

  DateTime _getDestinationArrive() =>
      DateTime.now().add(Duration(seconds: _routeMap.timeNeeded.value.toInt()));

  Future<void> getPriceRide() async {
    setBusyForObject(ridePrice, true);

    var serviceDistance = _routeMap.distance.value;
    var serviceType = Utils.serviceType(_vehicleSelected);
    var serviceTime = _routeMap.timeNeeded.value;
    var _params = <String, dynamic>{};
    _params['distance'] = serviceDistance;
    _params['typeService'] = serviceType;
    _params['time'] = serviceTime;

    await _api
        .getPricing(_params)
        .then((value) => (ridePrice = value['price'] ?? 0));
    setBusyForObject(ridePrice, false);
    _searchingDriver = false; //optional
  }

  Future<void> confirmRide(BuildContext context) async {
    _searchingDriver = true;
    notifyListeners();
    //Save Ride
    var _destination = DestinationRide(
        address: _destinationSelected.address,
        name: _destinationSelected.name,
        position: PositionRide(
            latitude: _destinationSelected.latLng.latitude,
            longitude: _destinationSelected.latLng.longitude));

    var _origin = DestinationRide(
        address: originSelected.address,
        name: originSelected.name,
        position: PositionRide(
            latitude: originSelected.latLng.latitude,
            longitude: originSelected.latLng.longitude));

    var _position = PositionRide(
        latitude: userLocation.location.latitude,
        longitude: userLocation.location.longitude);

    var _rideRequestModel = RideRequestModel(
        dateRideT: DateTime.now(),
        destination: _destination,
        origin: _origin,
        driverId: '',
        position: _position,
        price: ridePrice,
        route: 'route',
        secondsArrive: _routeMap.timeNeeded.value,
        status: initialState,
        id: '0',
        userId: _appService.user.uid,
        username: _appService.user.name);

    _firestoreUser.createRideRequest(data: _rideRequestModel.toJson());

    startRequestTimer(context: context);
  }

  void startRequestTimer({String requestId, BuildContext context}) {
    var timeConfigured =
        _appConfigModel != null ? _appConfigModel.timeWaitingDriver : 60;
    _periodicTimer = Timer.periodic(Duration(seconds: timeConfigured), (time) {
      if (_searchingDriver == true) {
        Alert(
                context: context,
                title: packageInfo.appName,
                label: Keys.no_nearby_driver_found.localize())
            .alertCallBack(() {
          _rideStatus = RideStatus.none;
          _searchingDriver = false;
          _showSelectVehicle();
          _periodicTimer.cancel();
          notifyListeners();
        });
      }
    });
  }

  void driverFound(Map<String, dynamic> data) async {
    _searchingDriver = false;
    driverArrived = false;
    _rideStatus = RideStatus.waitingDriver;
    _driverForRide = await _firestoreUser.findUserById(data['driverId']);
    _rideRequest = RideRequestModel(
      driverId: data['driverId'],
      secondsArrive: int.parse(data['secondsArrive']),
      id: data['uid'],
      userId: data['userId'],
      price: double.parse(data['price']),
    );
    notifyListeners();
    // startRide();
  }

  void driverToArrived(Map<String, dynamic> data) async {
    driverArrived = true;
    notifyListeners();
  }

  void startRide(Map<String, dynamic> data) async {
    if (_rideRequest != null) {
      _rideStatus = RideStatus.inProgress;
      // updateCurrentSearchWidget(SearchWidget.floatingSearch);
      // arriveToDestination();
      notifyListeners();
    }
  }

  Future<void> cancelRide() async {
    _rideRequest = null;
    _driverForRide = null;
    _destinationArrive = _getDestinationArrive();
    notifyListeners();
  }

  void arriveToDestination(Map<String, dynamic> data) async {
    _rideStatus = RideStatus.finished;
    notifyListeners();
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
    _originSelected = null;
    _destinationClientSelected = null;
    driverArrived = false;
    cleanRoute();
    updateCurrentRideWidget(RideWidget.clear);
  }

  void logout() async {
    setBusy(true);
    await _authSocialNetwork.logout();
    await ExtendedNavigator.root
        .pushAndRemoveUntil(Routes.loginViewRoute, (route) => false);
    setBusy(false);
  }

  Future<void> restoreMap() async {
    await _mapController.setMapStyle('[]');
    notifyListeners();
    await _mapController.setMapStyle(await getMapTheme());
    notifyListeners();
    if (userLocation.location != null) {
      final position =
          CameraPosition(target: userLocation.location, zoom: 16.5);
      await _mapController
          .animateCamera(CameraUpdate.newCameraPosition(position));
    }
  }

  Future<void> setMyLocation(BuildContext context) async {
    // clearOriginPosition();
    // await _mapController.setMapStyle('[]');
    // notifyListeners();
    // await _mapController.setMapStyle(await getMapTheme());
    // notifyListeners();
    _selectOrigin = true;
    _selectDestination = false;
    notifyListeners();
    var myposition = await _locationService.getCurrentPosition();
    confirmManualPick(
        LatLng(myposition.latitude, myposition.longitude), context);
    if (userLocation.location != null) {
      final position =
          CameraPosition(target: userLocation.location, zoom: 16.5);
      await _mapController
          .animateCamera(CameraUpdate.newCameraPosition(position));
      notifyListeners();
    }
  }

  void updateServiceDriver(bool status) {
    _enableServiceDriver = status;
    if (_enableServiceDriver) {
      getRides();
    } else {
      _listRideRequest = [];
    }
    notifyListeners();
  }

  void selectRideRequest(
      RideRequestModel rideRequest, BuildContext context) async {
    _rideRequest = rideRequest;

    _clientForRide = await _firestoreUser.findUserById(_rideRequest.userId);
    // _driverForRide = await _firestoreUser.findUserById(_appService.user.uid);

    _destinationSelected = Place(
        latLng: LatLng(_rideRequest.destination.position.latitude,
            _rideRequest.destination.position.longitude),
        address: _rideRequest.destination.address,
        name: _rideRequest.destination.name);

    _originSelected = Place(
        latLng: LatLng(_rideRequest.origin.position.latitude,
            _rideRequest.origin.position.longitude),
        address: _rideRequest.origin.address,
        name: _rideRequest.origin.name);

    _destinationArrive =
        DateTime.now().add(Duration(seconds: _rideRequest.secondsArrive));
    notifyListeners();
    await makeRoute(_destinationSelected, context, isDriver: true);
    updateCurrentDriverRideWidget(DriverRideWidget.driverRideDetails);
  }

  void acceptRideRequest(BuildContext context) async {
    _driverRequestFlow = DriverRequestFlow.accept;
    notifyListeners();
    //update ride
    final newValue = <String, dynamic>{};
    newValue['driverId'] = _appService.user.uid;
    newValue['status'] = '1';
    _firestoreUser.updateRideRequest(id: _rideRequest.uid, data: newValue);

    _driverRequestFlow = DriverRequestFlow.preDrivingToStartPoint;
    notifyListeners();

    _destinationClientSelected = _destinationSelected;

    _destinationSelected = _originSelected;
    _originSelected = Place(
        latLng: LatLng(
            userLocation.location.latitude, userLocation.location.longitude),
        address: userLocation.descriptionAddress,
        name: userLocation.descriptionAddress);
    await makeRoute(_originSelected, context,
        isOriginSelected: true, isDriver: true);

    await makeRoute(_destinationSelected, context, isDriver: true);

    updateCurrentDriverRideWidget(DriverRideWidget.driverRideDetails);
    notifyListeners();
  }

  void preDrivingToStartPoint(BuildContext context) async {
    _driverRequestFlow = DriverRequestFlow.preDrivingToStartPoint;
    notifyListeners();

    _originSelected = _destinationSelected;
    _destinationSelected = _destinationClientSelected;
    _destinationClientSelected = null;

    await makeRoute(_originSelected, context,
        isOriginSelected: true, isDriver: true);

    await makeRoute(_destinationSelected, context, isDriver: true);
    await drivingToStartPoint();
  }

  void startRidebyDriver() async {
    _driverRequestFlow = DriverRequestFlow.inProgress;
    final newValue = <String, dynamic>{};
    newValue['status'] = '3';
    _firestoreUser.updateRideRequest(id: _rideRequest.uid, data: newValue);
    _driverRequestFlow = DriverRequestFlow.finished;
    notifyListeners();
  }

  void cancelRideRequestByDriver() {
    _driverRequestFlow = DriverRequestFlow.none;
    final newValue = <String, dynamic>{};
    newValue['driverId'] = '';
    newValue['status'] = initialState;
    _firestoreUser.updateRideRequest(id: _rideRequest.uid, data: newValue);
    notifyListeners();
  }

  Future<void> drivingToStartPoint() async {
    final newValue = <String, dynamic>{};
    newValue['status'] = '2';
    _firestoreUser.updateRideRequest(id: _rideRequest.uid, data: newValue);
    _driverRequestFlow = DriverRequestFlow.onStartPoint;
    notifyListeners();
  }

  void finishRideByDriver() {
    final newValue = <String, dynamic>{};
    newValue['status'] = '4';
    _firestoreUser.updateRideRequest(id: _rideRequest.uid, data: newValue);
    notifyListeners();
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
  preDrivingToStartPoint,
  onStartPoint,
  inProgress,
  finished,
  canceled,
}