import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked/stacked.dart';

import 'package:flutter/material.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:taxiapp/theme/pallete_color.dart';
import 'package:taxiapp/ui/views/login/login_viewmodel.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.nonReactive(
      viewModelBuilder: () => LoginViewModel(),
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
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
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
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  children: <Widget>[

                    SizedBox(height: 10.0,),
                    
                    Text(
                      "Correo",
                      style: TextStyle(color: Color.fromRGBO(130, 130, 130, 1.0), fontSize: 15),
                    ),

                    SizedBox(height: 10.0,),

                    TextFormField(
                      initialValue: model.usuario,
                      inputFormatters: [new LengthLimitingTextInputFormatter(50),],
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "",
                        fillColor: Colors.white,
                        contentPadding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(40, 180, 245, 1.0),
                          ),
                          borderRadius: BorderRadius.circular(0.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(130, 130, 130, 1.0),
                          ),
                          borderRadius: BorderRadius.circular(0.5),
                        ),
                      ),
                      style: TextStyle(
                        color: Color.fromRGBO(130, 130, 130, 1.0),
                        fontSize: 14.0,
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      onChanged: (value) => model.usuario = value,
                    ),
                    
                    SizedBox(height: 15.0,),

                    Text(
                      "Contraseña",
                      style: TextStyle(color: Color.fromRGBO(130, 130, 130, 1.0), fontSize: 15),
                    ),

                    SizedBox(height: 10.0,),

                    Focus(
                      child: TextFormField(
                        controller: model.controllerClave,
                        obscureText: model.passwordOfuscado,
                        inputFormatters: [new LengthLimitingTextInputFormatter(12),],
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "",
                          fillColor: Colors.white,
                          contentPadding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(40, 180, 245, 1.0),
                            ),
                            borderRadius: BorderRadius.circular(0.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(130, 130, 130, 1.0),
                            ),
                            borderRadius: BorderRadius.circular(0.5),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              model.passwordOfuscado
                              ? Icons.visibility_off
                              : Icons.visibility,
                              color: Color.fromRGBO(130, 130, 130, 1.0),
                            ),
                            onPressed: () {

                              model.passwordOfuscado = !model.passwordOfuscado;

                              /*INICIO CODIGO PARA DESACTIVAR EL EVENTO ONTAP DEL TEXTFIELD*/
                              textFieldFocusNodePassword.unfocus();
                              // Disable text field's focus node request
                              textFieldFocusNodePassword.canRequestFocus = false;
                              //Enable the text field's focus node request after some delay
                              Future.delayed(Duration(milliseconds: 100), () {
                                textFieldFocusNodePassword.canRequestFocus = true;
                              });
                              /*FIN CODIGO*/

                            },
                          ),
                        ),
                        style: TextStyle(
                          color: Color.fromRGBO(130, 130, 130, 1.0),
                          fontSize: 14.0,
                        ),
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                        onChanged: (value) => model.clave = value,
                      ),
                    ),

                    SizedBox(height: 20.0,),

                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            FloatingActionButton(
                              heroTag: 'btnGoogle',
                              child: Icon(Icons.ac_unit),
                              onPressed: () {
                                model.ingresarGoogle();
                              },
                            ), FloatingActionButton(
                              heroTag: 'btnFacebook',
                              child: Icon(Icons.ac_unit_outlined),
                              onPressed: () {
                                model.ingresarFacebook();
                              },
                            ), FloatingActionButton(
                              heroTag: 'btnTwitter',
                              child: Icon(Icons.ac_unit_rounded),
                              onPressed: () {
                                
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20.0,),

                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 200,
                        height: 40,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          color: Color.fromRGBO(12, 128, 206, 1.0),
                          child: Container(
                            child: Text('INGRESAR', style: TextStyle(color: Colors.white),),
                          ),
                          onPressed: () {
                            if (!model.isBusy) {
                              model.iniciarSesion();
                            }
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 20.0,),

                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 200,
                        height: 40,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          color: Color.fromRGBO(12, 128, 206, 1.0),
                          child: Container(
                            child: Text('CREAR USUARIO', style: TextStyle(color: Colors.white),),
                          ),
                          onPressed: () {
                            if (!model.isBusy) {
                              model.irRegistroUsuario();
                            }
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 10.0,),

                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }
}
