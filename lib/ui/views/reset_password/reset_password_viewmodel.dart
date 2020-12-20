import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/app/router.gr.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/services/auth_social_network_service.dart';
import 'package:taxiapp/utils/alerts.dart';
import 'package:taxiapp/utils/utils.dart';

import 'package:taxiapp/extensions/string_extension.dart';

class ResetPasswordViewModel extends BaseViewModel {

  BuildContext context;

  ResetPasswordViewModel(BuildContext context) {
    this.context = context;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // * Getters
  GlobalKey<FormState> get formKey => _formKey;

  // * Functions

  final AuthSocialNetwork _authSocialNetwork = locator<AuthSocialNetwork>();

  void initial() async{
    email = (Utils.isNullOrEmpty(_authSocialNetwork.user.email) ? '' : _authSocialNetwork.user.email);
  }

  String _email;

  String get email => _email;

  set email(email) {
    _email = email;
    notifyListeners();
  }

  bool get enableBtnContinue {
    return !Utils.isNullOrEmpty(email) && Utils.isValidEmail(email);
  }

  void resetPassword() async {
    setBusy(true);

    var packageInfo = await Utils.getPackageInfo();
    try {
      
      Alert(context: context).loading(Keys.loading.localize());

      await _authSocialNetwork.sendPasswordResetEmail(email.toString().trim());

      ExtendedNavigator.root.pop();

      Alert(context: context, title: packageInfo.appName, label: Keys.instructions_reset_password.localize()).alertCallBack(() { 
        ExtendedNavigator.root.push(Routes.loginViewRoute);
      });
      
    } catch(signUpError) {

      ExtendedNavigator.root.pop();

      if(signUpError is FirebaseAuthException) {
        print(signUpError.code);
        if (signUpError.code == 'user-not-found') {
          Alert(context: context, title: packageInfo.appName, label: Keys.email_not_registered.localize()).alertMessage();
        } else {
          Alert(context: context, title: packageInfo.appName, label: Keys.request_not_processed_correctly.localize()).alertMessage();
        }

      }

    } finally {
      setBusy(false);
    }
  }

}
