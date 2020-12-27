// import 'dart:io';

import 'package:flutter/material.dart';

abstract class PlatformWidget extends StatelessWidget {
  Widget buildCupertinoWidget(BuildContext context);

  Widget buildMaterialWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    // if (Platform.isAndroid) {
    // return buildMaterialWidget(context);
    // }
    return buildCupertinoWidget(context);
  }
}
