import 'package:stacked/stacked.dart';

import 'package:flutter/material.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:taxiapp/theme/pallete_color.dart';
import 'package:taxiapp/ui/views/principal/principal_viewmodel.dart';

class PrincipalView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PrincipalViewModel>.nonReactive(
      viewModelBuilder: () => PrincipalViewModel(),
      onModelReady: (model) => model.initial(),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          backgroundColor: PalleteColor.backgroundColor,
          body: _BodyRegistro(),
        ),
      ),
    );
  }
}

class _BodyRegistro extends HookViewModelWidget<PrincipalViewModel> {
  _BodyRegistro({
    Key key,
  }) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, PrincipalViewModel model) {
    return Center(
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: Color.fromRGBO(12, 128, 206, 1.0),
        child: Container(
          child: Text(
            'LOGOUT',
            style: TextStyle(color: Colors.white),
          ),
        ),
        onPressed: () {
          if (!model.isBusy) {
            model.logout();
          }
        },
      ),
    );
  }
}
