import 'package:flutter/material.dart';
import 'package:taxiapp/ui/widgets/platform_widget.dart';

class PlatformBackButton extends PlatformWidget {
  PlatformBackButton({@required this.onPressed}) : assert(onPressed != null);

  final VoidCallback onPressed;

  @override
  Widget buildCupertinoWidget(BuildContext context) => _IconButtonBuilder(onPressed: onPressed, icon: Icons.arrow_back_ios);

  @override
  Widget buildMaterialWidget(BuildContext context) => _IconButtonBuilder(onPressed: onPressed, icon: Icons.arrow_back);
}

class _IconButtonBuilder extends StatelessWidget {
  const _IconButtonBuilder({
    Key key,
    @required this.onPressed,
    @required this.icon,
  }) : super(key: key);

  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
    );
  }
}
