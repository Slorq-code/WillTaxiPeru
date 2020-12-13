import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/app/router.gr.dart';
import 'package:taxiapp/services/auth_social_network_service.dart';

class PrincipalViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // * Getters
  GlobalKey<FormState> get formKey => _formKey;

  // * Functions

  void goToEnrollPage() async {
    await _navigationService.navigateTo(Routes.registerViewRoute);
  }

  final AuthSocialNetwork _authSocialNetwork = locator<AuthSocialNetwork>();

  void initial() async{
    print(_authSocialNetwork.user.authType.index);
    print(_authSocialNetwork.user.userType.index);
    print(_authSocialNetwork.user.email);
    print(_authSocialNetwork.user.name);
    print(_authSocialNetwork.user.phone);
    print(_authSocialNetwork.user.uid);
  }

  void logout() async{
    await _authSocialNetwork.logout();
    await ExtendedNavigator.root.push(Routes.loginViewRoute);
  }
}
