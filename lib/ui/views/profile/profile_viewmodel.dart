import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/app/router.gr.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/models/app_config_model.dart';
import 'package:taxiapp/models/ride_request_model.dart';
import 'package:taxiapp/models/ride_summary_model.dart';
import 'package:taxiapp/models/user_model.dart';
import 'package:taxiapp/services/api.dart';
import 'package:taxiapp/services/app_service.dart';
import 'package:taxiapp/services/auth_social_network_service.dart';
import 'package:taxiapp/services/firestore_user_service.dart';
import 'package:taxiapp/services/secure_storage_service.dart';
import 'package:taxiapp/ui/views/profile/profile_view.dart';
import 'package:taxiapp/utils/alerts.dart';
import 'package:taxiapp/utils/utils.dart';
import 'package:taxiapp/services/token.dart';

import 'package:taxiapp/extensions/string_extension.dart';

class ProfileViewModel extends BaseViewModel {
  BuildContext context;

  ProfileViewModel(BuildContext context) {
    this.context = context;
  }

  void initial() async {
    loadHistorialData();
    loadRideSummary();
    loadAppConfig();
  }

  final AppService _appService = locator<AppService>();
  final AuthSocialNetwork _authSocialNetwork = locator<AuthSocialNetwork>();
  final Api _api = locator<Api>();
  final FirestoreUser _firestoreUser = locator<FirestoreUser>();
  final Token _token = locator<Token>();
  final SecureStorage _secureStorage = locator<SecureStorage>();
  int _currentIndex = 0;
  List<RideRequestModel> _userHistorial = [];
  bool _loadingUserHistorial = false;
  bool _loadingRideSummary = false;
  RideSummaryModel _rideSummaryModel;
  AppConfigModel _appConfigModel;
  bool _isEditing = false;
  String _phone = '';
  String _password = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<Widget> _children = [
    ProfileInformationTab(),
    HistorialTab(),
    DriverRecordTab(),
  ];

  // * Getters
  int get currentIndex => _currentIndex;
  List<Widget> get children => _children;
  GlobalKey<FormState> get formKey => _formKey;
  UserModel get user => _appService.user;
  List<RideRequestModel> get userHistorial => _userHistorial;
  bool get loadingUserHistorial => _loadingUserHistorial;
  bool get loadingRideSummary => _loadingRideSummary;
  RideSummaryModel get rideSummaryModel => _rideSummaryModel;
  bool get isEditing => _isEditing;
  String get phone => _phone;
  String get password => _password;

  set phone(phone) {
    _phone = phone;
    notifyListeners();
  }

  set password(password) {
    _password = password;
    notifyListeners();
  }

  set isEditing(isEditing) {
    _isEditing = isEditing;
    notifyListeners();
  }

  set userHistorial(userHistorial) {
    _userHistorial = userHistorial;
    notifyListeners();
  }

  set loadingUserHistorial(loadingUserHistorial) {
    _loadingUserHistorial = loadingUserHistorial;
    notifyListeners();
  }

  set loadingRideSummary(loadingRideSummary) {
    _loadingRideSummary = loadingRideSummary;
    notifyListeners();
  }

  set rideSummaryModel(rideSummaryModel) {
    _rideSummaryModel = rideSummaryModel;
    notifyListeners();
  }

  // * Functions

  void updateIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void logout() async {
    setBusy(true);
    await _authSocialNetwork.logout();
    _token.deleteToken();
    await _secureStorage.deleteAll();
    await ExtendedNavigator.root
        .pushAndRemoveUntil(Routes.loginViewRoute, (route) => false);
    setBusy(false);
  }

  void loadHistorialData() async {
    loadingUserHistorial = true;
    try {
      userHistorial =
          await _api.getAllUserHistorial(_authSocialNetwork.user.uid);
    } catch (err, stackTrace) {
      print(stackTrace);
    } finally {
      loadingUserHistorial = false;
    }
  }

  void loadRideSummary() async {
    loadingRideSummary = true;
    try {
      var data = await _api.getRideSummary(_authSocialNetwork.user.uid);
      if (data != null && data is Map) {
        if (data.isNotEmpty) {
          rideSummaryModel = RideSummaryModel.fromJson(data);
        }
      }
    } catch (err, stackTrace) {
      print(stackTrace);
    } finally {
      loadingRideSummary = false;
    }
  }

  void loadAppConfig() async {
    _appConfigModel ??= await _firestoreUser.findAppConfig();
  }

  void callCentral() async {
    setBusy(true);
    var packageInfo = await Utils.getPackageInfo();
    try {
      await loadAppConfig();
      if (_appConfigModel != null) {
        await FlutterPhoneDirectCaller.callNumber(_appConfigModel.central);
      } else {
        Alert(
                context: context,
                title: packageInfo.appName,
                label: Keys.request_not_processed_correctly.localize())
            .alertMessage();
      }
    } catch (signUpError) {
      print(signUpError);
      Alert(
              context: context,
              title: packageInfo.appName,
              label: Keys.request_not_processed_correctly.localize())
          .alertMessage();
    } finally {
      setBusy(false);
    }
  }

  void onEditProfile() {
    setBusy(true);
    if (isEditing) {
      isEditing = false;
    } else {
      isEditing = true;
    }
    setBusy(false);
  }

  void saveProfileInformation() async {
    setBusy(true);
    var packageInfo = await Utils.getPackageInfo();
    try {
      Alert(context: context).loading(Keys.loading.localize());

      var userInformationModified = false;

      if (password.trim().isNotEmpty) {
        await _authSocialNetwork.modifyPassword(password.trim());
        userInformationModified = true;
      }

      if (phone.trim().isNotEmpty) {
        var userModel = UserModel();
        userModel.uid = user.uid;
        userModel.phone = phone.trim();

        userInformationModified = await _firestoreUser.modifyUser(userModel);
        if (userInformationModified) {
          user.phone = userModel.phone;
        }
      }

      if (userInformationModified) {
        phone = '';
        password = '';
        isEditing = false;
        ExtendedNavigator.root.pop();
        Alert(
                context: context,
                title: packageInfo.appName,
                label: Keys.your_data_updated_correctly.localize())
            .alertMessage();
      } else {
        ExtendedNavigator.root.pop();
        Alert(
                context: context,
                title: packageInfo.appName,
                label: Keys.request_not_processed_correctly.localize())
            .alertMessage();
      }
    } catch (signUpError) {
      print(signUpError);
      ExtendedNavigator.root.pop();
      Alert(
              context: context,
              title: packageInfo.appName,
              label: Keys.request_not_processed_correctly.localize())
          .alertMessage();
    } finally {
      setBusy(false);
    }
  }

  bool get enableBtnContinue =>
      (!Utils.isNullOrEmpty(phone) &&
          Utils.isValidPhone(phone) &&
          phone.trim().compareTo(user.phone.trim()) != 0) ||
      (!Utils.isNullOrEmpty(password) && Utils.isValidPasswordLength(password));
}
