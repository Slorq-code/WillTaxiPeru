import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/app/router.gr.dart';
import 'package:taxiapp/models/enums/auth_type.dart';
import 'package:taxiapp/models/enums/user_type.dart';
import 'package:taxiapp/services/auth_social_network_service.dart';
import 'package:taxiapp/services/firestore_user_service.dart';
import 'package:taxiapp/ui/widgets/loader/color_loader_widget.dart';
import 'package:taxiapp/utils/navigator_util.dart';

class LoginViewModel extends BaseViewModel {

  BuildContext context;

  LoginViewModel(BuildContext context) {
    this.context = context;
  }

  final NavigationService _navigationService = locator<NavigationService>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // * Getters
  GlobalKey<FormState> get formKey => _formKey;

  // * Functions

  final AuthSocialNetwork _authSocialNetwork = locator<AuthSocialNetwork>();
  final FirestoreUser _firestoreUser = locator<FirestoreUser>();

  void goToEnrollPage() async {
    await _navigationService.navigateTo(Routes.loginViewRoute);
  }

  void initial() async {
    user = '';
    password = '';
    passwordOfuscado = true;
  }

  String _user;
  String _password;
  bool _passwordOfuscado;

  get user => _user;

  set user(user) {
    _user = user;
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

  void login(AuthType authType) async {
    setBusy(true);
    try {

      if (AuthType.User.index == authType.index) {

        NavigatorUtil.showPage(context, ColorLoaderWidget());

        if (user.toString().trim() == '' || password.toString().trim() == '') {
          print('USERNAME AND PASSWORD REQUIRED');
          NavigatorUtil.hidePage(context);
          return;
        }
      }

      await _authSocialNetwork.login(user.toString().trim(), password.toString().trim(), authType);
      print(_authSocialNetwork.isLoggedIn);
      if (_authSocialNetwork.isLoggedIn) {

        var userFounded = await _firestoreUser.userFind(_authSocialNetwork.user.uid);
        
        if (userFounded != null) {

          _authSocialNetwork.user = userFounded;

          if (AuthType.User.index == authType.index) {
            NavigatorUtil.hidePage(context);
          }

          // LOGIN SUCESSFULL, NAVIGATE TO PRINCIPAL PAGE
          await ExtendedNavigator.root.push(Routes.principalViewRoute);

        } else {

          if (AuthType.User.index != authType.index) {

            // IF USER DONT EXISTS, COMPLETE REGISTER
            _authSocialNetwork.user.userType = UserType.Client;

            await ExtendedNavigator.root.push(Routes.registerSocialNetworkViewRoute);

          }

        }

      } else {

        if (AuthType.User.index == authType.index) {
          NavigatorUtil.hidePage(context);
        }

      }

    } catch(signUpError) {
      
      if(signUpError is FirebaseAuthException) {
        
        if(signUpError.code == 'account-exists-with-different-credential') {
          
          print('THE USER IS ALREADY REGISTERED WITH ANOTHER SOCIAL NETWORK');

        } else if(signUpError.code == 'wrong-password' || signUpError.code == 'user-not-found') {

          print('INVALID PASSWORD');

        } else if(signUpError.code == 'invalid-email') {

          print('INVALID EMAIL');

        } else {

          print(signUpError.code);

        }

      }

    } finally {
      setBusy(false);

      if (AuthType.User.index == authType.index) {
          NavigatorUtil.hidePage(context);
      }
    }
  }

  void irRegistroUsuario() async {
    await ExtendedNavigator.root.push(Routes.registerViewRoute);
  }
}
