import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/app/router.gr.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/services/auth_social_network_service.dart';
import 'package:taxiapp/services/firestore_user_service.dart';
import 'package:taxiapp/utils/alerts.dart';
import 'package:taxiapp/utils/utils.dart';
import 'package:taxiapp/services/token.dart';

import 'package:taxiapp/extensions/string_extension.dart';

class RegisterSocialNetworkViewModel extends BaseViewModel {
  RegisterSocialNetworkViewModel(BuildContext context) : _context = context;

  final AuthSocialNetwork _authSocialNetwork = locator<AuthSocialNetwork>();
  final FirestoreUser _firestoreUser = locator<FirestoreUser>();
  final Token _token = locator<Token>();
  final BuildContext _context;
  String _name;
  String _phone;
  String _email;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // * Getters & Setters

  GlobalKey<FormState> get formKey => _formKey;
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

  String get email => _email;

  set email(email) {
    _email = email;
    notifyListeners();
  }

  bool get enableBtnContinue =>
      !Utils.isNullOrEmpty(name) && !Utils.isNullOrEmpty(email) && Utils.isValidEmail(email) && !Utils.isNullOrEmpty(phone) && Utils.isValidPhone(phone);

  // * Functions

  void initial() async {
    name = Utils.isNullOrEmpty(_authSocialNetwork.user.name) ? '' : _authSocialNetwork.user.name;
    phone = Utils.isNullOrEmpty(_authSocialNetwork.user.phone) ? '' : _authSocialNetwork.user.phone;
    email = Utils.isNullOrEmpty(_authSocialNetwork.user.email) ? '' : _authSocialNetwork.user.email;
  }

  void signin() async {
    setBusy(true);

    final packageInfo = await Utils.getPackageInfo();
    try {
      Alert(context: _context).loading(Keys.loading.localize());

      if (_authSocialNetwork.isLoggedIn) {
        _authSocialNetwork.user.name = name.toString().trim();
        _authSocialNetwork.user.phone = phone.toString().trim();
        _authSocialNetwork.user.email = email.toString().toLowerCase().trim();

        final userRegister = await _firestoreUser.userRegister(_authSocialNetwork.user);

        ExtendedNavigator.root.pop();

        if (userRegister) {
          // _authSocialNetwork.sendSignInLinkToEmail(email);
          await _token.saveToken(_authSocialNetwork.idToken);
          Alert(context: _context, title: packageInfo.appName, label: Keys.user_created_successfully.localize()).alertCallBack(() {
            ExtendedNavigator.root.push(Routes.principalViewRoute);
          });
        } else {
          Alert(context: _context, title: packageInfo.appName, label: Keys.request_not_processed_correctly.localize()).alertMessage();
        }
      } else {
        ExtendedNavigator.root.pop();
        Alert(context: _context, title: packageInfo.appName, label: Keys.request_not_processed_correctly.localize()).alertMessage();
      }
    } catch (signUpError) {
      ExtendedNavigator.root.pop();

      if (signUpError is FirebaseAuthException) {
        print(signUpError.code);
        if (signUpError.code == 'email-already-in-use') {
          Alert(context: _context, title: packageInfo.appName, label: Keys.email_already_registered.localize()).alertMessage();
        } else {
          Alert(context: _context, title: packageInfo.appName, label: Keys.request_not_processed_correctly.localize()).alertMessage();
        }
      }
    } finally {
      setBusy(false);
    }
  }
}
