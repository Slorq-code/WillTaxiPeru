import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/app/router.gr.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/models/enums/auth_type.dart';
import 'package:taxiapp/models/enums/user_type.dart';
import 'package:taxiapp/models/user_model.dart';
import 'package:taxiapp/services/api.dart';
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
  final Api _api = locator<Api>();

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
  set documentType(newValue) {
    _documentType = newValue;
    notifyListeners();
  }

  String _document;
  String get document => _document;
  set document(value) {
    _document = value;
    notifyListeners();
  }

  String _plate;
  String get plate => _plate;
  set plate(value) {
    _plate = value;
    notifyListeners();
  }

  int _typeService;
  int get typeService => _typeService;
  set typeService(newValue) {
    _typeService = newValue;
    notifyListeners();
  }

  String _mark;
  String get mark => _mark;
  set mark(value) {
    _mark = value;
    notifyListeners();
  }

  String _model;
  String get model => _model;
  set model(value) {
    _model = value;
    notifyListeners();
  }

  String _yearProduction;
  String get yearProduction => _yearProduction;
  set yearProduction(value) {
    _yearProduction = value;
    notifyListeners();
  }

  File _image;
  File get image => _image;
  set image(value) {
    _image = value;
    notifyListeners();
  }

  final picker = ImagePicker();

  void selecImage(ImageSource imageSource) async {
    final pickedFile = await picker.getImage(source: imageSource);
    if (pickedFile != null) {
      image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }

  void showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: Text(Keys.gallery.localize()),
                      onTap: () {
                        selecImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: Text(Keys.camera.localize()),
                    onTap: () {
                      selecImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
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
      Utils.isValidPasswordLength(password) &&
      (image != null);

  void signin() async {
    setBusy(true);

    final packageInfo = await Utils.getPackageInfo();
    try {
      Alert(context: context).loading(Keys.loading.localize());

      if (password.toString().trim() != repeatPassword.toString().trim()) {
        ExtendedNavigator.root.pop();
        Alert(
                context: context,
                title: packageInfo.appName,
                label: Keys.password_dont_match.localize())
            .alertMessage();
        return;
      }

      final userCredential =
          await _authSocialNetwork.createUser(email, password);

      if (userCredential != null) {
        // USER CREATED ON FIREBASE AUTHENTICATION

        final userFounded =
            await _firestoreUser.findUserById(userCredential.user.uid);

        if (userFounded != null) {
          // USER ALREADY EXISTS ON CLOUD FIRESTORE

          ExtendedNavigator.root.pop();
          Alert(
                  context: context,
                  title: packageInfo.appName,
                  label: Keys.email_already_registered.localize())
              .alertMessage();
        } else {
          // USER DONT EXISTS ON CLOUD FIRESTORE
          var token = await userCredential.user.getIdToken();
          _authSocialNetwork.user = UserModel(
              uid: userCredential.user.uid,
              authType: AuthType.User,
              userType: UserType.Driver,
              email: email.toString().toLowerCase().trim(),
              name: name.toString().trim(),
              phone: phone.toString().trim(),
              driverInfo: DriverInfoModel(
                  documentType: documentType,
                  document: document,
                  typeService: typeService,
                  plate: plate,
                  marc: mark,
                  model: model,
                  fabrishYear: yearProduction));

          final userRegister =
              await _firestoreUser.driverRegister(_authSocialNetwork.user);
          if (userRegister) {
            await _token.saveToken(token);
            try {
              var urlImage =
                  await _api.sendImage(image, _authSocialNetwork.user.uid);
              await _firestoreUser.updateImageUser(
                  userId: _authSocialNetwork.user.uid, urlImage: urlImage);
              _authSocialNetwork.user.image = urlImage;
              ExtendedNavigator.root.pop();
              // USER CREATED ON CLOUD FIRESTORE
              Alert(
                      context: context,
                      title: packageInfo.appName,
                      label: Keys.user_created_successfully.localize())
                  .alertCallBack(() {
                _redirectLogin();
                // ExtendedNavigator.root.push(Routes.principalViewRoute);
              });
            } on Exception catch (e) {
              print(e.toString());
              ExtendedNavigator.root.pop();
              Alert(
                      context: context,
                      title: packageInfo.appName,
                      label: Keys.user_created_and_error_in_image.localize())
                  .alertCallBack(() {
                _redirectLogin();
                // ExtendedNavigator.root.push(Routes.principalViewRoute);
              });
            }
          } else {
            // ERROR CREATING USER ON CLOUD FIRESTORE
            Alert(
                    context: context,
                    title: packageInfo.appName,
                    label: Keys.request_not_processed_correctly.localize())
                .alertMessage();
          }
        }
      } else {
        ExtendedNavigator.root.pop();
        Alert(
                context: context,
                title: packageInfo.appName,
                label: Keys.request_not_processed_correctly.localize())
            .alertMessage();
      }
    } catch (signUpError) {
      if (signUpError is FirebaseAuthException) {
        print(signUpError.code);
        if (signUpError.code == 'email-already-in-use') {
          ExtendedNavigator.root.pop();
          Alert(
                  context: context,
                  title: packageInfo.appName,
                  label: Keys.email_already_registered.localize())
              .alertMessage();
        } else {
          ExtendedNavigator.root.pop();
          Alert(
                  context: context,
                  title: packageInfo.appName,
                  label: Keys.request_not_processed_correctly.localize())
              .alertMessage();
        }
      }
    } finally {
      setBusy(false);
    }
  }

  void _redirectLogin()async {
    await _authSocialNetwork.logout();
    _token.deleteToken();
    await ExtendedNavigator.root.push(Routes.loginViewRoute);
  }
}
