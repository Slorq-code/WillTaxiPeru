import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:taxiapp/utils/network_image.dart';
import 'package:taxiapp/utils/utils.dart';

class AvatarProfile extends StatelessWidget {
  const AvatarProfile({
    Key key,
    @required this.heroTag,
    this.image,
    @required this.name,
    this.height = 100,
    this.enableBorder = false,
    this.nameBold = true,
    this.fontSize = 12.0,
    this.showName = true,
    this.updatePicture,
  })  : assert(name != null),
        super(key: key);
  final String heroTag;
  final String image;
  final String name;
  final double height;
  final bool enableBorder;
  final bool nameBold;
  final double fontSize;
  final bool showName;

  final VoidCallback updatePicture;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: heroTag,
          flightShuttleBuilder: _flightShuttleBuilder,
          child: Container(
            width: height,
            height: height,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              border: enableBorder ? Border.all(color: Colors.black, width: 2.0) : null,
            ),
            child: ClipOval(
              child: Stack(
                children: [
                  image != null && image.isNotEmpty
                      ? PNetworkImage(
                          image,
                          height: height,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.red,
                          height: height,
                          width: height,
                          alignment: Alignment.center,
                          child: Text(Utils.getNameInitials(name), style: const TextStyle(fontSize: 40.0, color: Colors.white)),
                        ),
                  if (updatePicture != null)
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: height * .25,
                        width: height,
                        color: Colors.black,
                        child: SvgPicture.asset('assets/icons/camera.svg'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (showName)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              style: TextStyle(fontSize: fontSize, fontWeight: nameBold ? FontWeight.w500 : FontWeight.normal),
            ),
          ),
      ],
    );
  }

  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }
}
