import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/app/router.gr.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/models/enums/auth_type.dart';
import 'package:taxiapp/models/enums/user_type.dart';
import 'package:taxiapp/models/user_model.dart';
import 'package:taxiapp/services/auth_social_network_service.dart';
import 'package:taxiapp/services/firestore_user_service.dart';
import 'package:taxiapp/services/token.dart';
import 'package:taxiapp/utils/alerts.dart';

import 'package:taxiapp/extensions/string_extension.dart';
import 'package:taxiapp/utils/utils.dart';

class RegisterDriverViewModel extends BaseViewModel {
  BuildContext context;

  RegisterDriverViewModel(BuildContext context) {
    this.context = context;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // * Getters
  GlobalKey<FormState> get formKey => _formKey;

  // * Functions

  final AuthSocialNetwork _authSocialNetwork = locator<AuthSocialNetwork>();
  final FirestoreUser _firestoreUser = locator<FirestoreUser>();
  final Token _token = locator<Token>();

  void goToEnrollPage() async {}

  void initial() async {
    email = '';
    password = '';
    repeatPassword = '';
    phone = '';
    name = '';
    passwordOfuscado = true;
    repitePasswordOfuscado = true;
    documentType = '01';
    typeService = 2;
  }

  String _email;
  String _password;
  String _repeatPassword;
  String _phone;
  String _name;
  bool _passwordOfuscado;
  bool _repitePasswordOfuscado;

  String _documentType;
  String get documentType => _documentType;
  set documentType(newValue){
    _documentType = newValue;
     notifyListeners();
  }

  String document;
  String plate;

  int _typeService;
  int get typeService => _typeService;
  set typeService(newValue){
    _typeService = newValue;
     notifyListeners();
  }

  String mark;
  String model;
  String yearProduction;

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

  bool get enableBtnContinue =>
      !Utils.isNullOrEmpty(name) &&
      !Utils.isNullOrEmpty(email) &&
      !Utils.isNullOrEmpty(phone) &&
      !Utils.isNullOrEmpty(password) &&
      !Utils.isNullOrEmpty(repeatPassword) &&
      !Utils.isNullOrEmpty(plate) &&
      !Utils.isNullOrEmpty(mark) &&
      !Utils.isNullOrEmpty(model) &&
      !Utils.isNullOrEmpty(yearProduction) &&
      Utils.isValidEmail(email) &&
      Utils.isValidPhone(phone) &&
      Utils.isValidPasswordLength(password);

  void signin() async {
    setBusy(true);

    final packageInfo = await Utils.getPackageInfo();
    try {
      Alert(context: context).loading(Keys.loading.localize());

      if (password.toString().trim() != repeatPassword.toString().trim()) {
        ExtendedNavigator.root.pop();
        Alert(context: context, title: packageInfo.appName, label: Keys.password_dont_match.localize()).alertMessage();
        return;
      }

      final userCredential = await _authSocialNetwork.createUser(email, password);
      var token = await userCredential.user.getIdToken();

      if (userCredential != null) {
        // USER CREATED ON FIREBASE AUTHENTICATION

        final userFounded = await _firestoreUser.findUserById(_authSocialNetwork.user.uid);

        if (userFounded != null) {
          // USER ALREADY EXISTS ON CLOUD FIRESTORE

          ExtendedNavigator.root.pop();
          Alert(context: context, title: packageInfo.appName, label: Keys.email_already_registered.localize()).alertMessage();
        } else {
          // USER DONT EXISTS ON CLOUD FIRESTORE
            
          var driver = UserModel(
            uid:userCredential.user.uid,
            authType : AuthType.User,
            userType : UserType.Driver,
            email: email.toString().toLowerCase().trim(),
            name: name.toString().trim(),
            phone:phone.toString().trim(),
            driverInfo : DriverInfoModel(
              documentType: documentType,
              document: document,
              typeService: typeService,
              plate: plate,
              marc: mark,
              model: model,
              fabrishYear: yearProduction
            )
          );

          final userRegister = await _firestoreUser.driverRegister(driver);

          ExtendedNavigator.root.pop();

          if (userRegister) {
            await _token.saveToken(token);
            // USER CREATED ON CLOUD FIRESTORE
            Alert(context: context, title: packageInfo.appName, label: Keys.user_created_successfully.localize()).alertCallBack(() {
              ExtendedNavigator.root.push(Routes.principalViewRoute);
            });
          } else {
            // ERROR CREATING USER ON CLOUD FIRESTORE
            Alert(context: context, title: packageInfo.appName, label: Keys.request_not_processed_correctly.localize()).alertMessage();
          }
        }
      } else {
        ExtendedNavigator.root.pop();
        Alert(context: context, title: packageInfo.appName, label: Keys.request_not_processed_correctly.localize()).alertMessage();
      }
    } catch (signUpError) {
      if (signUpError is FirebaseAuthException) {
        print(signUpError.code);
        if (signUpError.code == 'email-already-in-use') {
          ExtendedNavigator.root.pop();
          Alert(context: context, title: packageInfo.appName, label: Keys.email_already_registered.localize()).alertMessage();
        } else {
          ExtendedNavigator.root.pop();
          Alert(context: context, title: packageInfo.appName, label: Keys.request_not_processed_correctly.localize()).alertMessage();
        }
      }
    } finally {
      setBusy(false);
    }
  }
}
