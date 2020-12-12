import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/app/router.gr.dart';

class RegistroViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // * Getters
  GlobalKey<FormState> get formKey => _formKey;

  // * Functions

  void goToEnrollPage() async {
    await _navigationService.navigateTo(Routes.registroViewRoute);
  }

  void initial() async{
    correo = '';
    clave = '';
    repiteClave = '';
    celular = '';
    nombre = '';
    apellido = '';
    passwordOfuscado = true;
    repitePasswordOfuscado = true;
  }

  String _correo;
  String _clave;
  String _repiteClave;
  String _celular;
  String _nombre;
  String _apellido;
  bool _passwordOfuscado;
  bool _repitePasswordOfuscado;

  get repiteClave => _repiteClave;

  set repiteClave(repiteClave) {
    _repiteClave = repiteClave;
    notifyListeners();
  }

  get correo => _correo;

  set correo(correo) {
    _correo = correo;
    notifyListeners();
  }

  get nombre => _nombre;

  set nombre(nombre) {
    _nombre = nombre;
    notifyListeners();
  }

  get apellido => _apellido;

  set apellido(apellido) {
    _apellido = apellido;
    notifyListeners();
  }

  get celular => _celular;

  set celular(celular) {
    _celular = celular;
    notifyListeners();
  }

  get clave => _clave;

  set clave(clave) {
    _clave = clave;
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

  final databaseReference = FirebaseFirestore.instance;

  void registrarme() async {
    try {

      if (clave.toString().trim() != repiteClave.toString().trim()) {
        print('las claves son distintas');
        return;
      }

      UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: correo, password: clave);

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

    

  }

  void irRegistroUsuario() async {
    
  }
}
