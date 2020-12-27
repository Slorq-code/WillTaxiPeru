import 'package:flutter/material.dart';

const double _kRadius = 10;
const double _kBorderWidth = 3;

class BoxBorderContainer extends CustomPainter {
  BoxBorderContainer();

  @override
  void paint(Canvas canvas, Size size) {
    final rrectBorder = RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(_kRadius));
    final rrectShadow = RRect.fromRectAndRadius(const Offset(0, 1) & size, const Radius.circular(_kRadius));

    final shadowPaint = Paint()
      ..strokeWidth = _kBorderWidth
      ..color = Colors.black26
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    final borderPaint = Paint()
      ..strokeWidth = _kBorderWidth
      ..color = const Color(0xffEFEFEF)
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(rrectShadow, shadowPaint);
    canvas.drawRRect(rrectBorder, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
