import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/extensions/date_extension.dart';
import 'package:taxiapp/extensions/string_extension.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/models/enums/vehicle_type.dart';
import 'package:taxiapp/ui/views/principal/principal_viewmodel.dart';
import 'package:taxiapp/ui/views/principal/widgets/vehicle_icon.dart';
import 'package:taxiapp/ui/widgets/avatar_profile/avatar_profile.dart';
import 'package:taxiapp/ui/widgets/buttons/action_button_custom.dart';
import 'package:taxiapp/utils/spin_loading_indicator.dart';

class CheckRideDetails extends ViewModelWidget<PrincipalViewModel> {
  const CheckRideDetails({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context, PrincipalViewModel model) {
    var size = MediaQuery.of(context).size;
    List<Widget> vehicle;
    switch (model.vehicleSelected) {
      case VehicleType.moto:
        vehicle = [
          VehicleIcon(
            icon: 'assets/icons/moto.png',
            size: 85,
            isSelected: model.vehicleSelected == VehicleType.moto,
            bottomOffset: -2,
            borderColor: const Color(0xff1a9ab7),
          ),
          Text(Keys.moto.localize()),
        ];
        break;
      case VehicleType.taxi:
        vehicle = [
          VehicleIcon(
            icon: 'assets/icons/taxi.png',
            size: 80,
            width: 120,
            bottomOffset: -10,
            borderColor: const Color(0xfffea913),
            isSelected: model.vehicleSelected == VehicleType.taxi,
          ),
          Text(Keys.taxi.localize()),
        ];
        break;
      case VehicleType.mototaxi:
        vehicle = [
          VehicleIcon(
            icon: 'assets/icons/mototaxi.png',
            size: 98,
            bottomOffset: -12,
            borderColor: const Color(0xffd12a19),
            isSelected: model.vehicleSelected == VehicleType.mototaxi,
          ),
          Text(Keys.mototaxi.localize()),
        ];
        break;
      default:
    }

    return SizedBox(
      width: size.width,
      height: size.height - 25,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
          decoration:
              const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 2, offset: Offset(0, -2))]),
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: model.busy(model.ridePrice) || model.isSearchingDriver ? 0 : 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: model.driverForRide != null ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
                      children: [
                        if (model.driverForRide != null)
                          AvatarProfile(
                            heroTag: model.driverForRide.uid,
                            name: model.driverForRide.name,
                            image: model.driverForRide.image,
                            enableBorder: true,
                            nameBold: false,
                            fontSize: 14,
                          ),
                        Column(mainAxisSize: MainAxisSize.min, children: vehicle),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (model.destinationSelected.name != null && model.destinationSelected.name.isNotEmpty)
                                Text(
                                  model.destinationSelected.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
                                ),
                              Text(
                                model.destinationSelected.address,
                                style: const TextStyle(fontSize: 12.0),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Flexible(child: SvgPicture.asset('assets/icons/clock.svg', height: 30.0)),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2.0, left: 8),
                                child: Text(
                                  model.destinationArrive.formatHHmm(),
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 5, spreadRadius: 0),
                          ]),
                          child: SvgPicture.asset('assets/icons/coin.svg', height: 40.0),
                        ),
                        const SizedBox(width: 15.0),
                        Text(
                          'S/ ${model.ridePrice.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 10.0),
                      child: !model.rideInProgress
                          ? ActionButtonCustom(action: () => model.confirmRide(), label: Keys.continue_label.localize())
                          : ActionButtonCustom(color: Colors.black, action: () => model.cancelRide(), label: Keys.cancel.localize()),
                    ),
                  ],
                ),
              ),
              if (model.busy(model.ridePrice) || model.isSearchingDriver) const SpinLoadingIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
