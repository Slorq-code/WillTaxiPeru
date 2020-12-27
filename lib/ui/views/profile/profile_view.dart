import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:morpheus/widgets/morpheus_tab_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

import 'package:taxiapp/models/enums/user_type.dart';
import 'package:taxiapp/theme/pallete_color.dart';
import 'package:taxiapp/ui/views/profile/profile_viewmodel.dart';
import 'package:taxiapp/ui/widgets/box_border_container.dart';
import 'package:taxiapp/ui/widgets/buttons/action_button_custom.dart';
import 'package:taxiapp/ui/widgets/buttons/platform_back_button.dart';
import 'package:taxiapp/utils/network_image.dart';

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
            backgroundColor: PalleteColor.backgroundColor,
            iconTheme: const IconThemeData(color: Colors.black),
            leading: PlatformBackButton(
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              FlatButton(
                onPressed: () => {},
                child: const Text(
                  'Editar', // TODO : translate
                  style: TextStyle(color: Color(0xff017DFF), fontSize: 15.0),
                ),
              )
            ],
          ),
          backgroundColor: PalleteColor.backgroundColor,
          body: _BodyProfile(),
        ),
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
        const _AvatarProfile(),
        const _BoxInformation(),
        const _CallCentralButton(),
        const _LogoutButton(),
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
        padding: const EdgeInsets.all(8.0),
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

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 80.0),
      child: ActionButtonCustom(
        action: () {},
        label: 'Cerrar Sesion', // TODO : translate
        fontSize: 20,
      ),
    );
  }
}

class _CallCentralButton extends StatelessWidget {
  const _CallCentralButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: CustomPaint(
        painter: BoxBorderContainer(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset('assets/icons/phone.svg'),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Text(
                  'Central',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xff545253)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarProfile extends ViewModelWidget<ProfileViewModel> {
  const _AvatarProfile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ProfileViewModel model) {
    return Column(
      children: [
        Hero(
          tag: model.user.uid,
          child: Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            child: ClipOval(
              child: Stack(
                children: [
                  model.user.image != null && model.user.image.isNotEmpty
                      ? PNetworkImage(
                          model.user.image,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.red,
                          height: 100,
                          width: 100,
                          alignment: Alignment.center,
                          child: Text(model.getNameInitials(), style: const TextStyle(fontSize: 40.0, color: Colors.white)),
                        ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 25,
                      width: 100,
                      color: Colors.black,
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            model.user.name,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      ],
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
      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25.0))),
      child: Column(
        children: <Widget>[
          Container(
            height: height,
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _TabProfile(
                  title: 'Perfil', // TODO: translate
                  onTap: () => model.updateIndex(0),
                  selected: model.currentIndex == 0,
                  icon: SvgPicture.asset('assets/icons/information.svg', height: 17),
                  backgroundColor: const Color(0xff017DFF),
                ),
                _TabProfile(
                  title: 'Historial', // TODO: translate
                  onTap: () => model.updateIndex(1),
                  selected: model.currentIndex == 1,
                  icon: const Icon(Icons.access_time, size: 30, color: Colors.white),
                  backgroundColor: const Color(0xff4CCEB1),
                ),
                if (model.user.userType == UserType.Driver)
                  _TabProfile(
                    title: 'Drive', //TODO: Translate
                    onTap: () => model.updateIndex(2),
                    selected: model.currentIndex == 2,
                    icon: const Icon(Icons.drive_eta, size: 30, color: Colors.white),
                    backgroundColor: const Color(0xff017DFF),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(width: double.infinity, height: 4.0, color: const Color(0xffF0F0F0)),
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
    @required this.backgroundColor,
    this.selected = false,
    @required this.icon,
  })  : assert(title != null),
        assert(backgroundColor != null),
        assert(icon != null),
        super(key: key);

  final VoidCallback onTap;
  final String title;
  final Color backgroundColor;
  final bool selected;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
          onTap: () => onTap(),
          behavior: HitTestBehavior.translucent,
          child: Column(
            children: [
              Expanded(
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: backgroundColor,
                  child: icon,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff545253)),
                ),
              ),
              Container(width: 60.0, height: 2.0, color: selected ? Colors.red : Colors.transparent),
            ],
          )),
    );
  }
}

class ProfileInformationTab extends ViewModelWidget<ProfileViewModel> {
  @override
  Widget build(BuildContext context, ProfileViewModel model) {
    final isDriver = model.user.userType != UserType.Driver;
    return ListView(
      children: [
        if (isDriver)
          Container(
            height: 40.0,
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffF0F0F0), width: 3.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Conducir',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0),
                ),
                Container(child: CupertinoSwitch(onChanged: model.changeDriveStatus, value: model.driveStatus)),
              ],
            ),
          ),
        _InformationField(title: 'Nombres', label: model.user.name), // TODO: translate
        const _InformationField(title: 'Fecha de nacimiento', label: '01/01/1990'), // TODO: translate
        _InformationField(title: 'Teléfono móvil', label: model.user.phone), // TODO: translate
        _InformationField(title: 'Email', label: model.user.email), // TODO: translate
        if (isDriver) const _InformationField(title: 'Vehículo', label: 'Toyota Corolla, 2006, XYZ-123'), // TODO: translate
        const _InformationField(title: 'Contraseña', label: '*******'), // TODO: translate
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
        border: Border(bottom: BorderSide(color: Color(0xffF0F0F0), width: 3.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0),
            ),
          ),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 14.0, color: Color(0xff858585), fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class HistorialTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        //TODO: complete with api
        const _HistorialField(date: '23/01', price: 9.9),
        const _HistorialField(date: '23/01', price: 9.9),
        const _HistorialField(date: '23/01', price: 9.9),
        const _HistorialField(date: '23/01', price: 9.9),
        const _HistorialField(date: '23/01', price: 9.9),
        const _HistorialField(date: '23/01', price: 9.9),
        const _HistorialField(date: '23/01', price: 9.9),
        const _HistorialField(date: '23/01', price: 9.9),
        const _HistorialField(date: '23/01', price: 9.9),
        const _HistorialField(date: '23/01', price: 9.9),
        const _HistorialField(date: '23/01', price: 9.9),
      ],
    );
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
  final double price;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 40.0),
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xffF0F0F0), width: 3.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.access_time, color: Colors.black, size: 20),
                const SizedBox(width: 5.0),
                Text(
                  date,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              '\$ ${price.toStringAsFixed(2)}',
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 14.0, color: Color(0xff858585), fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class DriverRecordTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
