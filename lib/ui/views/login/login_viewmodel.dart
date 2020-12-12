import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/app/router.gr.dart';
import 'package:taxiapp/models/enums/auth_type.dart';
import 'package:taxiapp/services/auth_social_network_service.dart';
import 'package:taxiapp/services/token.dart';

class LoginViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // * Getters
  GlobalKey<FormState> get formKey => _formKey;

  // * Functions

  final AuthSocialNetwork _authSocialNetwork = locator<AuthSocialNetwork>();

  void goToEnrollPage() async {
    await _navigationService.navigateTo(Routes.loginViewRoute);
  }

  void initial() async {
    usuario = 'apaz@prueba.com';
    clave = '111111';
    controllerClave.text = clave;
    passwordOfuscado = true;
  }

  String _usuario;
  String _clave;
  bool _passwordOfuscado;

  TextEditingController controllerClave = new TextEditingController();

  List<int> listNumberSortRandom = new List<int>();

  get usuario => _usuario;

  set usuario(usuario) {
    _usuario = usuario;
    notifyListeners();
  }

  get clave => _clave;

  set clave(clave) {
    _clave = clave;
    notifyListeners();
  }

  void actualizarClave([clave]) {
    _clave = clave;
    controllerClave.text = _clave;
    notifyListeners();
  }

  get passwordOfuscado => _passwordOfuscado;

  set passwordOfuscado(passwordOfuscado) {
    _passwordOfuscado = passwordOfuscado;
    notifyListeners();
  }

  void ingresarGoogle() async {
    try {
      print('isLoggedIn1: ' + _authSocialNetwork.isLoggedIn.toString());
      await _authSocialNetwork.login('', '', AuthType.Google);

      print('isLoggedIn2: ' + _authSocialNetwork.isLoggedIn.toString());
    } catch (err) {
      print(err);
    }
  }

  void ingresarFacebook() async {}

  void ingresarTwitter() async {}

  void iniciarSesion() async {
    print('isLoggedIn1: ' + _authSocialNetwork.isLoggedIn.toString());
    await _authSocialNetwork.login(usuario, clave, AuthType.User);

    print('isLoggedIn2: ' + _authSocialNetwork.isLoggedIn.toString());
  }

  void irRegistroUsuario() async {
    // _navigationService .navigateTo(Routes.registroViewRoute);
    ExtendedNavigator.root.push(Routes.registroViewRoute);
  }
}
