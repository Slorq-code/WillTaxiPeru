import 'package:flutter/material.dart';

class KeyboardNumericWidget extends StatelessWidget {

  final String value;
  final ValueChanged<String> valueChanged;
  final List<int> listNumber;

  const KeyboardNumericWidget({Key key, this.value, this.valueChanged, this.listNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _designKeyboard(listNumber),
    );
  }

  Widget _designKeyboard(List<int> listNumber) {
    return Container(
                color: Color.fromRGBO(249, 249, 249, 1.0),
                padding: new EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  children: <Widget>[

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center Row contents horizontally,
                      crossAxisAlignment: CrossAxisAlignment.center, // Center Row contents vertically,
                      children: <Widget>[

                        SizedBox(
                          width: 90,
                          height: 40,
                          child: RaisedButton(
                            // INICIO CODIGO PARA EVITAR EL EFECTO AL PRESIONAR EL BOTON
                            splashColor: Color.fromRGBO(231, 231, 231, 1.0),
                            highlightColor: Color.fromRGBO(231, 231, 231, 1.0),
                            highlightElevation: 0,
                            elevation: 0,
                            // FIN CODIGO
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            color: Color.fromRGBO(231, 231, 231, 1.0),
                            child: Container(
                              child: Text(listNumber[0].toString(), style: TextStyle(color: Color.fromRGBO(80, 80, 80, 1.0)),),
                            ),
                            onPressed: () {
                              valueChanged(value + listNumber[0].toString());
                            }, 
                          ),
                        ),

                        SizedBox(width: 10.0,),

                        SizedBox(
                          width: 90,
                          height: 40,
                          child: RaisedButton(
                            splashColor: Color.fromRGBO(231, 231, 231, 1.0),
                            highlightColor: Color.fromRGBO(231, 231, 231, 1.0),
                            highlightElevation: 0,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            color: Color.fromRGBO(231, 231, 231, 1.0),
                            child: Container(
                              child: Text(listNumber[1].toString(), style: TextStyle(color: Color.fromRGBO(80, 80, 80, 1.0)),),
                            ),
                            onPressed: () {
                              valueChanged(value + listNumber[1].toString());
                            }, 
                          ),
                        ),

                        SizedBox(width: 10.0,),

                        SizedBox(
                          width: 90,
                          height: 40,
                          child: RaisedButton(
                            splashColor: Color.fromRGBO(231, 231, 231, 1.0),
                            highlightColor: Color.fromRGBO(231, 231, 231, 1.0),
                            highlightElevation: 0,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            color: Color.fromRGBO(231, 231, 231, 1.0),
                            child: Container(
                              child: Text(listNumber[2].toString(), style: TextStyle(color: Color.fromRGBO(80, 80, 80, 1.0)),),
                            ),
                            onPressed: () {
                              valueChanged(value + listNumber[2].toString());
                            }, 
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.0,),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center Row contents horizontally,
                      crossAxisAlignment: CrossAxisAlignment.center, // Center Row contents vertically,
                      children: <Widget>[

                        SizedBox(
                          width: 90,
                          height: 40,
                          child: RaisedButton(
                            splashColor: Color.fromRGBO(231, 231, 231, 1.0),
                            highlightColor: Color.fromRGBO(231, 231, 231, 1.0),
                            highlightElevation: 0,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            color: Color.fromRGBO(231, 231, 231, 1.0),
                            child: Container(
                              child: Text(listNumber[3].toString(), style: TextStyle(color: Color.fromRGBO(80, 80, 80, 1.0)),),
                            ),
                            onPressed: () {
                              valueChanged(value + listNumber[3].toString());
                            }, 
                          ),
                        ),

                        SizedBox(width: 10.0,),

                        SizedBox(
                          width: 90,
                          height: 40,
                          child: RaisedButton(
                            splashColor: Color.fromRGBO(231, 231, 231, 1.0),
                            highlightColor: Color.fromRGBO(231, 231, 231, 1.0),
                            highlightElevation: 0,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            color: Color.fromRGBO(231, 231, 231, 1.0),
                            child: Container(
                              child: Text(listNumber[4].toString(), style: TextStyle(color: Color.fromRGBO(80, 80, 80, 1.0)),),
                            ),
                            onPressed: () {
                              valueChanged(value + listNumber[4].toString());
                            }, 
                          ),
                        ),

                        SizedBox(width: 10.0,),

                        SizedBox(
                          width: 90,
                          height: 40,
                          child: RaisedButton(
                            splashColor: Color.fromRGBO(231, 231, 231, 1.0),
                            highlightColor: Color.fromRGBO(231, 231, 231, 1.0),
                            highlightElevation: 0,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            color: Color.fromRGBO(231, 231, 231, 1.0),
                            child: Container(
                              child: Text(listNumber[5].toString(), style: TextStyle(color: Color.fromRGBO(80, 80, 80, 1.0)),),
                            ),
                            onPressed: () {
                              valueChanged(value + listNumber[5].toString());
                            }, 
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.0,),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center Row contents horizontally,
                      crossAxisAlignment: CrossAxisAlignment.center, // Center Row contents vertically,
                      children: <Widget>[

                        SizedBox(
                          width: 90,
                          height: 40,
                          child: RaisedButton(
                            splashColor: Color.fromRGBO(231, 231, 231, 1.0),
                            highlightColor: Color.fromRGBO(231, 231, 231, 1.0),
                            highlightElevation: 0,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            color: Color.fromRGBO(231, 231, 231, 1.0),
                            child: Container(
                              child: Text(listNumber[6].toString(), style: TextStyle(color: Color.fromRGBO(80, 80, 80, 1.0)),),
                            ),
                            onPressed: () {
                              valueChanged(value + listNumber[6].toString());
                            }, 
                          ),
                        ),

                        SizedBox(width: 10.0,),

                        SizedBox(
                          width: 90,
                          height: 40,
                          child: RaisedButton(
                            splashColor: Color.fromRGBO(231, 231, 231, 1.0),
                            highlightColor: Color.fromRGBO(231, 231, 231, 1.0),
                            highlightElevation: 0,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            color: Color.fromRGBO(231, 231, 231, 1.0),
                            child: Container(
                              child: Text(listNumber[7].toString(), style: TextStyle(color: Color.fromRGBO(80, 80, 80, 1.0)),),
                            ),
                            onPressed: () {
                              valueChanged(value + listNumber[7].toString());
                            }, 
                          ),
                        ),

                        SizedBox(width: 10.0,),

                        SizedBox(
                          width: 90,
                          height: 40,
                          child: RaisedButton(
                            splashColor: Color.fromRGBO(231, 231, 231, 1.0),
                            highlightColor: Color.fromRGBO(231, 231, 231, 1.0),
                            highlightElevation: 0,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            color: Color.fromRGBO(231, 231, 231, 1.0),
                            child: Container(
                              child: Text(listNumber[8].toString(), style: TextStyle(color: Color.fromRGBO(80, 80, 80, 1.0)),),
                            ),
                            onPressed: () {
                              valueChanged(value + listNumber[8].toString());
                            }, 
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.0,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center Row contents horizontally,
                      crossAxisAlignment: CrossAxisAlignment.center, // Center Row contents vertically,
                      children: <Widget>[

                        SizedBox(
                          width: 90,
                          height: 40,
                        ),

                        SizedBox(width: 10.0,),

                        SizedBox(
                          width: 90,
                          height: 40,
                          child: RaisedButton(
                            splashColor: Color.fromRGBO(231, 231, 231, 1.0),
                            highlightColor: Color.fromRGBO(231, 231, 231, 1.0),
                            highlightElevation: 0,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            color: Color.fromRGBO(231, 231, 231, 1.0),
                            child: Container(
                              child: Text(listNumber[9].toString(), style: TextStyle(color: Color.fromRGBO(80, 80, 80, 1.0)),),
                            ),
                            onPressed: () {
                              valueChanged(value + listNumber[9].toString());
                            }, 
                          ),
                        ),

                        SizedBox(width: 10.0,),

                        SizedBox(
                          width: 90,
                          height: 40,
                          child: IconButton(
                            icon: Icon(Icons.cancel, color: Color.fromRGBO(0, 122, 209, 1),),
                            onPressed: () {
                              if (value.length > 0) {
                                valueChanged(value.substring(0, value.length - 1));
                              }
                            }
                          ),
                        ),
                      ],
                    ),


                  ],
                ),
              );
  }
}