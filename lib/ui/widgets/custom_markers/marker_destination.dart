part of 'custom_markers.dart';

class MarkerDestinationPainter extends CustomPainter {
  final String description;
  final double meters;

  MarkerDestinationPainter(this.description, this.meters);

  @override
  void paint(Canvas canvas, Size size) {
    final circleR = 20.0;
    final whiteCircleR = 7.0;

    var paint = Paint()..color = Colors.orange;

    canvas.drawCircle(Offset(circleR, size.height - circleR), 20, paint);

    paint.color = Colors.white;

    canvas.drawCircle(Offset(circleR, size.height - circleR), whiteCircleR, paint);

    final path = Path();

    path.moveTo(0, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(0, 100);

    canvas.drawShadow(path, Colors.black87, 10, false);

    final whiteBox = Rect.fromLTWH(0, 20, size.width - 10, 80);
    canvas.drawRect(whiteBox, paint);

    paint.color = Colors.orange;
    final box = const Rect.fromLTWH(0, 20, 70, 80);
    canvas.drawRect(box, paint);

    var kilometers = meters / 1000;
    kilometers = (kilometers * 100).floor().toDouble();
    kilometers = kilometers / 100;

    var textSpan = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400), text: '$kilometers');

    var textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr, textAlign: TextAlign.center)..layout(maxWidth: 70, minWidth: 70);

    textPainter.paint(canvas, const Offset(0, 35));

    textSpan = const TextSpan(style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400), text: 'Km');

    textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr, textAlign: TextAlign.center)..layout(maxWidth: 70);

    textPainter.paint(canvas, const Offset(20, 67));

    textSpan = TextSpan(style: const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400), text: description);

    textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr, textAlign: TextAlign.left, maxLines: 2, ellipsis: '...')
      ..layout(
        maxWidth: size.width - 100,
      );

    textPainter.paint(canvas, const Offset(90, 35));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
