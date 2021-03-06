import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/extensions/date_extension.dart';
import 'package:taxiapp/extensions/string_extension.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/ui/views/principal/principal_viewmodel.dart';
import 'package:taxiapp/ui/widgets/avatar_profile/avatar_profile.dart';
import 'package:taxiapp/ui/widgets/buttons/action_button_custom.dart';
import 'package:taxiapp/utils/spin_loading_indicator.dart';
import 'package:taxiapp/utils/utils.dart';

class DriverRideDetails extends ViewModelWidget<PrincipalViewModel> {
  const DriverRideDetails({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context, PrincipalViewModel model) {
    return Stack(
      children: [
        const _RideInformationSection(),
        const _FloatingMessage(),
        if (model.driverRequestFlow == DriverRequestFlow.inProgress)
          const _PanicButton(),
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
                            mainAxisAlignment: model.clientForRide != null
                                ? MainAxisAlignment.spaceAround
                                : MainAxisAlignment.center,
                            children: [
                              if (model.clientForRide != null)
                                AvatarProfile(
                                  heroTag: model.clientForRide.uid,
                                  name: model.clientForRide.name,
                                  image: model.clientForRide.image,
                                  enableBorder: true,
                                  nameBold: false,
                                  fontSize: 14,
                                  height: 84,
                                ),
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
                                'S/ ${model.rideRequest.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 70.0, vertical: 10.0),
                            child: model.driverRequestFlow ==
                                    DriverRequestFlow.none
                                ? ActionButtonCustom(
                                    action: () =>
                                        model.acceptRideRequest(context),
                                    label: Keys.continue_label.localize())
                                : model.driverRequestFlow ==
                                        DriverRequestFlow.accept
                                    ? Column(
                                        children: [
                                          ActionButtonCustom(
                                            action: () =>
                                                model.preDrivingToStartPoint(
                                                    context),
                                            label: Keys.arrival_at_the_starting
                                                .localize(),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          ActionButtonCustom(
                                              action: () => model
                                                  .cancelRideRequestByDriver(),
                                              label: Keys.cancel.localize(),
                                              color: Colors.black)
                                        ],
                                      )
                                    : model.driverRequestFlow ==
                                            DriverRequestFlow
                                                .preDrivingToStartPoint
                                        ? ActionButtonCustom(
                                            action: () =>
                                                model.preDrivingToStartPoint(
                                                    context),
                                            label: Keys.arrival_at_the_starting
                                                .localize(),
                                          )
                                        : model.driverRequestFlow ==
                                                DriverRequestFlow.onStartPoint
                                            ? ActionButtonCustom(
                                                action: () =>
                                                    model.startRidebyDriver(),
                                                label: Keys.start.localize(),
                                              )
                                            : model.driverRequestFlow ==
                                                    DriverRequestFlow.inProgress
                                                ? ActionButtonCustom(
                                                    action: () => model
                                                        .finishRideByDriver(),
                                                    label:
                                                        Keys.finish.localize())
                                                : Container(),
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
          const SizedBox(height: 120.0),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Expanded(flex: 1, child: SizedBox()),
                Expanded(
                  flex: 4,
                  child: model.driverRequestFlow ==
                              DriverRequestFlow.onStartPoint ||
                          model.driverRequestFlow == DriverRequestFlow.finished
                      ? Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: const Color(0xfff0f0f0)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 20.0),
                          child: Text(
                            model.driverRequestFlow ==
                                    DriverRequestFlow.finished
                                ? Keys.your_destination.localize()
                                : Keys.starting_point.localize(),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : const SizedBox(),
                ),
                Expanded(
                  flex: 1,
                  child: model.driverRequestFlow == DriverRequestFlow.none ||
                          model.driverRequestFlow == DriverRequestFlow.accept
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
                                (model.rideRequest != null
                                    ? ('${(model.rideRequest.secondsArrive ~/ 60).toString()}\'')
                                    : ''),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      : model.driverRequestFlow ==
                              DriverRequestFlow.onStartPoint
                          ? Container(
                              child: SvgPicture.asset('assets/icons/clock.svg',
                                  height: 28.0))
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
