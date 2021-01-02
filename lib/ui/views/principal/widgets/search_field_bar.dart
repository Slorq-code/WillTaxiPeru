import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:taxiapp/extensions/string_extension.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/models/place.dart';
import 'package:taxiapp/ui/views/principal/principal_viewmodel.dart';
import 'package:taxiapp/ui/widgets/buttons/platform_back_button.dart';

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
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: .4)),
              boxShadow: [BoxShadow(blurRadius: 7, color: Colors.black45, spreadRadius: 4, offset: Offset(-4, -4))],
              color: Colors.white,
            ),
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  title: Text(Keys.new_destination.localize(), style: const TextStyle(color: Colors.black)),
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
                  Container(
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
              ],
            ),
          ),
          if (model.rideRequest != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Expanded(flex: 1, child: SizedBox()),
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: const Color(0xfff0f0f0)),
                      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 50.0),
                      child: const Text('Tu GO esta en camino!'), //TODO: update with translate
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black), color: Colors.white),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            '${(model.rideRequest.secondsArrive ~/ 60).toString()}\'',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
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
              Text(Keys.set_location_on_map.localize(), style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
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
            GestureDetector(
                onTap: () => model.clearOriginPosition(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: SvgPicture.asset('assets/icons/icon_x.svg', height: 20.0),
                )),
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
    final searchController = useTextEditingController();
    useEffect(() {
      searchController.text = model.destinationSelected != null ? model.destinationSelected.address : '';
      return null;
    }, [model.destinationSelected]);
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
            GestureDetector(
                onTap: () => model.clearDestinationPosition(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: SvgPicture.asset('assets/icons/icon_x.svg', height: 20.0),
                )),
          ],
        ),
      ),
    );
  }
}
