import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/app/router.gr.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/models/enums/auth_type.dart';
import 'package:taxiapp/models/enums/user_type.dart';
import 'package:taxiapp/models/user_model.dart';
import 'package:taxiapp/services/auth_social_network_service.dart';
import 'package:taxiapp/services/firestore_user_service.dart';
import 'package:taxiapp/utils/alerts.dart';

import 'package:taxiapp/extensions/string_extension.dart';
import 'package:taxiapp/utils/utils.dart';

class RegisterViewModel extends BaseViewModel {
  BuildContext context;

  RegisterViewModel(BuildContext context) {
    this.context = context;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // * Getters
  GlobalKey<FormState> get formKey => _formKey;

  // * Functions

  final AuthSocialNetwork _authSocialNetwork = locator<AuthSocialNetwork>();
  final FirestoreUser _firestoreUser = locator<FirestoreUser>();

  void goToEnrollPage() async {}

  void initial() async {
    email = '';
    password = '';
    repeatPassword = '';
    phone = '';
    name = '';
    passwordOfuscado = true;
    repitePasswordOfuscado = true;
  }

  String _email;
  String _password;
  String _repeatPassword;
  String _phone;
  String _name;
  bool _passwordOfuscado;
  bool _repitePasswordOfuscado;

  String get repeatPassword => _repeatPassword;

  set repeatPassword(repeatPassword) {
    _repeatPassword = repeatPassword;
    notifyListeners();
  }

  String get email => _email;

  set email(email) {
    _email = email;
    notifyListeners();
  }

  String get name => _name;

  set name(name) {
    _name = name;
    notifyListeners();
  }

  String get phone => _phone;

  set phone(phone) {
    _phone = phone;
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

  bool get repitePasswordOfuscado => _repitePasswordOfuscado;

  set repitePasswordOfuscado(repitePasswordOfuscado) {
    _repitePasswordOfuscado = repitePasswordOfuscado;
    notifyListeners();
  }

  bool get enableBtnContinue {
    return !Utils.isNullOrEmpty(name) &&
        !Utils.isNullOrEmpty(email) &&
        !Utils.isNullOrEmpty(phone) &&
        !Utils.isNullOrEmpty(password) &&
        !Utils.isNullOrEmpty(repeatPassword) &&
        Utils.isValidEmail(email) &&
        Utils.isValidPhone(phone) &&
        Utils.isValidPasswordLength(password);
  }

  void signin() async {
    setBusy(true);

    var packageInfo = await Utils.getPackageInfo();
    try {
      Alert(context: context).loading(Keys.loading.localize());

      if (password.toString().trim() != repeatPassword.toString().trim()) {
        ExtendedNavigator.root.pop();
        Alert(context: context, title: packageInfo.appName, label: Keys.password_dont_match.localize()).alertMessage();
        return;
      }

      var userCredential = await _authSocialNetwork.createUser(email, password);

      if (userCredential != null) {
        // USER CREATED ON FIREBASE AUTHENTICATION

        var userFounded = await _firestoreUser.userFind(_authSocialNetwork.user.uid);

        if (userFounded != null) {
          // USER ALREADY EXISTS ON CLOUD FIRESTORE

          ExtendedNavigator.root.pop();
          Alert(context: context, title: packageInfo.appName, label: Keys.email_already_registered.localize()).alertMessage();
        } else {
          // USER DONT EXISTS ON CLOUD FIRESTORE

          _authSocialNetwork.user = UserModel();
          _authSocialNetwork.user.email = email.toString().toLowerCase().trim();
          _authSocialNetwork.user.name = name.toString().trim();
          _authSocialNetwork.user.phone = phone.toString().trim();
          _authSocialNetwork.user.uid = userCredential.user.uid;
          _authSocialNetwork.user.authType = AuthType.User;
          _authSocialNetwork.user.userType = UserType.Client;

          var userRegister = await _firestoreUser.userRegister(_authSocialNetwork.user);

          ExtendedNavigator.root.pop();

          if (userRegister) {
            // USER CREATED ON CLOUD FIRESTORE

            Alert(context: context, title: packageInfo.appName, label: Keys.user_created_successfully.localize()).alertCallBack(() {
              ExtendedNavigator.root.push(Routes.principalViewRoute);
            });
          } else {
            // ERROR CREATING USER ON CLOUD FIRESTORE

            Alert(context: context, title: packageInfo.appName, label: Keys.request_not_processed_correctly.localize()).alertMessage();
          }
        }
      } else {
        ExtendedNavigator.root.pop();
        Alert(context: context, title: packageInfo.appName, label: Keys.request_not_processed_correctly.localize()).alertMessage();
      }
    } catch (signUpError) {
      if (signUpError is FirebaseAuthException) {
        print(signUpError.code);
        if (signUpError.code == 'email-already-in-use') {
          ExtendedNavigator.root.pop();
          Alert(context: context, title: packageInfo.appName, label: Keys.email_already_registered.localize()).alertMessage();
        } else {
          ExtendedNavigator.root.pop();
          Alert(context: context, title: packageInfo.appName, label: Keys.request_not_processed_correctly.localize()).alertMessage();
        }
      }
    } finally {
      setBusy(false);
    }
  }
}
