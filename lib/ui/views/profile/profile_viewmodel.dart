import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/models/user_model.dart';
import 'package:taxiapp/services/app_service.dart';
import 'package:taxiapp/ui/views/profile/profile_view.dart';

class ProfileViewModel extends BaseViewModel {
  final AppService _appService = locator<AppService>();
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

  void updateIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void changeDriveStatus(bool status) {
    _driveStatus = status;
    notifyListeners();
  }
}
