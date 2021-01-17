import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:morpheus/widgets/morpheus_tab_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:taxiapp/extensions/string_extension.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/models/enums/auth_type.dart';

import 'package:taxiapp/models/enums/user_type.dart';
import 'package:taxiapp/theme/pallete_color.dart';
import 'package:taxiapp/ui/views/profile/profile_viewmodel.dart';
import 'package:taxiapp/ui/widgets/avatar_profile/avatar_profile.dart';
import 'package:taxiapp/ui/widgets/box_border_container.dart';
import 'package:taxiapp/ui/widgets/buttons/action_button_custom.dart';
import 'package:taxiapp/ui/widgets/buttons/platform_back_button.dart';
import 'package:taxiapp/ui/widgets/text_field/text_field_custom.dart';
import 'package:taxiapp/utils/utils.dart';

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
            backgroundColor: PalleteColor.backgroundColor,
            iconTheme: const IconThemeData(color: Colors.black),
            leading: PlatformBackButton(
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              _HeaderProfile(),
            ],
          ),
          backgroundColor: PalleteColor.backgroundColor,
          body: _BodyProfile(),
        ),
      ),
    );
  }
}

class _HeaderProfile extends HookViewModelWidget<ProfileViewModel> {
  _HeaderProfile({
    Key key,
  }) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, ProfileViewModel model) {
    return FlatButton(
      onPressed: () => !model.isBusy ? model.onEditProfile() : null,
      child: Text(
        model.isEditing ? Keys.cancel.localize() : Keys.edit.localize(),
        style: const TextStyle(color: Color(0xff017DFF), fontSize: 15.0),
      ),
    );
  }
}

class _BodyProfile extends HookViewModelWidget<ProfileViewModel> {
  _BodyProfile({
    Key key,
  }) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, ProfileViewModel model) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!model.isEditing)
          AvatarProfile(
            heroTag: model.user.uid,
            image: model.user.image,
            name: model.user.name,
            updatePicture: () {},
          ),
        const _BoxInformation(),
        if (!model.isEditing) const _CallCentralButton(),
        if (!model.isEditing) const _LogoutButton(),
        if (model.isEditing) const _ContinueButton(),
      ],
    );
  }
}

class _BoxInformation extends ViewModelWidget<ProfileViewModel> {
  const _BoxInformation({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ProfileViewModel model) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              const BoxShadow(
                blurRadius: 2,
                spreadRadius: 2,
                color: Colors.black12,
              ),
            ],
          ),
          child: Column(
            children: [
              const _TabBarCustom(height: 70),
              Expanded(
                child: MorpheusTabView(
                  child: model.children[model.currentIndex],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoutButton extends ViewModelWidget<ProfileViewModel> {
  const _LogoutButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ProfileViewModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 80.0),
      child: ActionButtonCustom(
        action: () => !model.isBusy ? model.logout() : null,
        label: Keys.logout.localize(),
        fontSize: 20,
      ),
    );
  }
}

class _CallCentralButton extends ViewModelWidget<ProfileViewModel> {
  const _CallCentralButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ProfileViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () => !model.isBusy ? model.callCentral() : null,
        child: CustomPaint(
          painter: BoxBorderContainer(),
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset('assets/icons/phone.svg'),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Text(
                    Keys.central.localize(),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff545253)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabBarCustom extends ViewModelWidget<ProfileViewModel> {
  const _TabBarCustom({
    Key key,
    this.height = 30.0,
  }) : super(key: key);
  final double height;

  @override
  Widget build(BuildContext context, ProfileViewModel model) {
    return Container(
      padding: const EdgeInsets.only(top: 4.0),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25.0))),
      child: Column(
        children: <Widget>[
          Container(
            height: height,
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _TabProfile(
                  title: Keys.profile.localize(),
                  onTap: () => model.updateIndex(0),
                  selected: model.currentIndex == 0,
                  icon: 'assets/icons/profile_information.svg',
                ),
                if (model.user.userType == UserType.Driver)
                  _TabProfile(
                    title: Keys.summary.localize(),
                    onTap: () => model.updateIndex(2),
                    selected: model.currentIndex == 2,
                    icon: 'assets/icons/ride_summary.svg',
                  ),
                _TabProfile(
                  title: Keys.record.localize(),
                  onTap: () => model.updateIndex(1),
                  selected: model.currentIndex == 1,
                  icon: 'assets/icons/historial.svg',
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
                width: double.infinity,
                height: 4.0,
                color: const Color(0xffF0F0F0)),
          )
        ],
      ),
    );
  }
}

class _TabProfile extends StatelessWidget {
  const _TabProfile({
    Key key,
    this.onTap,
    @required this.title,
    this.selected = false,
    @required this.icon,
  })  : assert(title != null),
        assert(icon != null),
        super(key: key);

