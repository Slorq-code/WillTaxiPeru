import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/app/router.gr.dart';

class RegistroRedsocialViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // * Getters
  GlobalKey<FormState> get formKey => _formKey;

  // * Functions

  void goToEnrollPage() async {
    await _navigationService.navigateTo(Routes.registroViewRoute);
  }

  void initial() async{
    celular = '';
  }

  String _celular;

  get celular => _celular;

  set celular(celular) {
    _celular = celular;
    notifyListeners();
  }

  final databaseReference = FirebaseFirestore.instance;

  void registrarme() async {
    /*
    try {

      if (user != null) {

        await databaseReference.collection('user').add({
          'nombre': nombre,
          'apellido': apellido,
          'correo': correo,
          'celular': celular,
          'uid': user.user.uid
        });

        print('registrado: ' + user.user.uid);
        ExtendedNavigator.root.push(Routes.loginViewRoute);
        
      } else {

        print('error al registrar');

      }
      
    } catch(signUpError) {
      if(signUpError is FirebaseAuthException) {

        if(signUpError.code == 'email-already-in-use') {
          print('El correo ya fue registrado anteriormente');
        }

      }      
    }
    */
  }

}
