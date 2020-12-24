import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:taxiapp/localization/keys.dart';
import 'package:taxiapp/extensions/string_extension.dart';
import 'package:taxiapp/theme/pallete_color.dart';
import 'package:taxiapp/utils/spin_loading_indicator.dart';

typedef OnListSelect = void Function(String item);

class Alert {
  final BuildContext context;
  final String title;
  final String label;
  final String hint;
  final TextEditingController value;
  final VoidCallback action;
  final OnListSelect listSelect;
  Alert({this.context, this.listSelect, this.title, this.label, this.hint, this.value, this.action});

  void input() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
          title: Text(title, style: const TextStyle(color: Colors.orange)),
          content: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                    keyboardType: TextInputType.phone,
                    controller: value,
                    maxLength: 6,
                    autofocus: true,
                    decoration: InputDecoration(labelText: label, hintText: hint)),
              )
            ],
          ),
          actions: <Widget>[
            Center(
                child: FlatButton(
                    child: Text(Keys.accept.localize(), style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                    onPressed: action)),
          ],
        );
      },
    );
  }

  void loading(String message, {bool isBlocked = true}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => !isBlocked,
          child: AlertDialog(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
              content: Row(mainAxisSize: MainAxisSize.min, children: [
                const SizedBox(
                  child: SpinLoadingIndicator(),
                  height: 30.0,
                  width: 30.0,
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(message, textAlign: TextAlign.center),
                  ),
                )
              ])),
        );
      },
    );
  }

  void alertMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
            title: Center(child: Text(title, style: const TextStyle(color: PalleteColor.titleTextColor, fontWeight: FontWeight.bold))),
            content: Text(
              label,
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              Center(
                child: FlatButton(
                    child: Text(Keys.accept.localize(), style: const TextStyle(color: PalleteColor.titleTextColor, fontWeight: FontWeight.bold)),
                    onPressed: () => ExtendedNavigator.root.pop()),
              ),
            ]);
      },
    );
  }

  void alertCallBack(VoidCallback action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
            title: Center(child: Text(title, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))),
            content: Text(
              label,
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              Center(
                child: FlatButton(
                    child: Text(Keys.accept.localize(), style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      action();
                    }),
              )
            ]);
      },
    );
  }

  void logout(VoidCallback action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
            title: Center(child: Text(title, style: const TextStyle(color: Colors.orange, fontSize: 18.0, fontWeight: FontWeight.bold))),
            content: Text(
              label,
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text(Keys.cancel.localize(), style: const TextStyle(color: Colors.orange)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              FlatButton(
                  child: Text(Keys.accept.localize(), style: const TextStyle(color: Colors.orange)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    action();
                  })
            ]);
      },
    );
  }

  void errorNextDocument(action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
            title: Text(title, style: const TextStyle(color: Colors.orange)),
            content: Text(
              label,
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              FlatButton(child: Text(Keys.accept.localize(), style: const TextStyle(color: Colors.orange)), onPressed: action),
            ]);
      },
    );
  }

  Future<bool> confirmation(String cancel, String actionText) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
          title: Center(child: Text(title, style: const TextStyle(color: Colors.orange))),
          content: Text(
            label,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            FlatButton(
                child: Text(cancel, style: const TextStyle(color: Colors.orange)),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            FlatButton(child: Text(actionText, style: const TextStyle(color: Colors.orange)), onPressed: action)
          ],
        );
      },
    );
  }

  void list(List<dynamic> values, TextEditingController p) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
          title: Text(title, style: const TextStyle(color: Colors.orange)),
          content: ListView.builder(
              shrinkWrap: true,
              itemCount: values.length,
              itemBuilder: (BuildContext buildContext, int index) {
                return GestureDetector(
                  child: Padding(padding: const EdgeInsets.all(10.0), child: Text(values[index])),
                  onTap: () {
                    listSelect(values[index]);
                  },
                );
              }),
        );
      },
    );
  }

  void errorWithoutDismissible() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
              title: Center(child: Text(title, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))),
              content: Text(
                label,
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                Center(
                  child: FlatButton(
                    child: Text(Keys.accept.localize(), style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                    onPressed: action,
                  ),
                ),
              ]),
        );
      },
    );
  }
}