  final VoidCallback onTap;
  final String title;
  final bool selected;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
          onTap: () => onTap(),
          behavior: HitTestBehavior.translucent,
          child: Column(
            children: [
              Expanded(
                child: SvgPicture.asset(icon, height: 50.0),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff545253)),
                ),
              ),
              Container(
                  width: 60.0,
                  height: 2.0,
                  color: selected ? Colors.red : Colors.transparent),
            ],
          )),
    );
  }
}

class ProfileInformationTab extends HookViewModelWidget<ProfileViewModel> {
  ProfileInformationTab({
    Key key,
  }) : super(key: key);
  
  @override
  Widget buildViewModelWidget(BuildContext context, ProfileViewModel model) {
    final phoneController = useTextEditingController(text: model.user.phone);
    final passwordController = useTextEditingController();
    final phoneFocus = useFocusNode();
    final passwordFocus = useFocusNode();

    if (!model.isEditing) {
      return _ProfileInformationField();
    } else {
      return _ProfileInformationFieldEdit(phoneController: phoneController, passwordController: passwordController, phoneFocus: phoneFocus, passwordFocus: passwordFocus);
    }    
  }
}

class _ProfileInformationField extends ViewModelWidget<ProfileViewModel> {
  @override
  Widget build(BuildContext context, ProfileViewModel model) {
    final isDriver = model.user.userType == UserType.Driver;
    return ListView(
      children: [
        if (isDriver)
          Container(
            height: 40.0,
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
            decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Color(0xffF0F0F0), width: 3.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Keys.drive.localize(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 12.0),
                ),
                Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                        onChanged: model.changeDriveStatus,
                        value: model.driveStatus)),
              ],
            ),
          ),
        _InformationField(title: Keys.names.localize(), label: model.user.name),
        _InformationField(
            title: Keys.mobile_phone.localize(), label: model.user.phone),
        _InformationField(
            title: Keys.email.localize(), label: model.user.email),
        if (isDriver)
          _InformationField(
              title: Keys.vehicle.localize(),
              label: model.user.driverInfo.plate),
        _InformationField(title: Keys.password.localize(), label: '*******'),
      ],
    );
  }
}

class _ProfileInformationFieldEdit extends ViewModelWidget<ProfileViewModel> {

  _ProfileInformationFieldEdit({
    @required this.passwordController,
    @required this.phoneFocus,
    @required this.passwordFocus,
    @required this.phoneController});

  final phoneController;
  final passwordController;
  final phoneFocus;
  final passwordFocus;

  @override
  Widget build(BuildContext context, ProfileViewModel model) {
    final isDriver = model.user.userType == UserType.Driver;
    return ListView(
      children: [
        if (isDriver)
          Container(
            height: 40.0,
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
            decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Color(0xffF0F0F0), width: 3.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Keys.drive.localize(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 12.0),
                ),
                Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                        onChanged: model.changeDriveStatus,
                        value: model.driveStatus)),
              ],
            ),
          ),
        _InformationField(title: Keys.names.localize(), label: model.user.name),
        
        Container(
          constraints: const BoxConstraints(minHeight: 40.0),
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
          decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Color(0xffF0F0F0), width: 3.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  Keys.mobile_phone.localize(),
                  style:
                      const TextStyle(fontWeight: FontWeight.w500, fontSize: 12.0),
                ),
              ),
              Expanded(
                child: TextFieldCustom(
                  controller: phoneController,
                  focus: phoneFocus,
                  onChanged: (value) => model.phone = value,
                  labelText: '',
                  nextFocus: passwordFocus,
                  inputFormatters: [LengthLimitingTextInputFormatter(9), FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
        ),

        _InformationField(
            title: Keys.email.localize(), label: model.user.email),
        if (isDriver)
          _InformationField(
              title: Keys.vehicle.localize(),
              label: model.user.driverInfo.plate),
        
        if (model.user.authType.index == AuthType.User.index)
        Container(
          constraints: const BoxConstraints(minHeight: 40.0),
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
          decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Color(0xffF0F0F0), width: 3.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  Keys.password.localize(),
                  style:
                      const TextStyle(fontWeight: FontWeight.w500, fontSize: 12.0),
                ),
              ),
              Expanded(
                child: TextFieldCustom(
                  controller: passwordController,
                  focus: passwordFocus,
                  onChanged: (value) => model.password = value,
                  labelText: '',
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                  keyboardType: TextInputType.text,
                  isFinal: true,
                  isPassword: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InformationField extends StatelessWidget {
  const _InformationField({
    Key key,
    @required this.title,
    @required this.label,
  })  : assert(title != null),
        assert(label != null),
        super(key: key);
  final String title;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 40.0),
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      decoration: const BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Color(0xffF0F0F0), width: 3.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 12.0),
            ),
          ),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.end,
              style: const TextStyle(
                  fontSize: 12.0,
                  color: Color(0xff858585),
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}

