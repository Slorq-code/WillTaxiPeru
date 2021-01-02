import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class VehicleIcon extends HookWidget {
  const VehicleIcon({
    Key key,
    @required this.icon,
    this.onTap,
    @required this.isSelected,
    this.size = 100,
    this.width,
    this.bottomOffset = 0,
    this.borderColor,
  })  : assert(icon != null),
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
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
      initialValue: isSelected ? 1.2 : 1,
      lowerBound: 1,
      upperBound: 1.2,
    );

    useEffect(() {
      if (isSelected) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
      return null;
    }, [isSelected]);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: ScaleTransition(
        scale: animationController,
        child: Stack(
          overflow: Overflow.visible,
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: () => onTap != null ? onTap() : () {},
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: isSelected ? borderColor : Colors.transparent, width: 2.0),
                    color: const Color(0xfff0f0f0)),
                height: 90,
                width: 90,
              ),
            ),
            Positioned(bottom: bottomOffset, child: IgnorePointer(child: Image.asset(icon, width: width ?? size, height: size))),
          ],
        ),
      ),
    );
  }
}
