import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget child;

  SplashScreen({@required this.child}) : assert(child != null);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3),
        () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => widget.child), (Route<dynamic> route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff0B203A),
        body: Center(
          child: Image.asset(
            'assets/logo/splash.gif',
            width: 400.0,
          ),
        ));
  }
}
