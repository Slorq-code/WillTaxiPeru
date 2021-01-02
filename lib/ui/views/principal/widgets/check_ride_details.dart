import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/models/enums/vehicle_type.dart';
import 'package:taxiapp/ui/views/principal/principal_viewmodel.dart';
import 'package:taxiapp/ui/views/principal/widgets/vehicle_icon.dart';
import 'package:taxiapp/ui/widgets/buttons/action_button_custom.dart';

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
            size: 60,
            isSelected: model.vehicleSelected == VehicleType.moto,
            bottomOffset: -2,
            borderColor: const Color(0xff1a9ab7),
            onTap: () => model.updateVehicleSelected(VehicleType.moto),
          ),
          const Text('Moto'), //TODO: transale
        ];
        break;
      case VehicleType.taxi:
        vehicle = [
          VehicleIcon(
            icon: 'assets/icons/taxi.png',
            size: 60,
            width: 80,
            bottomOffset: -5,
            borderColor: const Color(0xfffea913),
            onTap: () => model.updateVehicleSelected(VehicleType.taxi),
            isSelected: model.vehicleSelected == VehicleType.taxi,
          ),
          const Text('Taxi'), //TODO: translate
        ];
        break;
      case VehicleType.mototaxi:
        vehicle = [
          VehicleIcon(
            icon: 'assets/icons/mototaxi.png',
            size: 68,
            bottomOffset: -8,
            borderColor: const Color(0xffd12a19),
            onTap: () => model.updateVehicleSelected(VehicleType.mototaxi),
            isSelected: model.vehicleSelected == VehicleType.mototaxi,
          ),
          const Text('Motoaxi'), //TODO: translate
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
          padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
          decoration:
              const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 2, offset: Offset(0, -2))]),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(mainAxisSize: MainAxisSize.min, children: vehicle),
              const SizedBox(height: 20.0),
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
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
                        const Padding(
                          padding: EdgeInsets.only(bottom: 2.0, left: 8),
                          child: Text('12:29', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // TODO: update with  calculated time
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 10.0),
                child: ActionButtonCustom(action: () => model.updateCurrentRideWidget(2), label: 'Continuar'), //TODO: translate
              ),
            ],
          ),
        ),
      ),
    );
  }
}
