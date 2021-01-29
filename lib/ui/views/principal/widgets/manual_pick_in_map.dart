import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/extensions/string_extension.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/ui/views/principal/principal_viewmodel.dart';
import 'package:taxiapp/ui/widgets/buttons/action_button_custom.dart';
import 'package:taxiapp/ui/widgets/buttons/platform_back_button.dart';

class ManualPickInMap extends ViewModelWidget<PrincipalViewModel> {
  const ManualPickInMap({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, PrincipalViewModel model) {
    var size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height,
      width: size.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: kToolbarHeight,
              child: AppBar(
                title: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 3.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xfff0f0f0)),
                    child: Text(Keys.new_destination.localize(), style: const TextStyle(color: Colors.black))),
                centerTitle: true,
                leading: PlatformBackButton(onPressed: () => model.onBack(), isDark: true),
                backgroundColor: Colors.transparent,
                iconTheme: const IconThemeData(color: Colors.black),
                elevation: 0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            height: 80,
            child: Stack(
              overflow: Overflow.visible,
              children: [
                Positioned(
                    right: -130,
                    top: -20,
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.black),
                        child: Text(Keys.locate_your_destination.localize(),
                            textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)))),
                SvgPicture.asset('assets/icons/move_in_map.svg', height: 30.0),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(bottom: 30.0),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
                  child: ActionButtonCustom(
                    action: () => model.confirmManualPick(model.centralLocation, context),
                    label: Keys.confirm_destination.localize(),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
