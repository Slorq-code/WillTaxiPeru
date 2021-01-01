import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:morpheus/morpheus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

import 'package:taxiapp/app/router.gr.dart';
import 'package:taxiapp/extensions/string_extension.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/models/enums/vehicle_type.dart';
import 'package:taxiapp/models/place.dart';
import 'package:taxiapp/ui/views/principal/principal_viewmodel.dart';
import 'package:taxiapp/ui/widgets/buttons/action_button_custom.dart';
import 'package:taxiapp/ui/widgets/buttons/platform_back_button.dart';
import 'package:taxiapp/utils/network_image.dart';

class PrincipalView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PrincipalViewModel>.reactive(
      viewModelBuilder: () => PrincipalViewModel(),
      onModelReady: (model) => model.initialize(),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: model.state == PrincipalState.loading
                ? const Center(child: CircularProgressIndicator())
                : model.state == PrincipalState.accessGPSEnable
                    ? const _HomeMap()
                    : const _ForceEnableGPS()),
      ),
    );
  }
}

class _HomeMap extends ViewModelWidget<PrincipalViewModel> {
  const _HomeMap({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, PrincipalViewModel model) {
    return model.userLocation.existLocation
        ? Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(target: model.userLocation.location, zoom: 15),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                onMapCreated: model.initMapa,
                polylines: model.polylines.values.toSet(),
                markers: model.markers.values.toSet(),
                onCameraMove: (cameraPosition) {
                  model.updateCurrentLocation(cameraPosition.target);
                },
              ),
              const Positioned(
                top: 0,
                child: _Search(),
              ),
            ],
          )
        : Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: Image.asset(
              'assets/icons/loading_location.gif',
              height: MediaQuery.of(context).size.height * .5,
              fit: BoxFit.fitHeight,
            ),
          );
  }
}

class _Search extends ViewModelWidget<PrincipalViewModel> {
  const _Search({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, PrincipalViewModel model) {
    return MorpheusTabView(child: model.currentSearchWidget);
  }
}

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
                child: Hero(
                  tag: model.user.uid,
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: MediaQuery.of(context).size.width * .07,
                    child: ClipOval(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width * .14,
                        width: MediaQuery.of(context).size.width * .14,
                        child: PNetworkImage(
                          model.user.image.isEmpty ? 'https://cdn.onlinewebfonts.com/svg/img_568657.png' : model.user.image,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchFieldBar extends ViewModelWidget<PrincipalViewModel> {
  const SearchFieldBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, PrincipalViewModel model) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height - 25,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: .4)),
              boxShadow: [BoxShadow(blurRadius: 7, color: Colors.black45, spreadRadius: 4, offset: Offset(-4, -4))],
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  title: const Text('Nuevo destino', style: TextStyle(color: Colors.black)), // TODO: translate
                  centerTitle: true,
                  leading: PlatformBackButton(onPressed: () => model.onBack()),
                  backgroundColor: Colors.transparent,
                  iconTheme: const IconThemeData(color: Colors.black),
                  elevation: 0,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10.0, right: 30.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset('assets/icons/start_location.svg', height: 18.0),
                            SvgPicture.asset('assets/icons/line_rail.svg', height: 18.0),
                            SvgPicture.asset('assets/icons/destination_marker.svg', height: 18.0),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const _OriginLocationField(),
                            const Divider(color: Color(0xffe5e5e5), height: 2, thickness: 2.0),
                            const _DestinationLocationField(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (model.destinationSelected == null)
                  WillPopScope(
                    onWillPop: () => Future.value(model.onBack()),
                    child: Container(
                      height: MediaQuery.of(context).size.height * .5,
                      width: double.infinity,
                      color: Colors.white,
                      child: ListView(
                        children: [
                          ...model.placesFound.map(
                            (place) => _SugerationPlace(
                              place: place,
                              onTap: () => model.makeRoute(place, context),
                            ),
                          ),
                          const _PickInMapOption(),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
          if (model.destinationSelected != null) const _SelectVehicle()
        ],
      ),
    );
  }
}

class _SelectVehicle extends ViewModelWidget<PrincipalViewModel> {
  const _SelectVehicle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, PrincipalViewModel model) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: WillPopScope(
        onWillPop: () async {
          print('aca');
          return false;
        },
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
                    _VehicleIcon(
                      icon: 'assets/icons/moto.png',
                      size: 60,
                      isSelected: model.vehicleSelected == VehicleType.moto,
                      bottomOffset: -2,
                      borderColor: const Color(0xff1a9ab7),
                      onTap: () => model.updateVehicleSelected(VehicleType.moto),
                    ),
                    _VehicleIcon(
                      icon: 'assets/icons/taxi.png',
                      size: 60,
                      width: 80,
                      bottomOffset: -5,
                      borderColor: const Color(0xfffea913),
                      onTap: () => model.updateVehicleSelected(VehicleType.taxi),
                      isSelected: model.vehicleSelected == VehicleType.taxi,
                    ),
                    _VehicleIcon(
                      icon: 'assets/icons/mototaxi.png',
                      size: 68,
                      bottomOffset: -8,
                      borderColor: const Color(0xffd12a19),
                      onTap: () => model.updateVehicleSelected(VehicleType.mototaxi),
                      isSelected: model.vehicleSelected == VehicleType.mototaxi,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 10.0),
                child: ActionButtonCustom(action: () {}, label: 'Continuar'), //TODO: translate
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VehicleIcon extends StatelessWidget {
  const _VehicleIcon({
    Key key,
    @required this.icon,
    @required this.onTap,
    @required this.isSelected,
    this.size = 80,
    this.width,
    this.bottomOffset = 0,
    this.borderColor,
  })  : assert(icon != null),
        assert(onTap != null),
        assert(isSelected != null),
        super(key: key);

  final String icon;
  final VoidCallback onTap;
  final bool isSelected;
  final double size;
  final double width;
  final double bottomOffset;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle, border: Border.all(color: isSelected ? borderColor : Colors.transparent, width: 2.0), color: const Color(0xfff0f0f0)),
            height: 65,
            width: 65,
          ),
        ),
        Positioned(bottom: bottomOffset, child: IgnorePointer(child: Image.asset(icon, width: width ?? size, height: size))),
      ],
    );
  }
}

