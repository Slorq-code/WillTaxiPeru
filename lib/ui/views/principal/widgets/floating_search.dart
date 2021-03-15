import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/app/router.gr.dart';
import 'package:taxiapp/extensions/string_extension.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/models/enums/user_type.dart';
import 'package:taxiapp/ui/views/principal/principal_viewmodel.dart';
import 'package:taxiapp/ui/widgets/avatar_profile/avatar_profile.dart';

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
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: model.user.userType == UserType.Client
                      ? const _ClientSearch()
                      : const _SwitchStatusDriver(),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: GestureDetector(
                      onTap: () =>
                          ExtendedNavigator.root.push(Routes.profileViewRoute),
                      child: AvatarProfile(
                        heroTag: model.user.uid,
                        height: 60,
                        image: model.user.image,
                        name: model.user.name,
                        showName: false,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwitchStatusDriver extends ViewModelWidget<PrincipalViewModel> {
  const _SwitchStatusDriver({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, PrincipalViewModel model) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(color: const Color(0xfff0f0f0), width: 3.0),
            color: Colors.white,
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Keys.activate.localize(),
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
              Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                      value: model.enableServiceDriver,
                      onChanged: model.updateServiceDriver)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ClientSearch extends ViewModelWidget<PrincipalViewModel> {
  const _ClientSearch({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, PrincipalViewModel model) {
    return Container(
      width: MediaQuery.of(context).size.width * .7,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        boxShadow: [
          const BoxShadow(
              blurRadius: 2,
              spreadRadius: 2,
              offset: Offset(1, 2),
              color: Colors.black26)
        ],
      ),
      child: GestureDetector(
        onTap: () =>
            model.updateCurrentSearchWidget(SearchWidget.searchFieldBar),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SvgPicture.asset('assets/icons/start_location.svg',
                      height: 18.0),
                  SvgPicture.asset('assets/icons/line_rail.svg', height: 12.0),
                  SvgPicture.asset('assets/icons/destination_marker.svg',
                      height: 18.0),
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
                            child: Text(
                                model.originSelected != null
                                    ? model.originSelected.address
                                    : Keys.origin.localize(),
                                overflow: TextOverflow.ellipsis),
                          ),
                          _OriginButton(
                              icon: 'assets/icons/locate_position.svg',
                              onTap: () => model.selectMyPosition(context)),
                          _OriginButton(
                              icon: 'assets/icons/move_in_map.svg',
                              onTap: () => model.manualSelectionInMap()),
                        ],
                      ),
                    ),
                    const Divider(
                        color: Color(0xffe5e5e5), height: 0, thickness: 2.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                                model.destinationSelected != null
                                    ? model.destinationSelected.address
                                    : Keys.destination.localize(),
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
