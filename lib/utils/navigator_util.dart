import 'package:flutter/cupertino.dart';

class NavigatorUtil {

  static void showPage(BuildContext context, Widget widget) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) {
          return widget;
      }
    ));
  }

  static void hidePage(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

}