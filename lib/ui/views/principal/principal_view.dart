import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
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
        model.existLocation
            ? GoogleMap(
                initialCameraPosition: CameraPosition(target: model.currentLocation, zoom: 15),
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
          top: 0,
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
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
        ),
      ],
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
          const Text('Se necesita autorizar el GPS para utilizar el app '),
          MaterialButton(
              child: const Text('Solicitar Acceso', style: TextStyle(color: Colors.white)),
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
    var searchController = useTextEditingController();
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
                        border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.transparent, width: 0.1)),
                        contentPadding: const EdgeInsets.all(0),
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset(
                      'assets/icons/destination.svg',
                      height: 20,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset('assets/icons/start_location.svg', height: 20),
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

class _DestinationLocationField extends HookViewModelWidget<PrincipalViewModel> {
  const _DestinationLocationField({
    Key key,
  }) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, PrincipalViewModel model) {
    var searchController = useTextEditingController();
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
                        border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.transparent, width: 0.1)),
                        contentPadding: const EdgeInsets.all(0),
                        alignLabelWithHint: true,
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
