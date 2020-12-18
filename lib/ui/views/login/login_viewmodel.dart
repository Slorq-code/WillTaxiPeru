import 'package:auto_route/auto_route.dart';
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
import 'package:taxiapp/utils/alerts.dart';
import 'package:taxiapp/utils/utils.dart';

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

  void goToEnrollPage() async {
  }

  void initial() async {
    user = '';
    password = '';
    passwordOfuscado = true;
  }

  String _user;
  String _password;
  bool _passwordOfuscado;

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

  bool get enableBtnLogin {
    return !Utils.isNullOrEmpty(user) && !Utils.isNullOrEmpty(password) && Utils.isValidEmail(user) && Utils.isValidPasswordLength(password);
  }

  void login(AuthType authType) async {
    setBusy(true);
    try {
      if (AuthType.User.index == authType.index) {
        Alert(context: context).loading(Keys.loading.localize());
      }

      await _authSocialNetwork.login(user.toString().trim(), password.toString().trim(), authType);

      if (_authSocialNetwork.isLoggedIn) {
        var userFounded = await _firestoreUser.userFind(_authSocialNetwork.user.uid);

        if (userFounded != null) {
          _authSocialNetwork.user = userFounded;

          if (AuthType.User.index == authType.index) {
            ExtendedNavigator.root.pop();
          }

          // LOGIN SUCESSFULL, NAVIGATE TO PRINCIPAL PAGE
          await ExtendedNavigator.root.push(Routes.principalViewRoute);
        } else {
          if (AuthType.User.index != authType.index) {
            // IF USER DONT EXISTS, COMPLETE REGISTER
            _authSocialNetwork.user.userType = UserType.Client;

            await ExtendedNavigator.root.push(Routes.registerSocialNetworkViewRoute);
          }
        }
      } else {
        if (AuthType.User.index == authType.index) {
          ExtendedNavigator.root.pop();
        }
      }
    } catch (signUpError) {
      if (AuthType.User.index == authType.index) {
        ExtendedNavigator.root.pop();
      }
      if (signUpError is FirebaseAuthException) {
        print(signUpError.code.toString());
        var packageInfo = await Utils.getPackageInfo();
        if (signUpError.code == 'account-exists-with-different-credential') {
          Alert(context: context, title: packageInfo.appName, label: Keys.email_already_registered_another_social_network.localize()).alertMessage();
        } else if (signUpError.code == 'wrong-password' || signUpError.code == 'user-not-found' || signUpError.code == 'invalid-email') {
          Alert(context: context, title: packageInfo.appName, label: Keys.login_invalid_username_or_password.localize()).alertMessage();
        } else if (signUpError.code == 'too-many-requests') {
          Alert(context: context, title: packageInfo.appName, label: Keys.request_not_processed_correctly.localize()).alertMessage();
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
}
