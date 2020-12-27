import 'package:flutter/material.dart';

class SpinLoadingIndicator extends StatelessWidget {
  const SpinLoadingIndicator({
    Key key,
    this.height = 45.0,
  }) : super(key: key);
  final double height;
  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/icons/spin_loading.gif', height: height, fit: BoxFit.contain);
  }
}
