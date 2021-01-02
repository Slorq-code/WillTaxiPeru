import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/app/router.gr.dart';
import 'package:taxiapp/extensions/string_extension.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/ui/views/principal/principal_viewmodel.dart';
import 'package:taxiapp/ui/widgets/avatar_profile/avatar_profile.dart';
import 'package:taxiapp/utils/network_image.dart';

class FloatingSearch extends ViewModelWidget<PrincipalViewModel> {
  const FloatingSearch({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, PrincipalViewModel model) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: MediaQuery.of(context).size.width * .7,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  boxShadow: [const BoxShadow(blurRadius: 2, spreadRadius: 2, offset: Offset(1, 2), color: Colors.black26)],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SvgPicture.asset('assets/icons/start_location.svg', height: 18.0),
                          SvgPicture.asset('assets/icons/line_rail.svg', height: 12.0),
                          SvgPicture.asset('assets/icons/destination_marker.svg', height: 18.0),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(model.userLocation.descriptionAddress ?? '', overflow: TextOverflow.ellipsis),
                                  ),
                                  _OriginButton(icon: 'assets/icons/locate_position.svg', onTap: () {}),
                                  _OriginButton(icon: 'assets/icons/move_in_map.svg', onTap: () {}),
                                ],
                              ),
                            ),
                            const Divider(color: Color(0xffe5e5e5), height: 0, thickness: 2.0),
                            GestureDetector(
                              onTap: () => model.updateCurrentSearchWidget(1),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(model.destinationSelected != null ? model.destinationSelected.address : Keys.destination.localize(),
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                  onTap: () => ExtendedNavigator.root.push(Routes.profileViewRoute),
                  child: AvatarProfile(
                    heroTag: model.user.uid,
                    height: MediaQuery.of(context).size.width * .07,
                    image: model.user.image,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class _OriginButton extends StatelessWidget {
  const _OriginButton({
    Key key,
    @required this.icon,
    @required this.onTap,
  })  : assert(icon != null),
        assert(onTap != null),
        super(key: key);

  final VoidCallback onTap;
  final String icon;
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 25,
          child: SvgPicture.asset(icon, height: 25),
        ),
      ),
    );
  }
}
