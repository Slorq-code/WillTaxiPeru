import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/ui/views/principal/principal_viewmodel.dart';

class RideRequestsByClient extends ViewModelWidget<PrincipalViewModel> {
  const RideRequestsByClient({
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
            Positioned.fill(
              child: DraggableScrollableSheet(
                maxChildSize: 0.88,
                minChildSize: 0.4,
                initialChildSize: 0.4,
                builder: (_, controller) {
                  return Material(
                      elevation: 10,
                      color: Colors.white,
                      child: Stack(
                        children: [
                          ListView(
                            padding: const EdgeInsets.only(bottom: 40),
                            controller: controller,
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Container(
                                    width: 40.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.0),
                                      color: const Color(0xff696868),
                                    ),
                                    height: 6.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Container(
                              width: double.infinity,
                              child: ListView(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                children: List.generate(
                                  20,
                                  (index) => _RideRequestClientItem(onTap: () => model.selectRideRequest(null, context)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ));
                },
              ),
            ),
          ],
        ));
  }
}

class _RideRequestClientItem extends HookWidget {
  const _RideRequestClientItem({
    Key key,
    this.onTap,
  }) : super(key: key);
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap != null ? onTap() : () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xfff0f0f0), width: 2.0))),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: SvgPicture.asset('assets/icons/locate_position.svg'),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Av. Antunez de Mayolo, Los Olivos',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Text('3 min', style: TextStyle(fontSize: 12.0)),
                      ),
                      SvgPicture.asset('assets/icons/clock.svg', height: 15.0),
                      const Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Text('12:40', style: TextStyle(fontSize: 12.0)),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Text('S/ 12.00', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