class HistorialTab extends ViewModelWidget<ProfileViewModel> {
  @override
  Widget build(BuildContext context, ProfileViewModel model) {
    if (!model.loadingUserHistorial) {
      return ListView(
        children: model.userHistorial
            .map((e) => _HistorialField(
                date: Utils.timestampToDateFormat(
                    e.dateRide.seconds, e.dateRide.nanos, 'dd/MM'),
                price: e.price))
            .toList(),
      );
    } else {
      return Container(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: 50.0,
            height: 50.0,
            child: const CircularProgressIndicator(
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFFA500)),
              strokeWidth: 3,
            ),
          ),
        ),
      );
    }
  }
}

class _HistorialField extends StatelessWidget {
  const _HistorialField({
    Key key,
    @required this.date,
    @required this.price,
  })  : assert(date != null),
        assert(price != null),
        super(key: key);
  final String date;
  final num price;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 40.0),
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      decoration: const BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Color(0xffF0F0F0), width: 3.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                SvgPicture.asset('assets/icons/clock.svg', height: 18.0),
                const SizedBox(width: 5.0),
                Text(
                  date,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 12.0),
                ),
              ],
            ),
          ),
          const Expanded(
            child: Text(
              'S/',
              textAlign: TextAlign.end,
              style: TextStyle(
                  fontSize: 12.0,
                  color: Color(0xff858585),
                  fontWeight: FontWeight.w400),
            ),
          ),
          Container(
            width: 65.0,
            child: Text(
              '${price.toStringAsFixed(2)}',
              textAlign: TextAlign.end,
              style: const TextStyle(
                  fontSize: 12.0,
                  color: Color(0xff858585),
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}

class DriverRecordTab extends ViewModelWidget<ProfileViewModel> {
  @override
  Widget build(BuildContext context, ProfileViewModel model) {
    if (!model.loadingRideSummary) {
      if (model.rideSummaryModel != null) {
        return ListView(
          children: [
            _RideSummaryField(
              title: Keys.ride_summary_day_rides.localize(),
              label: model.rideSummaryModel.dayRides.toString(),
            ),
            _RideSummaryField(
                title: Keys.ride_summary_day_income.localize(),
                label: model.rideSummaryModel.dayIncome.toStringAsFixed(2),
                isCurrency: true),
            _RideSummaryField(
                title: Keys.ride_summary_date_afiliate.localize(),
                label: Utils.timestampToDateFormat(
                    model.rideSummaryModel.dateAfiliate.seconds,
                    model.rideSummaryModel.dateAfiliate.nanos,
                    'dd/MM/yyyy')),
            _RideSummaryField(
              title: Keys.ride_summary_total_rides.localize(),
              label: model.rideSummaryModel.totalRides.toString(),
            ),
            _RideSummaryField(
                title: Keys.ride_summary_total_income.localize(),
                label: model.rideSummaryModel.totalIncome.toStringAsFixed(2),
                isCurrency: true),
          ],
        );
      } else {
        return Container();
      }
    } else {
      return Container(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: 50.0,
            height: 50.0,
            child: const CircularProgressIndicator(
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFFA500)),
              strokeWidth: 3,
            ),
          ),
        ),
      );
    }
  }
}

class _RideSummaryField extends StatelessWidget {
  const _RideSummaryField({
    Key key,
    @required this.title,
    @required this.label,
    this.isCurrency = false,
  })  : assert(title != null),
        assert(label != null),
        super(key: key);
  final String title;
  final String label;
  final bool isCurrency;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 40.0),
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      decoration: const BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Color(0xffF0F0F0), width: 3.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 12.0),
            ),
          ),
          if (isCurrency)
            const Expanded(
              child: Text(
                'S/',
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontSize: 12.0,
                    color: Color(0xff858585),
                    fontWeight: FontWeight.w400),
              ),
            ),
          Container(
            width: 100.0,
            child: Text(
              label,
              textAlign: TextAlign.end,
              style: const TextStyle(
                  fontSize: 12.0,
                  color: Color(0xff858585),
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueButton extends ViewModelWidget<ProfileViewModel> {
  const _ContinueButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ProfileViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .18),
      height: 50,
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: PalleteColor.actionButtonColor,
        disabledColor: PalleteColor.actionButtonColor.withOpacity(0.5),
        child: Text(Keys.continue_label.localize(), style: const TextStyle(color: Colors.white, fontSize: 16)),
        onPressed: !model.enableBtnContinue ? null : () => !model.isBusy ? model.saveProfileInformation() : null,
      ),
    );
  }
}