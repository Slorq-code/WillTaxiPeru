import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import 'package:flutter/material.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/theme/pallete_color.dart';
import 'package:taxiapp/ui/views/register/register_viewmodel.dart';

import 'package:taxiapp/extensions/string_extension.dart';

class RegisterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterViewModel>.nonReactive(
      viewModelBuilder: () => RegisterViewModel(context),
      onModelReady: (model) => model.initial(),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          backgroundColor: PalleteColor.backgroundColor,
          body: _BodyRegistro(),
        ),
      ),
    );
  }
}

class _BodyRegistro extends HookViewModelWidget<RegisterViewModel> {
  _BodyRegistro({
    Key key,
  }) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, RegisterViewModel model) {
    return _crearFormulario(model, context);
  }

  Widget _crearFormulario(RegisterViewModel model, context) {
    final node = FocusScope.of(context);
    return SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  children: <Widget>[

                    const SizedBox(height: 10.0,),
                    
                    Text(
                      Keys.sign_up.localize(),
                      style: const TextStyle(color: Color.fromRGBO(130, 130, 130, 1.0), fontSize: 15, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 20.0,),

                    Focus(
                        child: TextFormField(
                        initialValue: model.name,
                        inputFormatters: [LengthLimitingTextInputFormatter(50),],
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: Keys.first_name_and_surname.localize(),
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
                        ),
                        style: const TextStyle(
                          color: Color.fromRGBO(130, 130, 130, 1.0),
                          fontSize: 14.0,
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          node.nextFocus();
                        },
                        onChanged: (value) => model.name = value,
                      ),
                    ),

                    const SizedBox(height: 15.0,),

                    Focus(
                      child: TextFormField(
                        initialValue: model.email,
                        inputFormatters: [LengthLimitingTextInputFormatter(50),],
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
                        ),
                        style: const TextStyle(
                          color: Color.fromRGBO(130, 130, 130, 1.0),
                          fontSize: 14.0,
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          node.nextFocus();
                        },
                        onChanged: (value) => model.email = value,
                      ),
                    ),

                    const SizedBox(height: 15.0,),

                    Focus(
                      child: TextFormField(
                        initialValue: model.cellphone,
                        inputFormatters: [LengthLimitingTextInputFormatter(9),],
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: Keys.mobile_phone.localize(),
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
                        ),
                        style: const TextStyle(
                          color: Color.fromRGBO(130, 130, 130, 1.0),
                          fontSize: 14.0,
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          node.nextFocus();
                        },
                        onChanged: (value) => model.cellphone = value,
                      ),
                    ),
                    
                    const SizedBox(height: 15.0,),

                    Focus(
                      child: TextFormField(
                        obscureText: model.passwordOfuscado,
                        inputFormatters: [LengthLimitingTextInputFormatter(20),],
                        keyboardType: TextInputType.text,
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
                              model.passwordOfuscado
                              ? Icons.visibility_off
                              : Icons.visibility,
                              color: const Color.fromRGBO(130, 130, 130, 1.0),
                            ),
                            onPressed: () {
                              model.passwordOfuscado = !model.passwordOfuscado;
                            },
                          ),
                        ),
                        style: const TextStyle(
                          color: Color.fromRGBO(130, 130, 130, 1.0),
                          fontSize: 14.0,
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          node.nextFocus();
                        },
                        onChanged: (value) => model.password = value,
                      ),
                    ),

                    const SizedBox(height: 15.0,),

                    Focus(
                      child: TextFormField(
                        obscureText: model.repitePasswordOfuscado,
                        inputFormatters: [LengthLimitingTextInputFormatter(20),],
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: Keys.repeat_password.localize(),
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
                              model.repitePasswordOfuscado
                              ? Icons.visibility_off
                              : Icons.visibility,
                              color: const Color.fromRGBO(130, 130, 130, 1.0),
                            ),
                            onPressed: () {
                              model.repitePasswordOfuscado = !model.repitePasswordOfuscado;
                            },
                          ),
                        ),
                        style: const TextStyle(
                          color: Color.fromRGBO(130, 130, 130, 1.0),
                          fontSize: 14.0,
                        ),
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          node.unfocus();
                        },
                        onChanged: (value) => model.repeatPassword= value,
                      ),
                    ),

                    const SizedBox(height: 20.0,),

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
                          disabledColor: const Color.fromRGBO(255, 200, 120, 1.0),
                          child: Container(
                            child: Text(Keys.continue_label.localize(), style: const TextStyle(color: Colors.white),),
                          ),
                          onPressed: (!model.enableBtnContinue ? null : () {
                            if (!model.isBusy) {
                              model.signin();
                            }
                          }),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10.0,),

                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }
}
