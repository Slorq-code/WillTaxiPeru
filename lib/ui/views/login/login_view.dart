import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked/stacked.dart';

import 'package:flutter/material.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:taxiapp/app/router.gr.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/models/enums/auth_type.dart';
import 'package:taxiapp/theme/pallete_color.dart';
import 'package:taxiapp/ui/views/login/login_viewmodel.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:taxiapp/extensions/string_extension.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.nonReactive(
      viewModelBuilder: () => LoginViewModel(context),
      onModelReady: (model) => model.initial(),
      builder: (context, model, child) => SafeArea(
        child: Container(
          color: PalleteColor.backgroundColor,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SvgPicture.asset('assets/background/background_login.svg', fit: BoxFit.cover),
              ),
              SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: _BodyLogin(),
                  // resizeToAvoidBottomPadding: false,
                ),
              ),
            ],
          ),
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
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final passwordFocus = useFocusNode();
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              Keys.login.localize(),
              style: const TextStyle(color: Colors.black, fontSize: 27, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextFormField(
                      controller: emailController,
                      inputFormatters: [LengthLimitingTextInputFormatter(50)],
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: Keys.email.localize(),
                        labelStyle: const TextStyle(fontSize: 16.0, color: Colors.black),
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xffF0F0F0), width: 3.0),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xffF0F0F0), width: 3.0),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        filled: true,
                      ),
                      style: const TextStyle(fontSize: 14.0, color: Colors.black),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => passwordFocus.requestFocus(),
                      onChanged: (value) => model.user = value,
                    ),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      controller: passwordController,
                      focusNode: passwordFocus,
                      obscureText: model.passwordOfuscado,
                      inputFormatters: [LengthLimitingTextInputFormatter(20)],
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: Keys.password.localize(),
                        labelStyle: const TextStyle(fontSize: 16.0, color: Colors.black),
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xffF0F0F0), width: 3.0),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xffF0F0F0), width: 3.0),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        filled: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            model.passwordOfuscado ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () => model.passwordOfuscado = !model.passwordOfuscado,
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                      onChanged: (value) => model.password = value,
                    ),
                    const SizedBox(height: 15.0),
                    GestureDetector(
                      onTap: () => !model.isBusy ? model.goToResetPassword() : null,
                      child: Text(Keys.forgot_your_password.localize(), style: const TextStyle(color: Colors.black, fontSize: 16)),
                    ),
                    const SizedBox(height: 20.0),
                    const _SocialButtons(),
                    const SizedBox(height: 20.0),
                    const _ContinueButton(),
                    const SizedBox(height: 20.0),
                    const _EnrollAdvice(),
                    const SizedBox(height: 10.0),
                    RaisedButton(
                      color: Colors.blue,
                      child: const Text('To Principal view', style: TextStyle(color: Colors.white)),
                      onPressed: () => ExtendedNavigator.root.push(Routes.principalViewRoute),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueButton extends ViewModelWidget<LoginViewModel> {
  const _ContinueButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, LoginViewModel model) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .18),
      width: double.infinity,
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: PalleteColor.actionButtonColor,
        disabledColor: PalleteColor.actionButtonColor.withOpacity(0.5),
        child: Text(Keys.continue_label.localize(), style: const TextStyle(fontSize: 16.0, color: Colors.white)),
        onPressed: !model.enableBtnContinue ? null : () => !model.isBusy ? model.login(AuthType.User) : null,
      ),
    );
  }
}

class _EnrollAdvice extends ViewModelWidget<LoginViewModel> {
  const _EnrollAdvice({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, LoginViewModel model) {
    return SizedBox(
      height: 40,
      child: RichText(
        text: TextSpan(
          text: '${Keys.login_dont_have_account.localize()}, ',
          style: const TextStyle(color: Colors.black, fontSize: 16),
          children: <TextSpan>[
            TextSpan(
                text: Keys.sign_up.localize(),
                style: const TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.w600, color: Colors.black, fontSize: 16),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    if (!model.isBusy) {
                      model.goToRegisterUser();
                    }
                  }),
          ],
        ),
      ),
    );
  }
}

class _SocialButtons extends ViewModelWidget<LoginViewModel> {
  const _SocialButtons({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, LoginViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FloatingActionButton(
          heroTag: 'btnFacebook',
          backgroundColor: Colors.transparent,
          child: SvgPicture.asset('assets/icons/ic_facebook.svg', fit: BoxFit.fitWidth),
          onPressed: !model.isBusy ? () => model.login(AuthType.Facebook) : () {},
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text('-', style: TextStyle(color: Colors.black, fontSize: 30)),
        ),
        FloatingActionButton(
          heroTag: 'btnGoogle',
          backgroundColor: Colors.transparent,
          child: SvgPicture.asset('assets/icons/ic_google.svg', fit: BoxFit.fitWidth),
          onPressed: !model.isBusy ? () => model.login(AuthType.Google) : () {},
        ),
      ],
    );
  }
}
