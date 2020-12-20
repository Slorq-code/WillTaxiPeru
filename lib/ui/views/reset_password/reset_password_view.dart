import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import 'package:flutter/material.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/theme/pallete_color.dart';

import 'package:taxiapp/extensions/string_extension.dart';
import 'package:taxiapp/ui/views/reset_password/reset_password_viewmodel.dart';

class ResetPasswordView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ResetPasswordViewModel>.nonReactive(
      viewModelBuilder: () => ResetPasswordViewModel(context),
      onModelReady: (model) => model.initial(),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: true,
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
          ),
          backgroundColor: PalleteColor.backgroundColor,
          body: _BodyRegistro(),
        ),
      ),
    );
  }
}

class _BodyRegistro extends HookViewModelWidget<ResetPasswordViewModel> {
  _BodyRegistro({
    Key key,
  }) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, ResetPasswordViewModel model) {
    return _crearFormulario(model, context);
  }
  
  Widget _crearFormulario(ResetPasswordViewModel model, context) {

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
                      Keys.reset_password.localize(),
                      style: const TextStyle(color: Color.fromRGBO(130, 130, 130, 1.0), fontSize: 15, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 20.0,),

                    TextFormField(
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
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                      onChanged: (value) => model.email = value,
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
                              model.resetPassword();
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
