import 'package:auto_route/auto_route.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';

import 'package:flutter/material.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/theme/pallete_color.dart';
import 'package:taxiapp/ui/views/register/register_viewmodel.dart';

import 'package:taxiapp/extensions/string_extension.dart';
import 'package:taxiapp/ui/widgets/buttons/platform_back_button.dart';
import 'package:taxiapp/ui/widgets/text_field/text_field_custom.dart';

class RegisterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterViewModel>.nonReactive(
      viewModelBuilder: () => RegisterViewModel(context),
      onModelReady: (model) => model.initial(),
      builder: (context, model, child) => Container(
        color: PalleteColor.backgroundColor,
        child: Stack(
          children: [
            if (MediaQuery.of(context).size.height > 600)
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

class _BodyRegister extends HookViewModelWidget<RegisterViewModel> {
  _BodyRegister({
    Key key,
  }) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, RegisterViewModel model) {
    final namesController = useTextEditingController();
    final emailController = useTextEditingController();
    final phoneController = useTextEditingController();
    final passwordController = useTextEditingController();
    final retypePasswordController = useTextEditingController();
    final emailFocus = useFocusNode();
    final phoneFocus = useFocusNode();
    final passwordFocus = useFocusNode();
    final retypePasswordFocus = useFocusNode();
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.transparent,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                PlatformBackButton(
                    onPressed: () => ExtendedNavigator.root.pop()),
                Expanded(
                  child: Text(
                    Keys.user_registration.localize(),
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.left,
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
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30.0),
                  child: Column(
                    children: <Widget>[
                      TextFieldCustom(
                        controller: namesController,
                        onChanged: (value) => model.name = value,
                        labelText: Keys.first_name_and_surname.localize(),
                        nextFocus: phoneFocus,
                        inputFormatters: [LengthLimitingTextInputFormatter(50)],
                        icon: 'assets/icons/profile_avatar.svg',
                      ),
                      const SizedBox(height: 10.0),
                      TextFieldCustom(
                        controller: phoneController,
                        focus: phoneFocus,
                        onChanged: (value) => model.phone = value,
                        labelText: Keys.mobile_phone.localize(),
                        nextFocus: emailFocus,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(9),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.phone,
                        icon: 'assets/icons/phone_enroll.svg',
                      ),
                      const SizedBox(height: 10.0),
                      TextFieldCustom(
                        controller: emailController,
                        focus: emailFocus,
                        onChanged: (value) => model.email = value,
                        labelText: Keys.email.localize(),
                        nextFocus: passwordFocus,
                        inputFormatters: [LengthLimitingTextInputFormatter(50)],
                        keyboardType: TextInputType.emailAddress,
                        icon: 'assets/icons/mail.svg',
                      ),
                      const SizedBox(height: 10.0),
                      TextFieldCustom(
                        controller: passwordController,
                        focus: passwordFocus,
                        onChanged: (value) => model.password = value,
                        labelText: Keys.password.localize(),
                        nextFocus: retypePasswordFocus,
                        inputFormatters: [LengthLimitingTextInputFormatter(20)],
                        isPassword: true,
                        icon: 'assets/icons/lock.svg',
                      ),
                      const SizedBox(height: 10.0),
                      TextFieldCustom(
                        controller: retypePasswordController,
                        focus: retypePasswordFocus,
                        onChanged: (value) => model.repeatPassword = value,
                        labelText: Keys.repeat_password.localize(),
                        inputFormatters: [LengthLimitingTextInputFormatter(20)],
                        isPassword: true,
                        isFinal: true,
                        icon: 'assets/icons/lock.svg',
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

class _ContinueEnrollButton extends ViewModelWidget<RegisterViewModel> {
  const _ContinueEnrollButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, RegisterViewModel model) {
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
            : () => !model.isBusy ? model.signin() : null,
      ),
    );
  }
}
