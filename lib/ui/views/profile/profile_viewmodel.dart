import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/app/router.gr.dart';
import 'package:taxiapp/models/user_model.dart';
import 'package:taxiapp/services/app_service.dart';
import 'package:taxiapp/services/auth_social_network_service.dart';
import 'package:taxiapp/ui/views/profile/profile_view.dart';

class ProfileViewModel extends BaseViewModel {
  final AppService _appService = locator<AppService>();
  final AuthSocialNetwork _authSocialNetwork = locator<AuthSocialNetwork>();
  int _currentIndex = 0;
  bool _driveStatus = false;

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

  // * Functions

  String getNameInitials() {
    var nameInitials = '';
    try {
      final nameComponents = user.name.trim().split(' ');
      switch (nameComponents.length) {
        case 1:
          nameInitials = nameComponents.first[0];
          break;
        case 2:
        case 3:
          nameInitials = nameComponents[0].characters.first + nameComponents[1].characters.first;
          break;
        case 4:
          nameInitials = nameComponents[0].characters.first + nameComponents[2].characters.first;
          break;
        default:
          nameInitials = nameComponents.first[0];
      }
    } catch (e) {
      nameInitials = '';
    }
    return nameInitials;
  }

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
}
