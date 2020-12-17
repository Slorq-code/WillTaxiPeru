import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import 'package:flutter/material.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/theme/pallete_color.dart';
import 'package:taxiapp/ui/views/register_social_network/register_social_network_viewmodel.dart';

import 'package:taxiapp/extensions/string_extension.dart';

class RegisterSocialNetworkView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterSocialNetworkViewModel>.nonReactive(
      viewModelBuilder: () => RegisterSocialNetworkViewModel(),
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

class _BodyRegistro extends HookViewModelWidget<RegisterSocialNetworkViewModel> {
  _BodyRegistro({
    Key key,
  }) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, RegisterSocialNetworkViewModel model) {
    return _crearFormulario(model, context);
  }
  
  Widget _crearFormulario(RegisterSocialNetworkViewModel model, context) {

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

                    TextFormField(
                      initialValue: model.phone,
                      inputFormatters: [LengthLimitingTextInputFormatter(50),],
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
                      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      onChanged: (value) => model.phone = value,
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
                          child: Container(
                            child: Text(Keys.continue_label.localize(), style: const TextStyle(color: Colors.white),),
                          ),
                          onPressed: () {
                            if (!model.isBusy) {
                              model.signin();
                            }
                          },
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
