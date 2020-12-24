import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked/stacked.dart';

import 'package:flutter/material.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/theme/pallete_color.dart';
import 'package:taxiapp/ui/views/profile/profile_viewmodel.dart';

import 'package:taxiapp/extensions/string_extension.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.nonReactive(
      viewModelBuilder: () => ProfileViewModel(context),
      onModelReady: (model) => model.initial(),
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
          body: _BodyRegistro(),
        ),
      ),
    );
  }
}

class _BodyRegistro extends HookViewModelWidget<ProfileViewModel> {
  _BodyRegistro({
    Key key,
  }) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, ProfileViewModel model) {
    final focusEmail = useFocusNode();
    final focusPhone = useFocusNode();
    final focusPassword = useFocusNode();
    final focusRetypePassword = useFocusNode();
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                children: <Widget>[
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    Keys.sign_up.localize(),
                    style: const TextStyle(color: Color.fromRGBO(130, 130, 130, 1.0), fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    initialValue: model.name,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50),
                    ],
                    readOnly: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: Keys.first_name_and_surname.localize(),
                      labelStyle: const TextStyle(color: Color.fromRGBO(130, 130, 130, 1.0)),
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(40, 180, 245, 1.0),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(130, 130, 130, 1.0),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    style: const TextStyle(
                      color: Color.fromRGBO(130, 130, 130, 1.0),
                      fontSize: 14.0,
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => focusEmail.requestFocus(),
                    onChanged: (value) => model.name = value,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: model.email,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50),
                    ],
                    keyboardType: TextInputType.emailAddress,
                    focusNode: focusEmail,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: Keys.email.localize(),
                      labelStyle: const TextStyle(color: Color.fromRGBO(130, 130, 130, 1.0)),
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(40, 180, 245, 1.0),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(130, 130, 130, 1.0),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    style: const TextStyle(
                      color: Color.fromRGBO(130, 130, 130, 1.0),
                      fontSize: 14.0,
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => focusPhone.requestFocus(),
                    onChanged: (value) => model.email = value,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: model.phone,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(9),
                    ],
                    keyboardType: TextInputType.phone,
                    focusNode: focusPhone,
                    decoration: InputDecoration(
                      labelText: Keys.mobile_phone.localize(),
                      labelStyle: const TextStyle(color: Color.fromRGBO(130, 130, 130, 1.0)),
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(40, 180, 245, 1.0),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(130, 130, 130, 1.0),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    style: const TextStyle(
                      color: Color.fromRGBO(130, 130, 130, 1.0),
                      fontSize: 14.0,
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => focusPassword.requestFocus(),
                    onChanged: (value) => model.phone = value,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    obscureText: model.passwordOfuscado,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                    ],
                    keyboardType: TextInputType.text,
                    focusNode: focusPassword,
                    decoration: InputDecoration(
                      labelText: Keys.password.localize(),
                      labelStyle: const TextStyle(color: Color.fromRGBO(130, 130, 130, 1.0)),
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(40, 180, 245, 1.0),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(130, 130, 130, 1.0),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          model.passwordOfuscado ? Icons.visibility_off : Icons.visibility,
                          color: const Color.fromRGBO(130, 130, 130, 1.0),
                        ),
                        onPressed: () {
                          model.passwordOfuscado = !model.passwordOfuscado;
                        },
                      ),
                    ),
                    style: const TextStyle(
                      color: Color.fromRGBO(130, 130, 130, 1.0),
                      fontSize: 14.0,
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => focusRetypePassword.requestFocus(),
                    onChanged: (value) => model.password = value,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    obscureText: model.repitePasswordOfuscado,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                    ],
                    keyboardType: TextInputType.text,
                    focusNode: focusRetypePassword,
                    decoration: InputDecoration(
                      labelText: Keys.repeat_password.localize(),
                      labelStyle: const TextStyle(color: Color.fromRGBO(130, 130, 130, 1.0)),
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(40, 180, 245, 1.0),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(130, 130, 130, 1.0),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          model.repitePasswordOfuscado ? Icons.visibility_off : Icons.visibility,
                          color: const Color.fromRGBO(130, 130, 130, 1.0),
                        ),
                        onPressed: () {
                          model.repitePasswordOfuscado = !model.repitePasswordOfuscado;
                        },
                      ),
                    ),
                    style: const TextStyle(
                      color: Color.fromRGBO(130, 130, 130, 1.0),
                      fontSize: 14.0,
                    ),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                    onChanged: (value) => model.repeatPassword = value,
                  ),
                  
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
