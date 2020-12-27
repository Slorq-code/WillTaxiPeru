import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:taxiapp/theme/pallete_color.dart';
import 'package:taxiapp/ui/views/profile/profile_viewmodel.dart';
import 'package:taxiapp/ui/widgets/profile/header_widget.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.nonReactive(
      viewModelBuilder: () => ProfileViewModel(context),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: true,
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
          ),
          backgroundColor: PalleteColor.backgroundColor,
          body: _BodyRegistro._BodyProfile(),
        ),
      ),
    );
  }
}

class _BodyRegistro extends HookViewModelWidget<ProfileViewModel> {
  _BodyRegistro._BodyProfile({
    Key key,
  }) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, ProfileViewModel model) {
    return HeaderWidget();
  }
}
