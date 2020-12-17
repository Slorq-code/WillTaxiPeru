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
                color: const Color.fromRGBO(249, 249, 249, 1.0),
                padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                            splashColor: const Color.fromRGBO(231, 231, 231, 1.0),
                            highlightColor: const Color.fromRGBO(231, 231, 231, 1.0),
                            highlightElevation: 0,
                            elevation: 0,
                            // FIN CODIGO
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            color: const Color.fromRGBO(231, 231, 231, 1.0),
                            child: Container(
                              child: Text(listNumber[0].toString(), style: const TextStyle(color: Color.fromRGBO(80, 80, 80, 1.0)),),
                            ),
                            onPressed: () {
                              valueChanged(value + listNumber[0].toString());
                            }, 
                          ),
                        ),

                        const SizedBox(width: 10.0,),

                        SizedBox(
                          width: 90,
                          height: 40,
                          child: RaisedButton(
                            splashColor: const Color.fromRGBO(231, 231, 231, 1.0),
                            highlightColor: const Color.fromRGBO(231, 231, 231, 1.0),
                            highlightElevation: 0,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            color: const Color.fromRGBO(231, 231, 231, 1.0),
                            child: Container(
                              child: Text(listNumber[1].toString(), style: const TextStyle(color: Color.fromRGBO(80, 80, 80, 1.0)),),
                            ),
                            onPressed: () {
                              valueChanged(value + listNumber[1].toString());
                            }, 
                          ),
                        ),

                        const SizedBox(width: 10.0,),

                        SizedBox(
                          width: 90,
                          height: 40,
                          child: RaisedButton(
                            splashColor: const Color.fromRGBO(231, 231, 231, 1.0),
                            highlightColor: const Color.fromRGBO(231, 231, 231, 1.0),
                            highlightElevation: 0,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            color: const Color.fromRGBO(231, 231, 231, 1.0),
                            child: Container(
                              child: Text(listNumber[2].toString(), style: const TextStyle(color: Color.fromRGBO(80, 80, 80, 1.0)),),
                            ),
                            onPressed: () {
                              valueChanged(value + listNumber[2].toString());
                            }, 
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10.0,),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center Row contents horizontally,
                      crossAxisAlignment: CrossAxisAlignment.center, // Center Row contents vertically,
                      children: <Widget>[

                        SizedBox(
                          width: 90,
                          height: 40,
                          child: RaisedButton(
                            splashColor: const Color.fromRGBO(231, 231, 231, 1.0),
                            highlightColor: const Color.fromRGBO(231, 231, 231, 1.0),
                            highlightElevation: 0,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            color: const Color.fromRGBO(231, 231, 231, 1.0),
                            child: Container(
                              child: Text(listNumber[3].toString(), style: const TextStyle(color: Color.fromRGBO(80, 80, 80, 1.0)),),
                            ),
                            onPressed: () {
                              valueChanged(value + listNumber[3].toString());
                            }, 
                          ),
                        ),

                        const SizedBox(width: 10.0,),

                        SizedBox(
                          width: 90,
                          height: 40,
                          child: RaisedButton(
                            splashColor: const Color.fromRGBO(231, 231, 231, 1.0),
                            highlightColor: const Color.fromRGBO(231, 231, 231, 1.0),
                            highlightElevation: 0,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            color: const Color.fromRGBO(231, 231, 231, 1.0),
                            child: Container(
                              child: Text(listNumber[4].toString(), style: const TextStyle(color: Color.fromRGBO(80, 80, 80, 1.0)),),
                            ),
                            onPressed: () {
                              valueChanged(value + listNumber[4].toString());
                            }, 
                          ),
                        ),

                        const SizedBox(width: 10.0,),

                        SizedBox(
                          width: 90,
                          height: 40,
                          child: RaisedButton(
                            splashColor: const Color.fromRGBO(231, 231, 231, 1.0),
                            highlightColor: const Color.fromRGBO(231, 231, 231, 1.0),
                            highlightElevation: 0,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            color: const Color.fromRGBO(231, 231, 231, 1.0),
                            child: Container(
                              child: Text(listNumber[5].toString(), style: const TextStyle(color: Color.fromRGBO(80, 80, 80, 1.0)),),
                            ),
                            onPressed: () {
                              valueChanged(value + listNumber[5].toString());
                            }, 
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10.0,),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center Row contents horizontally,
                      crossAxisAlignment: CrossAxisAlignment.center, // Center Row contents vertically,
                      children: <Widget>[

                        SizedBox(
                          width: 90,
                          height: 40,
                          child: RaisedButton(
                            splashColor: const Color.fromRGBO(231, 231, 231, 1.0),
                            highlightColor: const Color.fromRGBO(231, 231, 231, 1.0),
                            highlightElevation: 0,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            color: const Color.fromRGBO(231, 231, 231, 1.0),
                            child: Container(
                              child: Text(listNumber[6].toString(), style: const TextStyle(color: Color.fromRGBO(80, 80, 80, 1.0)),),
                            ),
                            onPressed: () {
                              valueChanged(value + listNumber[6].toString());
                            }, 
                          ),
                        ),

                        const SizedBox(width: 10.0,),

                        SizedBox(
                          width: 90,
                          height: 40,
                          child: RaisedButton(
                            splashColor: const Color.fromRGBO(231, 231, 231, 1.0),
                            highlightColor: const Color.fromRGBO(231, 231, 231, 1.0),
                            highlightElevation: 0,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            color: const Color.fromRGBO(231, 231, 231, 1.0),
                            child: Container(
                              child: Text(listNumber[7].toString(), style: const TextStyle(color: Color.fromRGBO(80, 80, 80, 1.0)),),
                            ),
                            onPressed: () {
                              valueChanged(value + listNumber[7].toString());
                            }, 
                          ),
                        ),

                        const SizedBox(width: 10.0,),

                        SizedBox(
                          width: 90,
                          height: 40,
                          child: RaisedButton(
                            splashColor: const Color.fromRGBO(231, 231, 231, 1.0),
                            highlightColor: const Color.fromRGBO(231, 231, 231, 1.0),
                            highlightElevation: 0,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            color: const Color.fromRGBO(231, 231, 231, 1.0),
                            child: Container(
                              child: Text(listNumber[8].toString(), style: const TextStyle(color: Color.fromRGBO(80, 80, 80, 1.0)),),
                            ),
                            onPressed: () {
                              valueChanged(value + listNumber[8].toString());
                            }, 
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10.0,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center Row contents horizontally,
                      crossAxisAlignment: CrossAxisAlignment.center, // Center Row contents vertically,
                      children: <Widget>[

                        const SizedBox(
                          width: 90,
                          height: 40,
                        ),

                        const SizedBox(width: 10.0,),

                        SizedBox(
                          width: 90,
                          height: 40,
                          child: RaisedButton(
                            splashColor: const Color.fromRGBO(231, 231, 231, 1.0),
                            highlightColor: const Color.fromRGBO(231, 231, 231, 1.0),
                            highlightElevation: 0,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            color: const Color.fromRGBO(231, 231, 231, 1.0),
                            child: Container(
                              child: Text(listNumber[9].toString(), style: const TextStyle(color: Color.fromRGBO(80, 80, 80, 1.0)),),
                            ),
                            onPressed: () {
                              valueChanged(value + listNumber[9].toString());
                            }, 
                          ),
                        ),

                        const SizedBox(width: 10.0,),

                        SizedBox(
                          width: 90,
                          height: 40,
                          child: IconButton(
                            icon: const Icon(Icons.cancel, color: Color.fromRGBO(0, 122, 209, 1),),
                            onPressed: () {
                              if (value.isNotEmpty) {
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