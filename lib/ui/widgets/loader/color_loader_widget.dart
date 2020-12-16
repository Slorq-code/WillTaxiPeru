import 'package:flutter/material.dart';
import 'dart:async';

class ColorLoaderWidget extends StatefulWidget {
  final List<Color> colors;
  final Duration duration;
  final Color colorBackground;

  ColorLoaderWidget({this.colors, this.duration, this.colorBackground});

  @override
  _ColorLoaderState createState() =>
      _ColorLoaderState(this.colors, this.duration, this.colorBackground);
}

class _ColorLoaderState extends State<ColorLoaderWidget>
    with SingleTickerProviderStateMixin {
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

    if (colors == null) {
      colors = [Colors.blue, Colors.amber, Colors.pink, Colors.red, Colors.green,];
    }
    if (duration == null) {
      duration = new Duration(milliseconds: 1200);
    }
    if (colorBackground == null) {
      colorBackground = Color.fromRGBO(0, 0, 0, 0.3);
    }

    controller = new AnimationController(
      vsync: this,
      duration: duration,
    );

    for (int i = 0; i < colors.length - 1; i++) {
      tweenAnimations.add(ColorTween(begin: colors[i], end: colors[i + 1]));
    }

    tweenAnimations
        .add(ColorTween(begin: colors[colors.length - 1], end: colors[0]));

    for (int i = 0; i < colors.length; i++) {
      Animation<Color> animation = tweenAnimations[i].animate(CurvedAnimation(
          parent: controller,
          curve: Interval((1 / colors.length) * (i + 1) - 0.05,
              (1 / colors.length) * (i + 1),
              curve: Curves.linear)));

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