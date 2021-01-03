import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:morpheus/morpheus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/extensions/string_extension.dart';
import 'package:taxiapp/localization/keys.dart';
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
                    ? Home(model: model)
                    : const _ForceEnableGPS()),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({
    Key key,
    @required this.model,
  })  : assert(model != null),
        super(key: key);

  final PrincipalViewModel model;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      widget.model.restoreMap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const _HomeMap();
  }
}

class _HomeMap extends ViewModelWidget<PrincipalViewModel> {
  const _HomeMap({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, PrincipalViewModel model) {
    return model.userLocation.existLocation
        ? WillPopScope(
            onWillPop: () => Future.value(model.onBack()),
            child: Stack(
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
                const Positioned(
                  bottom: 0,
                  child: _Ride(),
                ),
              ],
            ),
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

class _Ride extends ViewModelWidget<PrincipalViewModel> {
  const _Ride({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, PrincipalViewModel model) {
    return MorpheusTabView(child: model.currentRideWidget);
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
