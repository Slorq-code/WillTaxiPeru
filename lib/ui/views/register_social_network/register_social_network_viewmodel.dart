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

import 'package:taxiapp/extensions/string_extension.dart';

class RegisterSocialNetworkViewModel extends BaseViewModel {

  BuildContext context;

  RegisterSocialNetworkViewModel(BuildContext context) {
    this.context = context;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // * Getters
  GlobalKey<FormState> get formKey => _formKey;

  // * Functions

  final AuthSocialNetwork _authSocialNetwork = locator<AuthSocialNetwork>();
  final FirestoreUser _firestoreUser = locator<FirestoreUser>();

  void initial() async{
    phone = '';
  }

  String _phone;

  String get phone => _phone;

  set phone(phone) {
    _phone = phone;
    notifyListeners();
  }

  bool get enableBtnContinue {
    return !Utils.isNullOrEmpty(phone) && Utils.isValidPhone(phone);
  }

  void signin() async {
    setBusy(true);

    var packageInfo = await Utils.getPackageInfo();
    try {
      
      Alert(context: context).loading(Keys.loading.localize());

      if (_authSocialNetwork.isLoggedIn) {
        
        _authSocialNetwork.user.phone = phone.toString().trim();

        var userRegister = await _firestoreUser.userRegister(_authSocialNetwork.user);

        ExtendedNavigator.root.pop();

        if (userRegister) {
  
          Alert(context: context, title: packageInfo.appName, label: Keys.user_created_successfully.localize()).alertCallBack(() { 
            ExtendedNavigator.root.push(Routes.principalViewRoute);
          });

        } else {

          Alert(context: context, title: packageInfo.appName, label: Keys.request_not_processed_correctly.localize()).alertMessage();

        }
        
      } else {

        ExtendedNavigator.root.pop();
        Alert(context: context, title: packageInfo.appName, label: Keys.request_not_processed_correctly.localize()).alertMessage();

      }
      
    } catch(signUpError) {

      ExtendedNavigator.root.pop();

      if(signUpError is FirebaseAuthException) {
        print(signUpError.code);
        if(signUpError.code == 'email-already-in-use') {          
          Alert(context: context, title: packageInfo.appName, label: Keys.email_already_registered.localize()).alertMessage();
        } else {
          Alert(context: context, title: packageInfo.appName, label: Keys.request_not_processed_correctly.localize()).alertMessage();
        }

      }

    } finally {
      setBusy(false);
    }
  }

}
