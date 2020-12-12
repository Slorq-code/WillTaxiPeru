import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked/stacked.dart';

import 'package:flutter/material.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:taxiapp/theme/pallete_color.dart';
import 'package:taxiapp/ui/views/registro/registro_viewmodel.dart';

class RegistroView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegistroViewModel>.nonReactive(
      viewModelBuilder: () => RegistroViewModel(),
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

class _BodyRegistro extends HookViewModelWidget<RegistroViewModel> {
  _BodyRegistro({
    Key key,
  }) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, RegistroViewModel model) {
    return _crearFormulario(model, context);
  }
  
  Widget _crearFormulario(RegistroViewModel model, context) {

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
                      "Nombres",
                      style: TextStyle(color: Color.fromRGBO(130, 130, 130, 1.0), fontSize: 15),
                    ),

                    SizedBox(height: 10.0,),

                    TextFormField(
                      initialValue: model.nombre,
                      inputFormatters: [new LengthLimitingTextInputFormatter(50),],
                      keyboardType: TextInputType.text,
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
                      onChanged: (value) => model.nombre = value,
                    ),
                    
                    SizedBox(height: 15.0,),

                    Text(
                      "Apellidos",
                      style: TextStyle(color: Color.fromRGBO(130, 130, 130, 1.0), fontSize: 15),
                    ),

                    SizedBox(height: 10.0,),

                    TextFormField(
                      initialValue: model.apellido,
                      inputFormatters: [new LengthLimitingTextInputFormatter(50),],
                      keyboardType: TextInputType.text,
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
                      onChanged: (value) => model.apellido = value,
                    ),
                    
                    SizedBox(height: 15.0,),

                    Text(
                      "Correo",
                      style: TextStyle(color: Color.fromRGBO(130, 130, 130, 1.0), fontSize: 15),
                    ),

                    SizedBox(height: 10.0,),

                    TextFormField(
                      initialValue: model.correo,
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
                      onChanged: (value) => model.correo = value,
                    ),

                    SizedBox(height: 15.0,),

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
                    
                    SizedBox(height: 15.0,),

                    Text(
                      "Contraseña",
                      style: TextStyle(color: Color.fromRGBO(130, 130, 130, 1.0), fontSize: 15),
                    ),

                    SizedBox(height: 10.0,),

                    Focus(
                      child: TextFormField(
                        obscureText: model.passwordOfuscado,
                        inputFormatters: [new LengthLimitingTextInputFormatter(12),],
                        keyboardType: TextInputType.text,
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

                    SizedBox(height: 15.0,),

                    Text(
                      "Repita Contraseña",
                      style: TextStyle(color: Color.fromRGBO(130, 130, 130, 1.0), fontSize: 15),
                    ),

                    SizedBox(height: 10.0,),

                    Focus(
                      child: TextFormField(
                        obscureText: model.repitePasswordOfuscado,
                        inputFormatters: [new LengthLimitingTextInputFormatter(12),],
                        keyboardType: TextInputType.text,
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
                              model.repitePasswordOfuscado
                              ? Icons.visibility_off
                              : Icons.visibility,
                              color: Color.fromRGBO(130, 130, 130, 1.0),
                            ),
                            onPressed: () {
                              model.repitePasswordOfuscado = !model.repitePasswordOfuscado;
                            },
                          ),
                        ),
                        style: TextStyle(
                          color: Color.fromRGBO(130, 130, 130, 1.0),
                          fontSize: 14.0,
                        ),
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                        onChanged: (value) => model.repiteClave = value,
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
