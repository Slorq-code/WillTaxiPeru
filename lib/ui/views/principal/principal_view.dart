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

import 'package:taxiapp/models/place.dart';
import 'package:taxiapp/ui/views/principal/principal_viewmodel.dart';
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
              if (model.isManualSearch) _ManualMarker()
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
      child: Column(
        children: [
          Container(
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
          WillPopScope(
            onWillPop: () => Future.value(model.onBack()),
            child: Visibility(
              visible: model.isSearching,
              child: Container(
                height: MediaQuery.of(context).size.height * .5,
                width: double.infinity,
                color: Colors.white,
                child: ListView(
                  children: [
                    ...model.placesFound.map(
                      (place) => _SugerationPlace(
                        place: place,
                        onTap: () => model.makeRoute(place),
                      ),
                    ),
                    const _PickInMapOption(),
                  ],
                ),
              ),
            ),
          )
        ],
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
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: .4)),
        boxShadow: [BoxShadow(blurRadius: 7, color: Colors.black45, spreadRadius: 4, offset: Offset(-4, -4))],
        color: Colors.white,
      ),
      child: Column(
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
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                      onTap: () => model.makeRoute(place),
                    ),
                  ),
                  const _PickInMapOption(),
                ],
              ),
            ),
          )
        ],
      ),
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
      onTap: () => model.updateManualSearchState(true),
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
              Text(Keys.locate_on_map.localize()),
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
                onTap: () => model.updateSearching(true),
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
          ],
        ),
      ),
    );
  }
}

class _ManualMarker extends ViewModelWidget<PrincipalViewModel> {
  @override
  Widget build(BuildContext context, PrincipalViewModel model) {
    final width = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: MediaQuery.of(context).size.height * .2,
          left: 0,
          child: RaisedButton(
            shape: const CircleBorder(),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.all(0),
            color: Colors.white,
            child: const Icon(Icons.arrow_back, color: Colors.orange),
            onPressed: () => model.updateManualSearchState(false),
          ),
        ),

        const Center(
          child: Icon(Icons.location_on, size: 50, color: Colors.orange),
        ),

        // Boton de confirmar destino
        Positioned(
          bottom: 70,
          child: MaterialButton(
            minWidth: width - 120,
            child: Text(Keys.confirm_destination.localize(), style: const TextStyle(color: Colors.white)),
            color: Colors.orange,
            shape: const StadiumBorder(),
            elevation: 0,
            splashColor: Colors.transparent,
            onPressed: () => model.makeRoute(
              Place(latLng: model.centralLocation, address: '', name: ''),
            ),
          ),
        )
      ],
    );
  }
}
