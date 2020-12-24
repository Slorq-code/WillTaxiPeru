part of 'custom_markers.dart';

class MarkerStartPainter extends CustomPainter {
  final int minutes;

  MarkerStartPainter(this.minutes);

  @override
  void paint(Canvas canvas, Size size) {
    final circleR = 20.0;
    final whiteCircle = 7.0;

    var paint = Paint()..color = Colors.orange;

    canvas.drawCircle(Offset(circleR, size.height - circleR), 20, paint);

    paint.color = Colors.white;

    canvas.drawCircle(Offset(circleR, size.height - circleR), whiteCircle, paint);

    final path = Path();

    path.moveTo(40, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(40, 100);

    canvas.drawShadow(path, Colors.black87, 10, false);

    final whiteBox = Rect.fromLTWH(40, 20, size.width - 55, 80);
    canvas.drawRect(whiteBox, paint);

    paint.color = Colors.orange;
    final box = const Rect.fromLTWH(40, 20, 70, 80);
    canvas.drawRect(box, paint);

    var textSpan = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w400), text: '$minutes');

    var textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr, textAlign: TextAlign.center)..layout(maxWidth: 70, minWidth: 70);

    textPainter.paint(canvas, const Offset(40, 35));

    textSpan = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400), text: Keys.minutes_short.localize());

    textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr, textAlign: TextAlign.center)..layout(maxWidth: 70, minWidth: 70);

    textPainter.paint(canvas, const Offset(40, 67));

    textSpan = TextSpan(style: const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400), text: Keys.my_location.localize());

    textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr, textAlign: TextAlign.center)
      ..layout(
        maxWidth: size.width - 130,
      );

    textPainter.paint(canvas, const Offset(150, 50));
  }

  @override
  bool shouldRepaint(MarkerStartPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(MarkerStartPainter oldDelegate) => false;
}
