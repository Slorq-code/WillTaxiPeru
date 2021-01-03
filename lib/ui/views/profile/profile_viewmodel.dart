import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/app/router.gr.dart';
import 'package:taxiapp/models/ride_request_model.dart';
import 'package:taxiapp/models/user_model.dart';
import 'package:taxiapp/services/api.dart';
import 'package:taxiapp/services/app_service.dart';
import 'package:taxiapp/services/auth_social_network_service.dart';
import 'package:taxiapp/ui/views/profile/profile_view.dart';

class ProfileViewModel extends BaseViewModel {

  BuildContext context;

  ProfileViewModel(BuildContext context) {
    this.context = context;
  }

  void initial() async {
    await loadHistorialData();
  }

  final AppService _appService = locator<AppService>();
  final AuthSocialNetwork _authSocialNetwork = locator<AuthSocialNetwork>();
  final Api _api = locator<Api>();
  int _currentIndex = 0;
  bool _driveStatus = false;
  List<RideRequestModel> _userHistorial = [];
  bool _loadingUserHistorial = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<Widget> _children = [
    ProfileInformationTab(),
    HistorialTab(),
    DriverRecordTab(),
  ];

  // * Getters
  int get currentIndex => _currentIndex;
  bool get driveStatus => _driveStatus;
  List<Widget> get children => _children;
  GlobalKey<FormState> get formKey => _formKey;
  UserModel get user => _appService.user;
  List<RideRequestModel> get userHistorial => _userHistorial;
  bool get loadingUserHistorial => _loadingUserHistorial;

  set userHistorial(userHistorial) {
    _userHistorial = userHistorial;
    notifyListeners();
  }

  set loadingUserHistorial(loadingUserHistorial) {
    _loadingUserHistorial = loadingUserHistorial;
    notifyListeners();
  }

  // * Functions

  void updateIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void changeDriveStatus(bool status) {
    _driveStatus = status;
    notifyListeners();
  }

  void logout() async{
    setBusy(true);
    await _authSocialNetwork.logout();
    await ExtendedNavigator.root.pushAndRemoveUntil(Routes.loginViewRoute, (route) => false);
    setBusy(false);
  }

  void loadHistorialData() async{
    loadingUserHistorial = true;
    try{
      userHistorial = await _api.getAllUserHistorial(_authSocialNetwork.user.uid);
      print(userHistorial.length);
    } catch (signUpError) {
      print(signUpError);
    } finally {
      loadingUserHistorial = false;
    }
  }
}
