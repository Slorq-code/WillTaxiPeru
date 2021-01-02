import 'package:flutter/material.dart';

class VehicleIcon extends StatelessWidget {
  const VehicleIcon({
    Key key,
    @required this.icon,
    @required this.onTap,
    @required this.isSelected,
    this.size = 80,
    this.width,
    this.bottomOffset = 0,
    this.borderColor,
  })  : assert(icon != null),
        assert(onTap != null),
        assert(isSelected != null),
        super(key: key);

  final String icon;
  final VoidCallback onTap;
  final bool isSelected;
  final double size;
  final double width;
  final double bottomOffset;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle, border: Border.all(color: isSelected ? borderColor : Colors.transparent, width: 2.0), color: const Color(0xfff0f0f0)),
            height: 65,
            width: 65,
          ),
        ),
        Positioned(bottom: bottomOffset, child: IgnorePointer(child: Image.asset(icon, width: width ?? size, height: size))),
      ],
    );
  }
}
