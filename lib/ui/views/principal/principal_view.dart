import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

import 'package:taxiapp/models/place.dart';
import 'package:taxiapp/ui/views/principal/principal_viewmodel.dart';

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
    return Stack(
      children: [
        model.userLocation.existLocation
            ? GoogleMap(
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
              )
            : const Center(child: Text('Ubicando...')),
        Positioned(
          right: 20,
          top: MediaQuery.of(context).size.height * .2,
          child: Row(
            children: [
              const Text('Google'),
              CupertinoSwitch(
                onChanged: (value) => model.updateApiSelection(value),
                value: model.apiSelected,
              ),
              const Text('MapBox'),
            ],
          ),
        ),
        const Positioned(
          top: 0,
          child: _SearchBar(),
        ),
        if (model.isManualSearch) _ManualMarker()
      ],
    );
  }
}

class _SearchBar extends ViewModelWidget<PrincipalViewModel> {
  const _SearchBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, PrincipalViewModel model) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: .4)),
              boxShadow: [BoxShadow(blurRadius: 7, color: Colors.black45, spreadRadius: 4, offset: Offset(-4, -4))],
              color: Colors.white,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  children: [
                    const _OriginLocationField(),
                    const _DestinationLocationField(),
                  ],
                ),
                Expanded(
                  child: CircleAvatar(
                    backgroundColor: const Color(0xffFFA500),
                    radius: MediaQuery.of(context).size.width * .07,
                  ),
                ),
              ],
            ),
          ),
          WillPopScope(
            onWillPop: () {
              model.updateSearching(false);
              return Future.value(false);
            },
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(Icons.timer),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(place.name),
                      Text(place.address, overflow: TextOverflow.ellipsis),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SvgPicture.asset('assets/icons/start_location.svg', height: 20.0),
              ),
              const Text('Ubicar en mapa'), // TODO: translate
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
          const Text('Se necesita autorizar el GPS para utilizar el app '), // TODO: translate
          MaterialButton(
              child: const Text('Solicitar Acceso', style: TextStyle(color: Colors.white)), // TODO: translate
              color: Colors.black,
              shape: const StadiumBorder(),
              elevation: 0,
              splashColor: Colors.transparent,
              onPressed: () async {
                final status = await Permission.location.request();
                await model.accessGPS(status);
              })
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(color: Colors.grey, width: 0.1),
          color: const Color(0xffF1F1F1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 30.0,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              width: MediaQuery.of(context).size.width * 0.75,
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: searchController,
                      autofocus: false,
                      textAlignVertical: TextAlignVertical.center,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.1)),
                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.1)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.transparent, width: 0.1),
                        ),
                        contentPadding: const EdgeInsets.all(0),
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),
                  _OriginButton(icon: 'assets/icons/destination.svg', onTap: () {}),
                  _OriginButton(icon: 'assets/icons/start_location.svg', onTap: () {}),
                ],
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
          width: 30,
          child: SvgPicture.asset(
            icon,
            height: 20,
          ),
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(color: Colors.grey, width: 0.1),
          color: const Color(0xffF1F1F1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 30.0,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              width: MediaQuery.of(context).size.width * 0.75,
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
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.1)),
                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.1)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.transparent, width: 0.1),
                          ),
                          contentPadding: const EdgeInsets.all(0),
                          alignLabelWithHint: true,
                          hintText: 'Destino' // TODO: translate
                          ),
                    ),
                  ),
                ],
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
            child: const Text('Confirmar destino', style: TextStyle(color: Colors.white)), // TODO: translate
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
