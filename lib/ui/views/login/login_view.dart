import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import 'package:flutter/material.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:taxiapp/app/router.gr.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/models/enums/auth_type.dart';
import 'package:taxiapp/theme/pallete_color.dart';
import 'package:taxiapp/ui/views/login/login_viewmodel.dart';
import 'package:taxiapp/extensions/string_extension.dart';

import 'package:flutter_svg/flutter_svg.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.nonReactive(
      viewModelBuilder: () => LoginViewModel(context),
      onModelReady: (model) => model.initial(),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          backgroundColor: PalleteColor.backgroundColor,
          body: _BodyLogin(),
        ),
      ),
    );
  }
}

class _BodyLogin extends HookViewModelWidget<LoginViewModel> {
  _BodyLogin({
    Key key,
  }) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, LoginViewModel model) {
    /*
    return Center(
      child: Text(
        Keys.accept.localize(),
        style: const TextStyle(color: Colors.white),
      ),
    );
    */
    return _crearFormulario(model, context);
  }

  final textFieldFocusNodePassword = FocusNode();

  Widget _crearFormulario(LoginViewModel model, context) {
    return SafeArea(
      child: Column(
        children: [
          /*
            Container(
              alignment: Alignment.center, 
              child: Image.asset(
                  'assets/images/img_background.jpg',
                  height: 120.0,
                  width: double.infinity,
                  //width: 150.0,
                  fit: BoxFit.fill,
              ),
              color: Colors.white,
            ),
            */
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                children: <Widget>[
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    Keys.login.localize(),
                    style: const TextStyle(color: Color.fromRGBO(130, 130, 130, 1.0), fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    initialValue: model.user,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50),
                    ],
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: Keys.email.localize(),
                      labelStyle: const TextStyle(color: Color.fromRGBO(130, 130, 130, 1.0)),
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(40, 180, 245, 1.0),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(130, 130, 130, 1.0),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          model.passwordOfuscado ? Icons.visibility_off : Icons.visibility,
                          color: const Color.fromRGBO(130, 130, 130, 1.0),
                        ),
                        onPressed: () {
                          model.passwordOfuscado = !model.passwordOfuscado;

                          /*INICIO CODIGO PARA DESACTIVAR EL EVENTO ONTAP DEL TEXTFIELD*/
                          textFieldFocusNodePassword.unfocus();
                          // Disable text field's focus node request
                          textFieldFocusNodePassword.canRequestFocus = false;
                          //Enable the text field's focus node request after some delay
                          Future.delayed(const Duration(milliseconds: 100), () {
                            textFieldFocusNodePassword.canRequestFocus = true;
                          });
                          /*FIN CODIGO*/
                        },
                      ),
                    ),
                    style: const TextStyle(
                      color: Color.fromRGBO(130, 130, 130, 1.0),
                      fontSize: 14.0,
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    onChanged: (value) => model.user = value,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),

                  /*
                    Text(
                      labelText: Keys.email.localize(),
                      style: TextStyle(color: Color.fromRGBO(130, 130, 130, 1.0), fontSize: 15),
                    ),

                    SizedBox(height: 10.0,),
                    */

                  Focus(
                    child: TextFormField(
                      obscureText: model.passwordOfuscado,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(12),
                      ],
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: Keys.password.localize(),
                        labelStyle: const TextStyle(color: Color.fromRGBO(130, 130, 130, 1.0)),
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(40, 180, 245, 1.0),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(130, 130, 130, 1.0),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            model.passwordOfuscado ? Icons.visibility_off : Icons.visibility,
                            color: const Color.fromRGBO(130, 130, 130, 1.0),
                          ),
                          onPressed: () {
                            model.passwordOfuscado = !model.passwordOfuscado;

                            /*INICIO CODIGO PARA DESACTIVAR EL EVENTO ONTAP DEL TEXTFIELD*/
                            textFieldFocusNodePassword.unfocus();
                            // Disable text field's focus node request
                            textFieldFocusNodePassword.canRequestFocus = false;
                            //Enable the text field's focus node request after some delay
                            Future.delayed(const Duration(milliseconds: 100), () {
                              textFieldFocusNodePassword.canRequestFocus = true;
                            });
                            /*FIN CODIGO*/
                          },
                        ),
                      ),
                      style: const TextStyle(
                        color: Color.fromRGBO(130, 130, 130, 1.0),
                        fontSize: 14.0,
                      ),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                      onChanged: (value) => model.password = value,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 130,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FloatingActionButton(
                            heroTag: 'btnGoogle',
                            backgroundColor: Colors.transparent,
                            child: SvgPicture.asset(
                              'assets/icons/ic_google.svg',
                              fit: BoxFit.fitWidth,
                            ),
                            onPressed: () {
                              if (!model.isBusy) {
                                model.login(AuthType.Google);
                              }
                            },
                          ),
                          FloatingActionButton(
                            heroTag: 'btnFacebook',
                            backgroundColor: Colors.transparent,
                            child: SvgPicture.asset(
                              'assets/icons/ic_facebook.svg',
                              fit: BoxFit.fitWidth,
                            ),
                            onPressed: () {
                              if (!model.isBusy) {
                                model.login(AuthType.Facebook);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 200,
                      height: 40,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        color: const Color.fromRGBO(255, 165, 0, 1.0),
                        child: Container(
                          child: Text(
                            Keys.continue_label.localize(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        onPressed: () {
                          if (!model.isBusy) {
                            model.login(AuthType.User);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 40,
                      child: RichText(
                        text: TextSpan(
                          text: Keys.login_dont_have_account.localize(),
                          style: const TextStyle(color: Color.fromRGBO(130, 130, 130, 1.0)),
                          children: <TextSpan>[
                            const TextSpan(
                              text: ', ',
                              style: TextStyle(color: Color.fromRGBO(130, 130, 130, 1.0)),
                            ),
                            TextSpan(
                                text: Keys.sign_up.localize(),
                                style: const TextStyle(
                                    decoration: TextDecoration.underline, fontWeight: FontWeight.bold, color: Color.fromRGBO(130, 130, 130, 1.0)),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    if (!model.isBusy) {
                                      model.irRegistroUsuario();
                                    }
                                  }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  RaisedButton(
                    color: Colors.blue,
                    child: const Text('To Principal view'),
                    onPressed: () => ExtendedNavigator.root.push(Routes.principalViewRoute),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
