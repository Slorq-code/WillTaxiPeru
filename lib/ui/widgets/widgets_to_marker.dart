part of 'helpers.dart';

Future<BitmapDescriptor> getMarkerInicioIcon(int segundos) async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  final size = const ui.Size(350, 150);

  final minutos = (segundos / 60).floor();

  final markerInicio = MarkerStartPainter(minutos);
  markerInicio.paint(canvas, size);

  final picture = recorder.endRecording();
  final image = await picture.toImage(size.width.toInt(), size.height.toInt());
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
}

Future<BitmapDescriptor> getMarkerDestinoIcon(
    String descripcion, double metros) async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  final size = const ui.Size(350, 150);

  final markerDestino = MarkerDestinationPainter(descripcion, metros);
  markerDestino.paint(canvas, size);

  final picture = recorder.endRecording();
  final image = await picture.toImage(size.width.toInt(), size.height.toInt());
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
}

Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
    BuildContext context, String assetName, double size) async {
  // Read SVG file as String
  final svgString = await DefaultAssetBundle.of(context).loadString(assetName);
  // Create DrawableRoot from SVG String
  final svgDrawableRoot = await svg.fromSvgString(svgString, null);

  // toPicture() and toImage() don't seem to be pixel ratio aware, so we calculate the actual sizes here
  final queryData = MediaQuery.of(context);
  final devicePixelRatio = queryData.devicePixelRatio;
  final width =
      size * devicePixelRatio; // where 32 is your SVG's original width
  final height = size * devicePixelRatio; // same thing

  // Convert to ui.Picture
  final picture = svgDrawableRoot.toPicture(size: Size(width, height));

  // Convert to ui.Image. toImage() takes width and height as parameters
  // you need to find the best size to suit your needs and take into account the
  // screen DPI
  final image = await picture.toImage(width.toInt(), height.toInt());
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
}
