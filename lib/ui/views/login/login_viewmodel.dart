import 'package:auto_route/auto_route.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/app/router.gr.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/models/enums/auth_type.dart';
import 'package:taxiapp/models/enums/user_type.dart';
import 'package:taxiapp/services/auth_social_network_service.dart';
import 'package:taxiapp/services/firestore_user_service.dart';
import 'package:taxiapp/services/token.dart';
import 'package:taxiapp/utils/alerts.dart';
import 'package:taxiapp/utils/utils.dart';
import 'dart:io' show Platform;

import 'package:taxiapp/extensions/string_extension.dart';

class LoginViewModel extends BaseViewModel {
  BuildContext context;

  LoginViewModel(BuildContext context) {
    this.context = context;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // * Getters
  GlobalKey<FormState> get formKey => _formKey;

  // * Functions

  final AuthSocialNetwork _authSocialNetwork = locator<AuthSocialNetwork>();
  final FirestoreUser _firestoreUser = locator<FirestoreUser>();
  final Token _token = locator<Token>();

  void initial() async {
    await validateButtonAppleSignIn();
  }

  void validateButtonAppleSignIn() async{
    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      var version = iosInfo.systemVersion;
      if (double.parse(version) >= 13) {
        visibleBtnApple = true;
      }
    }
  }

  String _user = '';
  String _password = '';
  bool _passwordOfuscado = true;
  bool _visibleBtnApple = false;

  bool get visibleBtnApple => _visibleBtnApple;

  set visibleBtnApple(visibleBtnApple) {
    _visibleBtnApple = visibleBtnApple;
    notifyListeners();
  }

  String get user => _user;

  set user(user) {
    _user = user;
    notifyListeners();
  }

  String get password => _password;

  set password(password) {
    _password = password;
    notifyListeners();
  }

  bool get passwordOfuscado => _passwordOfuscado;

  set passwordOfuscado(passwordOfuscado) {
    _passwordOfuscado = passwordOfuscado;
    notifyListeners();
  }

  bool get enableBtnContinue {
    return !Utils.isNullOrEmpty(user) && !Utils.isNullOrEmpty(password) && Utils.isValidEmail(user) && Utils.isValidPasswordLength(password);
  }

  void login(AuthType authType) async {
    setBusy(true);

    var packageInfo = await Utils.getPackageInfo();
    try {
      Alert(context: context).loading(Keys.loading.localize());

      await _authSocialNetwork.login(user.toString().trim(), password.toString().trim(), authType);

      if (_authSocialNetwork.isLoggedIn) {
        var userFounded = await _firestoreUser.findUserById(_authSocialNetwork.user.uid);

        if (userFounded != null) {
          _authSocialNetwork.user = userFounded;

          ExtendedNavigator.root.pop();

          await _token.saveToken(_authSocialNetwork.idToken);

          // LOGIN SUCESSFULL, NAVIGATE TO PRINCIPAL PAGE
          await ExtendedNavigator.root.push(Routes.principalViewRoute);
        } else {
          if (AuthType.User.index != authType.index) {
            // WITH SOCIAL NETOWKR

            _authSocialNetwork.user.userType = UserType.Client;

            ExtendedNavigator.root.pop();

            // IF USER DONT EXISTS, COMPLETE REGISTER
            await ExtendedNavigator.root.push(Routes.registerSocialNetworkViewRoute);
          } else {
            // WITHOUT SOCIAL NETOWRK

            ExtendedNavigator.root.pop();

            // USER DONT EXISTS ON DB
            Alert(context: context, title: packageInfo.appName, label: Keys.login_invalid_username_or_password.localize()).alertMessage();
          }
        }
      } else {
        ExtendedNavigator.root.pop();

        if (AuthType.User.index == authType.index) {
          // USER OR PASSWORD INCORRECT
          Alert(context: context, title: packageInfo.appName, label: Keys.login_invalid_username_or_password.localize()).alertMessage();
        }
      }
    } catch (signUpError) {
      ExtendedNavigator.root.pop();

      if (signUpError is FirebaseAuthException) {
        print(signUpError.code.toString());
        if (signUpError.code == 'account-exists-with-different-credential') {
          Alert(context: context, title: packageInfo.appName, label: Keys.email_already_registered.localize()).alertMessage();
        } else if (signUpError.code == 'wrong-password' || signUpError.code == 'user-not-found' || signUpError.code == 'invalid-email') {
          Alert(context: context, title: packageInfo.appName, label: Keys.login_invalid_username_or_password.localize()).alertMessage();
        } else if (signUpError.code == 'too-many-requests') {
          Alert(context: context, title: packageInfo.appName, label: Keys.user_has_been_temporarily_disabled.localize()).alertMessage();
        } else {
          Alert(context: context, title: packageInfo.appName, label: Keys.request_not_processed_correctly.localize()).alertMessage();
        }
      }
    } finally {
      setBusy(false);
    }
  }

  void goToRegisterUser() async {
    setBusy(true);
    await ExtendedNavigator.root.push(Routes.registerViewRoute);
    setBusy(false);
  }

  void goToResetPassword() async {
    setBusy(true);
    _authSocialNetwork.user.email = user;
    await ExtendedNavigator.root.push(Routes.resetPasswordViewRoute);
    setBusy(false);
  }
}
