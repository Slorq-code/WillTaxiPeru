import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/extensions/string_extension.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/ui/views/principal/principal_viewmodel.dart';
import 'package:taxiapp/utils/utils.dart';

class FinishRideWidget extends ViewModelWidget<PrincipalViewModel> {
  const FinishRideWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, PrincipalViewModel model) {
    return Container(
        height: MediaQuery.of(context).size.height * .91,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * .14,
                  top: 25.0,
                  bottom: 40.0),
              child: Image.asset(
                'assets/icons/finish_ride.gif',
                fit: BoxFit.fitHeight,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 20.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xfff0f0f0)),
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
                child: Text(
                  Keys.you_have_reached_your_destination.localize(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton(
                        heroTag: null,
                        elevation: 0,
                        backgroundColor: const Color(0xff007dff),
                        onPressed: () => Utils.shareText(
                            'Go', 'https://play.google.com/store'),
                        child: const Icon(Icons.share),
                      ),
                      FloatingActionButton(
                        heroTag: null,
                        elevation: 0,
                        focusElevation: 2,
                        highlightElevation: 2,
                        backgroundColor: const Color(0xffffbc40),
                        onPressed: () => model.finishRide(),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 2.0),
                          child: Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ));
  }
}