class _SugerationPlace extends StatelessWidget {
  const _SugerationPlace({
    Key key,
    @required this.place,
    @required this.onTap,
  })  : assert(place != null),
        assert(onTap != null),
        super(key: key);
  final Place place;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => onTap(),
        child: Container(
          width: double.infinity,
          height: 50,
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.transparent, width: 0),
              bottom: BorderSide(color: Colors.grey, width: .3),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 30.0,
                child: SvgPicture.asset('assets/icons/clock.svg', height: 25.0),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(child: Text(place.name)),
                      Expanded(child: Text(place.address, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PickInMapOption extends ViewModelWidget<PrincipalViewModel> {
  const _PickInMapOption({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, PrincipalViewModel model) {
    return GestureDetector(
      onTap: () => model.updateCurrentSearchWidget(2),
      child: Container(
        height: 50,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.transparent, width: 0),
            bottom: BorderSide(color: Colors.grey, width: .3),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 30.0,
                child: SvgPicture.asset('assets/icons/move_in_map.svg', height: 25.0),
              ),
              const SizedBox(width: 10.0),
              const Text('Fijar ubicación en el mapa', style: TextStyle(fontWeight: FontWeight.w500)), // TODO: translate
            ],
          ),
        ),
      ),
    );
  }
}

class _ForceEnableGPS extends ViewModelWidget<PrincipalViewModel> {
  const _ForceEnableGPS({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, PrincipalViewModel model) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(Keys.you_need_to_authorize_the_gps_to_use_the_app.localize()),
          MaterialButton(
            child: Text(Keys.request_access.localize(), style: const TextStyle(color: Colors.white)),
            color: Colors.black,
            shape: const StadiumBorder(),
            elevation: 0,
            splashColor: Colors.transparent,
            onPressed: () async {
              final status = await Permission.location.request();
              await model.accessGPS(status);
            },
          )
        ],
      ),
    );
  }
}

class _OriginLocationField extends HookViewModelWidget<PrincipalViewModel> {
  const _OriginLocationField({
    Key key,
  }) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, PrincipalViewModel model) {
    final searchController = useTextEditingController();
    useEffect(() {
      searchController.text = model.userLocation.descriptionAddress;
      return null;
    }, [model.userLocation]);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: searchController,
                autofocus: false,
                textAlignVertical: TextAlignVertical.center,
                textInputAction: TextInputAction.done,
                style: const TextStyle(color: Color(0xff545253), fontSize: 14),
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.1)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.1)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.transparent, width: 0.1),
                  ),
                  contentPadding: const EdgeInsets.all(0),
                  alignLabelWithHint: true,
                  isDense: true,
                ),
              ),
            ),
            GestureDetector(onTap: () => model.clearOriginPosition(), child: SvgPicture.asset('assets/icons/icon_x.svg', height: 20.0)),
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

class _DestinationLocationField extends HookViewModelWidget<PrincipalViewModel> {
  const _DestinationLocationField({
    Key key,
  }) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, PrincipalViewModel model) {
    final searchController = useTextEditingController();
    // useEffect(() {
    //   searchController.text = model.userLocation.descriptionAddress;
    //   return null;
    // }, [model.userLocation]);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: searchController,
                autofocus: false,
                onTap: () {},
                onSubmitted: (text) => model.searchDestination(text),
                textAlignVertical: TextAlignVertical.center,
                textInputAction: TextInputAction.done,
                style: const TextStyle(color: Color(0xff545253), fontSize: 14),
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.1)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.1)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.transparent, width: 0.1),
                  ),
                  contentPadding: const EdgeInsets.all(0),
                  alignLabelWithHint: true,
                  hintText: Keys.destination.localize(),
                  isDense: true,
                  hintStyle: const TextStyle(color: Color(0xff545253), fontSize: 14),
                ),
              ),
            ),
            GestureDetector(onTap: () => model.clearDestinationPosition(), child: SvgPicture.asset('assets/icons/icon_x.svg', height: 20.0)),
          ],
        ),
      ),
    );
  }
}

class ManualMarker extends ViewModelWidget<PrincipalViewModel> {
  const ManualMarker({Key key}) : super(key: key);

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
                    child: const Text('Nuevo destino', style: TextStyle(color: Colors.black))), // TODO: translate
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
                        child: const Text('Ubica tu destino', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)))), // TODO: translate
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
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 60.0),
                    child: ActionButtonCustom(
                      action: () => model.makeRoute(
                        Place(latLng: model.centralLocation, address: '', name: ''),
                        context,
                      ),
                      label: Keys.confirm_destination.localize(),
                      fontSize: 16,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
