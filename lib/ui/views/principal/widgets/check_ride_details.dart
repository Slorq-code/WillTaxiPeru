import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/extensions/date_extension.dart';
import 'package:taxiapp/extensions/string_extension.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/models/enums/ride_status.dart';
import 'package:taxiapp/models/enums/vehicle_type.dart';
import 'package:taxiapp/ui/views/principal/principal_viewmodel.dart';
import 'package:taxiapp/ui/views/principal/widgets/vehicle_icon.dart';
import 'package:taxiapp/ui/widgets/avatar_profile/avatar_profile.dart';
import 'package:taxiapp/ui/widgets/buttons/action_button_custom.dart';
import 'package:taxiapp/utils/spin_loading_indicator.dart';
import 'package:taxiapp/utils/utils.dart';

class CheckRideDetails extends ViewModelWidget<PrincipalViewModel> {
  const CheckRideDetails({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context, PrincipalViewModel model) {
    return Stack(
      children: [
        const _RideInformationSection(),
        if (model.rideStatus == RideStatus.waitingDriver ||
            model.rideStatus == RideStatus.inProgress)
          const _FloatingMessage(),
        if (model.rideStatus == RideStatus.inProgress) const _PanicButton(),
      ],
    );
  }
}

class _PanicButton extends ViewModelWidget<PrincipalViewModel> {
  const _PanicButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, PrincipalViewModel model) {
    var size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.height - 25,
      child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              heroTag: null,
              elevation: 10,
              hoverElevation: 10,
              highlightElevation: 10,
              isExtended: true,
              onPressed: () {
                var _locationText = Utils.getLocationTextGMaps(
                    model.userLocation.location.latitude.toString(),
                    model.userLocation.location.longitude.toString());
                Utils.shareText('Will', _locationText);
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: Image.asset('assets/icons/panic_button.png', height: 65.0),
            ),
          )),
    );
  }
}

class _RideInformationSection extends ViewModelWidget<PrincipalViewModel> {
  const _RideInformationSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, PrincipalViewModel model) {
    List<Widget> vehicle;
    switch (model.vehicleSelected) {
      case VehicleType.moto:
        vehicle = [
          VehicleIcon(
            icon: 'assets/icons/moto.png',
            size: 70,
            bottomOffset: -2,
            borderColor: const Color(0xff1a9ab7),
            isSelected: model.vehicleSelected == VehicleType.moto,
          ),
          Text(Keys.moto.localize()),
        ];
        break;
      case VehicleType.taxi:
        vehicle = [
          VehicleIcon(
            icon: 'assets/icons/taxi.png',
            size: 70,
            width: 100,
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
            size: 78,
            bottomOffset: -12,
            borderColor: const Color(0xffd12a19),
            isSelected: model.vehicleSelected == VehicleType.mototaxi,
          ),
          Text(Keys.mototaxi.localize()),
        ];
        break;
      default:
    }
    var size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.height - 25,
      child: model.destinationSelected != null
          ? Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding:
                    const EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                decoration:
                    const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, -2))
                ]),
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity:
                          model.busy(model.ridePrice) || model.isSearchingDriver
                              ? 0
                              : 1,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: model.driverForRide != null
                                ? MainAxisAlignment.spaceAround
                                : MainAxisAlignment.center,
                            children: [
                              if (model.driverForRide != null)
                                AvatarProfile(
                                  heroTag: model.driverForRide.uid,
                                  name: model.driverForRide.name,
                                  image: model.driverForRide.image,
                                  enableBorder: true,
                                  nameBold: false,
                                  fontSize: 14,
                                  height: 84,
                                ),
                              Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: vehicle),
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
                                    if (model.destinationSelected.name !=
                                            null &&
                                        model.destinationSelected.name
                                            .isNotEmpty)
                                      Text(
                                        model.destinationSelected.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 16),
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
                                    Flexible(
                                        child: SvgPicture.asset(
                                            'assets/icons/clock.svg',
                                            height: 30.0)),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 2.0, left: 8),
                                      child: Text(
                                        model.destinationArrive.formatHHmm(),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
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
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 5,
                                          spreadRadius: 0),
                                    ]),
                                child: SvgPicture.asset('assets/icons/coin.svg',
                                    height: 40.0),
                              ),
                              const SizedBox(width: 15.0),
                              Text(
                                'S/ ${model.ridePrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          if (model.rideStatus == RideStatus.none ||
                              model.rideStatus == RideStatus.waitingDriver)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 70.0, vertical: 10.0),
                              child:
                                  model.rideStatus != RideStatus.waitingDriver
                                      ? ActionButtonCustom(
                                          action: () => model.confirmRide(context),
                                          label: Keys.continue_label.localize())
                                      : ActionButtonCustom(
                                          color: Colors.black,
                                          action: () => model.cancelRide(),
                                          label: Keys.cancel.localize()),
                            ),
                        ],
                      ),
                    ),
                    if (model.busy(model.ridePrice) || model.isSearchingDriver)
                      const SpinLoadingIndicator(),
                  ],
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}

class _FloatingMessage extends ViewModelWidget<PrincipalViewModel> {
  const _FloatingMessage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, PrincipalViewModel model) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height - 25,
      child: Column(
        children: [
          SizedBox(
              height:
                  model.rideStatus == RideStatus.waitingDriver ? 150.0 : 80.0),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Expanded(flex: 1, child: SizedBox()),
                Expanded(
                  flex: 4,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: const Color(0xfff0f0f0)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 20.0),
                    child: Text(
                      model.rideStatus == RideStatus.waitingDriver
                          ? (model.driverArrived
                              ? Keys.driver_has_arrived.localize()
                              : Keys.comming_ride_message.localize())
                          : Keys.enjoy_your_trip.localize(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: model.rideStatus == RideStatus.waitingDriver
                      ? Container(
                          padding: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black),
                              color: Colors.white),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Text(
                                '${(model.rideRequest.secondsArrive ~/ 60).toString()}\'',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
