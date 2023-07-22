import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/app/router.gr.dart';
import 'package:taxiapp/extensions/string_extension.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/ui/views/principal/principal_viewmodel.dart';
import 'package:taxiapp/ui/widgets/avatar_profile/avatar_profile.dart';
import 'package:taxiapp/ui/widgets/buttons/platform_back_button.dart';

class NewRouteDriver extends ViewModelWidget<PrincipalViewModel> {
  const NewRouteDriver({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context, PrincipalViewModel model) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: kToolbarHeight,
                  child: AppBar(
                    title: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 3.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xfff0f0f0)),
                        child: Text(Keys.new_destination.localize(),
                            style: const TextStyle(color: Colors.black))),
                    centerTitle: true,
                    leading: model.driverRequestFlow ==
                            DriverRequestFlow.inProgress
                        ? const SizedBox()
                        : PlatformBackButton(onPressed: () => model.onBack()),
                    backgroundColor: Colors.transparent,
                    iconTheme: const IconThemeData(color: Colors.black),
                    elevation: 0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: GestureDetector(
                    onTap: () =>
                        ExtendedNavigator.root.push(Routes.profileViewRoute),
                    child: AvatarProfile(
                      heroTag: model.user.uid,
                      name: model.user.name,
                      showName: false,
                      image: model.user.image,
                      height: 60.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
