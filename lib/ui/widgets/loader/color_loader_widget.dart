import 'package:flutter/material.dart';
import 'dart:async';

class ColorLoaderWidget extends StatefulWidget {
  final List<Color> colors;
  final Duration duration;
  final Color colorBackground;

  ColorLoaderWidget({this.colors, this.duration, this.colorBackground});

  @override
  _ColorLoaderState createState() => _ColorLoaderState(colors, duration, colorBackground);
}

class _ColorLoaderState extends State<ColorLoaderWidget> with SingleTickerProviderStateMixin {
  List<Color> colors;
  Duration duration;
  Color colorBackground;
  Timer timer;

  _ColorLoaderState(this.colors, this.duration, this.colorBackground);

  //noSuchMethod(Invocation i) => super.noSuchMethod(i);

  List<ColorTween> tweenAnimations = [];
  int tweenIndex = 0;

  AnimationController controller;
  List<Animation<Color>> colorAnimations = [];

  @override
  void initState() {
    super.initState();

    colors ??= [Colors.blue, Colors.amber, Colors.pink, Colors.red, Colors.green];
    duration ??= const Duration(milliseconds: 1200);
    colorBackground ??= const Color.fromRGBO(0, 0, 0, 0.3);

    controller = AnimationController(
      vsync: this,
      duration: duration,
    );

    for (var i = 0; i < colors.length - 1; i++) {
      tweenAnimations.add(ColorTween(begin: colors[i], end: colors[i + 1]));
    }

    tweenAnimations.add(ColorTween(begin: colors[colors.length - 1], end: colors[0]));

    for (var i = 0; i < colors.length; i++) {
      var animation = tweenAnimations[i].animate(CurvedAnimation(
          parent: controller,
          curve: Interval(
            (1 / colors.length) * (i + 1) - 0.05,
            (1 / colors.length) * (i + 1),
            curve: Curves.linear,
          )));

      colorAnimations.add(animation);
    }

    print(colorAnimations.length);

    tweenIndex = 0;

    timer = Timer.periodic(duration, (Timer t) {
      setState(() {
        tweenIndex = (tweenIndex + 1) % colors.length;
      });
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorBackground,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 5.0,
          valueColor: colorAnimations[tweenIndex],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    controller.dispose();
    super.dispose();
  }
}
