import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/extensions/string_extension.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/models/enums/vehicle_type.dart';
import 'package:taxiapp/ui/views/principal/principal_viewmodel.dart';
import 'package:taxiapp/ui/views/principal/widgets/vehicle_icon.dart';
import 'package:taxiapp/ui/widgets/buttons/action_button_custom.dart';

class SelectionVehicle extends ViewModelWidget<PrincipalViewModel> {
  const SelectionVehicle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, PrincipalViewModel model) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height - 25,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
          decoration:
              const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 2, offset: Offset(0, -2))]),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    VehicleIcon(
                      icon: 'assets/icons/moto.png',
                      size: 85,
                      isSelected: model.vehicleSelected == VehicleType.moto,
                      bottomOffset: -2,
                      borderColor: const Color(0xff1a9ab7),
                      onTap: () => model.updateVehicleSelected(VehicleType.moto),
                    ),
                    VehicleIcon(
                      icon: 'assets/icons/taxi.png',
                      size: 80,
                      width: 120,
                      bottomOffset: -10,
                      borderColor: const Color(0xfffea913),
                      onTap: () => model.updateVehicleSelected(VehicleType.taxi),
                      isSelected: model.vehicleSelected == VehicleType.taxi,
                    ),
                    VehicleIcon(
                      icon: 'assets/icons/mototaxi.png',
                      size: 98,
                      bottomOffset: -12,
                      borderColor: const Color(0xffd12a19),
                      onTap: () => model.updateVehicleSelected(VehicleType.mototaxi),
                      isSelected: model.vehicleSelected == VehicleType.mototaxi,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 10.0),
                child: ActionButtonCustom(action: () => model.confirmVehicleSelection(), label: Keys.continue_label.localize()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
