import 'package:auto_route/auto_route.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/theme/pallete_color.dart';
import 'package:taxiapp/extensions/string_extension.dart';
import 'package:taxiapp/ui/views/reset_password/reset_password_viewmodel.dart';
import 'package:taxiapp/ui/widgets/buttons/platform_back_button.dart';
import 'package:taxiapp/ui/widgets/text_field/text_field_custom.dart';

class ResetPasswordView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ResetPasswordViewModel>.nonReactive(
      viewModelBuilder: () => ResetPasswordViewModel(context),
      onModelReady: (model) => model.initial(),
      builder: (context, model, child) => Container(
        color: PalleteColor.backgroundColor,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AspectRatio(
                aspectRatio: 1.1,
                child: SvgPicture.asset(
                    'assets/background/background_enroll.svg',
                    fit: BoxFit.contain),
              ),
            ),
            SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: _BodyRegister(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BodyRegister extends HookViewModelWidget<ResetPasswordViewModel> {
  _BodyRegister({
    Key key,
  }) : super(key: key);

  @override
  Widget buildViewModelWidget(
      BuildContext context, ResetPasswordViewModel model) {
    final emailController = useTextEditingController(text:model.email);
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.transparent,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              children: [
                PlatformBackButton(
                    onPressed: () => ExtendedNavigator.root.pop()),
                Flexible(
                  child: Text(
                    Keys.reset_password.localize(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 27,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 30.0),
                  child: Column(
                    children: <Widget>[
                      TextFieldCustom(
                        controller: emailController,
                        onChanged: (value) => model.email = value,
                        labelText: Keys.email.localize(),
                        inputFormatters: [LengthLimitingTextInputFormatter(50)],
                        keyboardType: TextInputType.emailAddress,
                        icon: 'assets/icons/mail.svg',
                      ),
                      const SizedBox(height: 30.0),
                    ],
                  ),
                ),
                const _ContinueEnrollButton(),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueEnrollButton extends ViewModelWidget<ResetPasswordViewModel> {
  const _ContinueEnrollButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ResetPasswordViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .18),
      height: 50,
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: PalleteColor.actionButtonColor,
        disabledColor: PalleteColor.actionButtonColor.withOpacity(0.5),
        child: Text(Keys.continue_label.localize(),
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        onPressed: !model.enableBtnContinue
            ? null
            : () => !model.isBusy ? model.resetPassword() : null,
      ),
    );
  }
}
