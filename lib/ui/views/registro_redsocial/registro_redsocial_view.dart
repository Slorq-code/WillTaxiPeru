import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import 'package:flutter/material.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:taxiapp/theme/pallete_color.dart';
import 'package:taxiapp/ui/views/registro_redsocial/registro_redsocial_viewmodel.dart';

class RegistroRedsocialView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegistroRedsocialViewModel>.nonReactive(
      viewModelBuilder: () => RegistroRedsocialViewModel(),
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

class _BodyRegistro extends HookViewModelWidget<RegistroRedsocialViewModel> {
  _BodyRegistro({
    Key key,
  }) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, RegistroRedsocialViewModel model) {
    return _crearFormulario(model, context);
  }
  
  Widget _crearFormulario(RegistroRedsocialViewModel model, context) {

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
                      initialValue: model.celular,
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
                      onChanged: (value) => model.celular = value,
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
                              model.registrarme();
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
