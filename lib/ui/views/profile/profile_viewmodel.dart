import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/app/router.gr.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/models/enums/auth_type.dart';
import 'package:taxiapp/models/enums/user_type.dart';
import 'package:taxiapp/models/userModel.dart';
import 'package:taxiapp/services/auth_social_network_service.dart';
import 'package:taxiapp/services/firestore_user_service.dart';
import 'package:taxiapp/utils/alerts.dart';

import 'package:taxiapp/extensions/string_extension.dart';
import 'package:taxiapp/utils/utils.dart';

class ProfileViewModel extends BaseViewModel {

  BuildContext context;

  ProfileViewModel(BuildContext context) {
    this.context = context;
  }


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // * Getters
  GlobalKey<FormState> get formKey => _formKey;

  // * Functions

  final AuthSocialNetwork _authSocialNetwork = locator<AuthSocialNetwork>();

  void goToEnrollPage() async {
  }

  void initial() async {
    email = _authSocialNetwork.user.email;
    phone = _authSocialNetwork.user.phone;
    name = _authSocialNetwork.user.name;
    image = _authSocialNetwork.user.image ?? '';
    image = '';
    password = '';
    repeatPassword = '';
    passwordOfuscado = true;
    repitePasswordOfuscado = true;
    socialNetwork = _authSocialNetwork.user.authType.index != AuthType.User.index;
  }

  String _email;
  String _password;
  String _repeatPassword;
  String _phone;
  String _name;
  String _image;
  bool _passwordOfuscado;
  bool _repitePasswordOfuscado;
  bool _socialNetwork;

  String get image => _image;

  set image(image) {
    _image = image;
    notifyListeners();
  }

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
  
  bool get socialNetwork => _socialNetwork;

  set socialNetwork(socialNetwork) {
    _socialNetwork = socialNetwork;
    notifyListeners();
  }

}
