import 'package:flutter/material.dart';

import 'package:taxiapp/theme/pallete_color.dart';

class ActionButtonCustom extends StatelessWidget {
  const ActionButtonCustom({
    Key key,
    @required this.action,
    @required this.label,
    this.fontSize = 16,
    this.color = PalleteColor.actionButtonColor,
  })  : assert(action != null),
        assert(label != null),
        super(key: key);

  final VoidCallback action;
  final String label;
  final double fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.06,
      child: RaisedButton(
        onPressed: action,
        color: color,
        elevation: 2,
        highlightElevation: 4,
        child: Container(
          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
          alignment: Alignment.center,
          child: Text(label, style: TextStyle(fontSize: fontSize, color: Colors.white, fontWeight: FontWeight.w500)),
        ),
        padding: const EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }
}
