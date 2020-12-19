part of 'custom_markers.dart';

class MarkerDestinationPainter extends CustomPainter {
  final String descripcion;
  final double metros;

  MarkerDestinationPainter(this.descripcion, this.metros);

  @override
  void paint(Canvas canvas, Size size) {
    final circuloNegroR = 20.0;
    final circuloBlancoR = 7.0;

    var paint = Paint()..color = Colors.black;

    // Dibujar circulo negro
    canvas.drawCircle(Offset(circuloNegroR, size.height - circuloNegroR), 20, paint);

    // Circulo Blanco
    paint.color = Colors.white;

    canvas.drawCircle(Offset(circuloNegroR, size.height - circuloNegroR), circuloBlancoR, paint);

    // Sombra
    final Path path = new Path();

    path.moveTo(0, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(0, 100);

    canvas.drawShadow(path, Colors.black87, 10, false);

    // Caja Blanca
    final cajaBlanca = Rect.fromLTWH(0, 20, size.width - 10, 80);
    canvas.drawRect(cajaBlanca, paint);

    // Caja Negra
    paint.color = Colors.black;
    final cajaNegra = const Rect.fromLTWH(0, 20, 70, 80);
    canvas.drawRect(cajaNegra, paint);

    // Dibujar textos
    var kilometros = metros / 1000;
    kilometros = (kilometros * 100).floor().toDouble();
    kilometros = kilometros / 100;

    var textSpan = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400), text: '$kilometros');

    var textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr, textAlign: TextAlign.center)..layout(maxWidth: 70, minWidth: 70);

    textPainter.paint(canvas, Offset(0, 35));

    // Minutos
    textSpan = const TextSpan(style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400), text: 'Km');

    textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr, textAlign: TextAlign.center)..layout(maxWidth: 70);

    textPainter.paint(canvas, Offset(20, 67));

    // Mi ubicación
    textSpan = TextSpan(style: const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400), text: descripcion);

    textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr, textAlign: TextAlign.left, maxLines: 2, ellipsis: '...')
      ..layout(
        maxWidth: size.width - 100,
      );

    textPainter.paint(canvas, const Offset(90, 35));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
