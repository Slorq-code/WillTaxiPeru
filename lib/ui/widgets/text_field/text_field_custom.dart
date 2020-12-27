import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:taxiapp/theme/pallete_color.dart';

typedef TextCallback = Function(String text);
typedef ValidatorCallBack = Function(String text);

class TextFieldCustom extends StatefulWidget {
  const TextFieldCustom({
    Key key,
    this.icon,
    @required this.controller,
    this.validateText,
    this.focus,
    this.nextFocus,
    this.isFinal = false,
    this.isPassword = false,
    @required this.onChanged,
    this.onValidation,
    @required this.labelText,
    this.keyboardType = TextInputType.text,
    this.inputFormatters = const [],
  }) : super(key: key);
  final String icon;
  final TextEditingController controller;
  final String validateText;
  final FocusNode focus;
  final FocusNode nextFocus;
  final bool isFinal;
  final bool isPassword;
  final TextCallback onChanged;
  final ValidatorCallBack onValidation;
  final String labelText;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;

  @override
  _TextFieldCustomState createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  bool _obscurePin = true;

  @override
  Widget build(BuildContext context) {
    var _iconObscurePin = _obscurePin ? Icons.visibility_off : Icons.visibility;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (widget.icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              width: 25,
              alignment: Alignment.centerLeft,
              child: SvgPicture.asset(widget.icon, height: 22.0),
            ),
          ),
        const SizedBox(height: 5.0),
        Expanded(
          child: TextFormField(
            controller: widget.controller,
            autofocus: false,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: widget.isFinal ? TextInputAction.done : TextInputAction.next,
            focusNode: widget.focus,
            inputFormatters: widget.inputFormatters,
            obscureText: widget.isPassword ? _obscurePin : false,
            keyboardType: widget.keyboardType,
            onChanged: widget.onChanged,
            onFieldSubmitted: (v) {
              if (widget.nextFocus != null) FocusScope.of(context).requestFocus(widget.nextFocus);
            },
            decoration: InputDecoration(
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xffF0F0F0), width: 3.0),
                borderRadius: BorderRadius.circular(30),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xffF0F0F0), width: 3.0),
                borderRadius: BorderRadius.circular(30),
              ),
              errorText: widget.validateText,
              errorStyle: const TextStyle(color: Colors.redAccent),
              labelText: widget.labelText,
              isDense: true,
              suffixIconConstraints: const BoxConstraints(minHeight: 40),
              suffixIcon: widget.isPassword
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscurePin = !_obscurePin;
                        });
                      },
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(_iconObscurePin, color: Colors.grey, size: 20),
                      ))
                  : const SizedBox(),
            ),
            validator: widget.onValidation,
          ),
        ),
      ],
    );
  }
}
