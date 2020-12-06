import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked/stacked.dart';

import 'package:flutter/material.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/theme/pallete_color.dart';
import 'package:taxiapp/ui/views/login/login_viewmodel.dart';
import 'package:taxiapp/extensions/string_extension.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.nonReactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          backgroundColor: PalleteColor.backgroundColor,
          body: _BodyLogin(),
        ),
      ),
    );
  }
}

class _BodyLogin extends HookViewModelWidget<LoginViewModel> {
  _BodyLogin({
    Key key,
  }) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, LoginViewModel model) {
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    return Center(
      child: Text(
        Keys.accept.localize(),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
