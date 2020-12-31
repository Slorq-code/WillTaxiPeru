import 'package:flutter/material.dart';

import 'package:taxiapp/ui/widgets/platform_widget.dart';

class PlatformBackButton extends PlatformWidget {
  PlatformBackButton({
    this.keyWidget,
    @required this.onPressed,
    this.isDark = false,
  }) : assert(onPressed != null);

  final Key keyWidget;
  final VoidCallback onPressed;
  final bool isDark;

  @override
  Widget buildCupertinoWidget(BuildContext context) => _IconButtonBuilder(key: keyWidget, onPressed: onPressed, icon: Icons.arrow_back_ios, isDark: isDark);

  @override
  Widget buildMaterialWidget(BuildContext context) => _IconButtonBuilder(key: keyWidget, onPressed: onPressed, icon: Icons.arrow_back, isDark: isDark);
}

class _IconButtonBuilder extends StatelessWidget {
  const _IconButtonBuilder({
    Key key,
    @required this.onPressed,
    @required this.icon,
    this.isDark = false,
  }) : super(key: key);

  final VoidCallback onPressed;
  final IconData icon;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Ink(
        height: 40,
        width: 40,
        padding: const EdgeInsets.all(0),
        decoration: ShapeDecoration(
          color: isDark ? Colors.black : Colors.transparent,
          shape: const CircleBorder(),
        ),
        child: IconButton(
          iconSize: 20,
          icon: Container(
            alignment: Alignment.centerRight,
            child: Icon(
              icon,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
