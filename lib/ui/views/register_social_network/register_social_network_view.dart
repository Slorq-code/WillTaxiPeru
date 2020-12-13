import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import 'package:flutter/material.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:taxiapp/theme/pallete_color.dart';
import 'package:taxiapp/ui/views/register_social_network/register_social_network_viewmodel.dart';

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
                      "Celular",
                      style: TextStyle(color: Color.fromRGBO(130, 130, 130, 1.0), fontSize: 15),
                    ),

                    SizedBox(height: 10.0,),

                    TextFormField(
                      initialValue: model.phone,
                      inputFormatters: [new LengthLimitingTextInputFormatter(50),],
                      keyboardType: TextInputType.phone,
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
                      onChanged: (value) => model.phone = value,
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
                            child: Text('REGISTRARME', style: TextStyle(color: Colors.white),),
                          ),
                          onPressed: () {
                            if (!model.isBusy) {
                              model.signin();
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
