import 'package:auto_route/auto_route.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked/stacked.dart';

import 'package:flutter/material.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/theme/pallete_color.dart';

import 'package:taxiapp/extensions/string_extension.dart';
import 'package:taxiapp/ui/views/registerDriver/registerDriver_viewmodel.dart';
import 'package:taxiapp/ui/widgets/buttons/platform_back_button.dart';
import 'package:taxiapp/ui/widgets/text_field/text_field_custom.dart';
import 'package:toggle_switch/toggle_switch.dart';

class RegisterDriverView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterDriverViewModel>.nonReactive(
      viewModelBuilder: () => RegisterDriverViewModel(context),
      onModelReady: (model) => model.initial(),
      builder: (context, model, child) => Container(
        color: PalleteColor.backgroundColor,
        child: Stack(
          children: [
            // if (MediaQuery.of(context).size.height > 600)
            //   Positioned(
            //     bottom: 0,
            //     left: 0,
            //     right: 0,
            //     child: AspectRatio(
            //       aspectRatio: 1.1,
            //       child: SvgPicture.asset(
            //           'assets/background/background_enroll.svg',
            //           fit: BoxFit.contain),
            //     ),
            //   ),
            SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: _BodyRegisterDriver(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BodyRegisterDriver extends HookViewModelWidget<RegisterDriverViewModel> {
  _BodyRegisterDriver({
    Key key,
  }) : super(key: key);

  @override
  Widget buildViewModelWidget(
      BuildContext context, RegisterDriverViewModel model) {
    final namesController = useTextEditingController();
    final emailController = useTextEditingController();
    final emailFocus = useFocusNode();
    final phoneController = useTextEditingController();
    final phoneFocus = useFocusNode();
    final passwordController = useTextEditingController();
    final passwordFocus = useFocusNode();
    final retypePasswordController = useTextEditingController();
    final retypePasswordFocus = useFocusNode();

    final documentTypeController = useTextEditingController();
    final documentTypeFocus = useFocusNode();
    final documentController = useTextEditingController();
    final documentFocus = useFocusNode();
    final plateController = useTextEditingController();
    final plateFocus = useFocusNode();
    final typeServiceController = useTextEditingController();
    final typeServiceFocus = useFocusNode();
    final markController = useTextEditingController();
    final markFocus = useFocusNode();
    final modelController = useTextEditingController();
    final modelFocus = useFocusNode();
    final yearProductionController = useTextEditingController();
    final yearProductionFocus = useFocusNode();

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
                Text(
                  Keys.enroll_driver.localize(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 27,
                      fontWeight: FontWeight.bold),
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
                        nextFocus: documentFocus,
                        isPassword: true,
                        icon: 'assets/icons/lock.svg',
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          ToggleSwitch(
                            minWidth: 60,
                            minHeight: 35,
                            initialLabelIndex: 0,
                            labels: ['DNI', 'CE'],
                            onToggle: (index) {
                              print('switched to: $index');
                            },
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: TextFieldCustom(
                                controller: documentController,
                                focus: documentFocus,
                                onChanged: (value) => model.document = value,
                                labelText: 'Documento', //TODO: Translate
                                nextFocus: plateFocus,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(20)
                                ]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      ToggleSwitch(
                        minWidth: 100,
                        minHeight: 35,
                        initialLabelIndex: 0,
                        labels: ['Auto', 'Moto car','Moto lineal'],
                        onToggle: (index) {
                          print('switched to: $index');
                        },
                      ),
                      const SizedBox(height: 10.0),
                      TextFieldCustom(
                          controller: plateController,
                          focus: plateFocus,
                          onChanged: (value) => model.plate = value,
                          labelText: 'Placa', //TODO: Translate
                          nextFocus: markFocus,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(20)
                          ],
                          iconData: Icons.description_rounded),
                      const SizedBox(height: 10.0),
                      TextFieldCustom(
                        controller: markController,
                        focus: markFocus,
                        onChanged: (value) => model.mark = value,
                        labelText: 'Marca', //TODO: Translate
                        nextFocus: modelFocus,
                        inputFormatters: [LengthLimitingTextInputFormatter(20)],
                        iconData: Icons.wysiwyg_sharp,
                      ),
                      const SizedBox(height: 10.0),
                      TextFieldCustom(
                        controller: modelController,
                        focus: modelFocus,
                        onChanged: (value) => model.model = value,
                        labelText: 'Modelo', //TODO: Translate
                        nextFocus: yearProductionFocus,
                        inputFormatters: [LengthLimitingTextInputFormatter(20)],
                        iconData: Icons.local_car_wash_rounded,
                      ),
                      const SizedBox(height: 10.0),
                      TextFieldCustom(
                        controller: yearProductionController,
                        focus: yearProductionFocus,
                        onChanged: (value) => model.yearProduction = value,
                        labelText: 'Año de fabricación', //TODO: Translate
                        inputFormatters: [LengthLimitingTextInputFormatter(4)],
                        iconData: Icons.query_builder,
                        isFinal: true,
                      ),
                      const SizedBox(height: 20.0),
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

class _ContinueEnrollButton extends ViewModelWidget<RegisterDriverViewModel> {
  const _ContinueEnrollButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, RegisterDriverViewModel model) {
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
