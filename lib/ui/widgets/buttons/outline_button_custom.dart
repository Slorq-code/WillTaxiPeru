import 'package:flutter/material.dart';

class OutlineButtonCustom extends StatelessWidget {
  final VoidCallback action;
  final String label;

  OutlineButtonCustom({Key key, @required this.action, @required this.label}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.07,
      child: OutlineButton(
        onPressed: action,
        borderSide: const BorderSide(color: Color(0xff4FC980), width: 2.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
