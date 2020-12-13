import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/app/router.gr.dart';
import 'package:taxiapp/models/enums/auth_type.dart';
import 'package:taxiapp/models/enums/user_type.dart';
import 'package:taxiapp/models/userModel.dart';
import 'package:taxiapp/services/auth_social_network_service.dart';
import 'package:taxiapp/services/firestore_user_service.dart';

class RegisterViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // * Getters
  GlobalKey<FormState> get formKey => _formKey;

  // * Functions

  final AuthSocialNetwork _authSocialNetwork = locator<AuthSocialNetwork>();
  final FirestoreUser _firestoreUser = locator<FirestoreUser>();

  void goToEnrollPage() async {
    await _navigationService.navigateTo(Routes.registerViewRoute);
  }

  void initial() async{
    _email = '';
    password = '';
    repeatPassword = '';
    cellphone = '';
    name = '';
    passwordOfuscado = true;
    repitePasswordOfuscado = true;
  }

  String _email;
  String _password;
  String _repeatPassword;
  String _cellphone;
  String _name;
  bool _passwordOfuscado;
  bool _repitePasswordOfuscado;

  get repeatPassword => _repeatPassword;

  set repeatPassword(repeatPassword) {
    _repeatPassword = repeatPassword;
    notifyListeners();
  }

  get email => _email;

  set email(email) {
    _email = email;
    notifyListeners();
  }

  get name => _name;

  set name(name) {
    _name = name;
    notifyListeners();
  }

  get cellphone => _cellphone;

  set cellphone(cellphone) {
    _cellphone = cellphone;
    notifyListeners();
  }

  get password => _password;

  set password(password) {
    _password = password;
    notifyListeners();
  }

  get passwordOfuscado => _passwordOfuscado;

  set passwordOfuscado(passwordOfuscado) {
    _passwordOfuscado = passwordOfuscado;
    notifyListeners();
  }

  get repitePasswordOfuscado => _repitePasswordOfuscado;

  set repitePasswordOfuscado(repitePasswordOfuscado) {
    _repitePasswordOfuscado = repitePasswordOfuscado;
    notifyListeners();
  }

  void signin() async {
    try {

      if (password.toString().trim() != repeatPassword.toString().trim()) {
        print('PASSWORDS DO NOT MATCH');
        return;
      }

      var userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, password: password);

      if (userCredential != null) {
        
        _authSocialNetwork.user = UserModel();
        _authSocialNetwork.user.email = email.toString().toLowerCase().trim();
        _authSocialNetwork.user.name = name.toString().trim();
        _authSocialNetwork.user.phone = cellphone.toString().trim();
        _authSocialNetwork.user.uid = userCredential.user.uid;
        _authSocialNetwork.user.authType = AuthType.User;
        _authSocialNetwork.user.userType = UserType.Client;

        var userRegister = await _firestoreUser.userRegister(_authSocialNetwork.user);

        if (userRegister) {

          await ExtendedNavigator.root.push(Routes.principalViewRoute);

        } else {

          print('THE USER DID NOT REGISTER');

        }

        await ExtendedNavigator.root.push(Routes.loginViewRoute);
        
      } else {

        print('THE USER DID NOT REGISTER');

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
