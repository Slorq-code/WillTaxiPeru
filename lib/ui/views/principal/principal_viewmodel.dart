import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/app/router.gr.dart';
import 'package:taxiapp/services/auth_social_network_service.dart';
import 'package:taxiapp/services/token.dart';

class PrincipalViewModel extends BaseViewModel {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // * Getters
  GlobalKey<FormState> get formKey => _formKey;

  // * Functions

  void goToEnrollPage() async {
  }

  final AuthSocialNetwork _authSocialNetwork = locator<AuthSocialNetwork>();
  final Token _token = locator<Token>();

  void initial() async {
    print('name:' + _authSocialNetwork.user.name);
  }

  void logout() async {
    await _authSocialNetwork.logout();
    await _token.deleteToken();
    await ExtendedNavigator.root.push(Routes.loginViewRoute);
  }

  void goToProfile() async {
    await ExtendedNavigator.root.push(Routes.profileViewRoute);
  }
}
