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

    final documentController = useTextEditingController();
    final documentFocus = useFocusNode();
    final plateController = useTextEditingController();
    final plateFocus = useFocusNode();
    final markController = useTextEditingController();
    final markFocus = useFocusNode();
    final modelController = useTextEditingController();
    final modelFocus = useFocusNode();
    final yearProductionController = useTextEditingController();
    final yearProductionFocus = useFocusNode();

    const separator = SizedBox(height: 7.0);

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
                      separator,
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
                      separator,
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
                      separator,
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
                      separator,
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
                      separator,
                      Row(
                        children: [
                          ToggleSwitch(
                            minWidth: 60,
                            minHeight: 35,
                            initialLabelIndex:
                                model.documentType == '03' ? 1 : 0,
                            labels: ['DNI', 'CE'],
                            onToggle: (index) {
                              if (index == 0) {
                                model.documentType = '01';
                              } else if (index == 1) {
                                model.documentType = '03';
                              }
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
                      separator,
                      ToggleSwitch(
                        minWidth: 100,
                        minHeight: 35,
                        initialLabelIndex: model.typeService ?? 0,
                        labels: ['Moto lineal', 'Moto car', 'Auto'],
                        onToggle: (index) {
                          model.typeService = index;
                        },
                      ),
                      separator,
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
                      separator,
                      TextFieldCustom(
                        controller: markController,
                        focus: markFocus,
                        onChanged: (value) => model.mark = value,
                        labelText: 'Marca', //TODO: Translate
                        nextFocus: modelFocus,
                        inputFormatters: [LengthLimitingTextInputFormatter(20)],
                        iconData: Icons.wysiwyg_sharp,
                      ),
                      separator,
                      TextFieldCustom(
                        controller: modelController,
                        focus: modelFocus,
                        onChanged: (value) => model.model = value,
                        labelText: 'Modelo', //TODO: Translate
                        nextFocus: yearProductionFocus,
                        inputFormatters: [LengthLimitingTextInputFormatter(20)],
                        iconData: Icons.local_car_wash_rounded,
                      ),
                      separator,
                      TextFieldCustom(
                        controller: yearProductionController,
                        focus: yearProductionFocus,
                        onChanged: (value) => model.yearProduction = value,
                        labelText: 'Año de fabricación', //TODO: Translate
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(4),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        iconData: Icons.query_builder,
                        isFinal: true,
                      ),
                      separator,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Profile Picture : '),
                          Stack(
                              children: [
                            Container(
                              width: 80,
                              height: 80,
                              child: ClipOval(
                                  child: model.image == null
                                      ? InkWell(
                                          onTap: model.showPicker,
                                          child: UploadPicture())
                                      : Image.file(
                                          model.image,
                                          fit: BoxFit.cover,
                                        )),
                            ),
                            model.image != null
                                ? Positioned(
                                    left: 50,
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            model.image = null;
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 1.0),
                                            ),
                                            height:
                                                28.0, // height of the button
                                            width: 28.0, // width of the button
                                            child: const Icon(Icons.close,
                                                color: Colors.black,
                                                size: 17.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : null,
                          ].where((wd) => wd != null).toList()),
                        ],
                      ),
                      const SizedBox(height: 15.0),
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

class UploadPicture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt_outlined, color: Colors.white),
          const Text(
            'Upload Picture',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
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
      height: 40,
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
