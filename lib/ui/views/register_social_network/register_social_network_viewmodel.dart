import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/app/router.gr.dart';
import 'package:taxiapp/services/auth_social_network_service.dart';
import 'package:taxiapp/services/firestore_user_service.dart';

class RegisterSocialNetworkViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // * Getters
  GlobalKey<FormState> get formKey => _formKey;

  // * Functions

  void goToEnrollPage() async {
    await _navigationService.navigateTo(Routes.registerViewRoute);
  }

  final AuthSocialNetwork _authSocialNetwork = locator<AuthSocialNetwork>();
  final FirestoreUser _firestoreUser = locator<FirestoreUser>();

  void initial() async{
    phone = '';
  }

  String _phone;

  get phone => _phone;

  set phone(phone) {
    _phone = phone;
    notifyListeners();
  }

  void signin() async {
    try {
      
      if (_authSocialNetwork.isLoggedIn) {
        
        _authSocialNetwork.user.phone = phone.toString().trim();

        var userRegister = await _firestoreUser.userRegister(_authSocialNetwork.user);
        print(userRegister);
        if (userRegister) {

          await ExtendedNavigator.root.push(Routes.principalViewRoute);

        } else {

          print('THE USER DID NOT REGISTER');

        }
        
      } else {

        print('THE USER IS NOT AUTHENTICATED');

      }
      
    } catch(signUpError) {

      if(signUpError is FirebaseAuthException) {

        if(signUpError.code == 'email-already-in-use') {
          
          print('THE USER IS ALREADY REGISTERED');

        }

      }      
    }
  }

}
