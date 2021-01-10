import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';

class Utils {
  static NumberFormat _numberFormatter;
  static DateFormat _dateFormatter;

  static NumberFormat get numberFormatter {
    if (_numberFormatter != null) {
      return _numberFormatter;
    }
    _numberFormatter = NumberFormat();
    return _numberFormatter;
  }

  static DateFormat get dateFormatter {
    if (_dateFormatter != null) {
      return _dateFormatter;
    }
    _dateFormatter = DateFormat('d MMM, HH:mm');

    return _dateFormatter;
  }

  static void showToast(BuildContext context, String msg, {int duration = 5, Color color = const Color(0xFFe74c3c)}) {
    Toast.show(msg, context, duration: duration, gravity: Toast.BOTTOM, backgroundColor: color);
  }

  static int calculateAge(DateTime birthDate) {
    var currentDate = DateTime.now();
    var age = currentDate.year - birthDate.year;
    var month1 = currentDate.month;
    var month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      var day1 = currentDate.day;
      var day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  static SplayTreeMap orderMap({@required Map map, List<String> eliminateFields}) {
    eliminateFields.forEach((element) {
      map.removeWhere((key, value) => key == element);
    });

    return SplayTreeMap.from(map, (a, b) => a.compareTo(b));
  }

  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(4, 10), radix: 16) + 0xFF000000);
  }

  static bool isNullOrEmpty(String value) {
    if (value == null || value.trim().isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  static bool isValidPasswordLength(String password) {
    return (password.trim().length > 7 && password.trim().length < 21);
  }

  static Future<PackageInfo> getPackageInfo() async {
    return await PackageInfo.fromPlatform();
  }

  static bool isValidPhone(String phone) {
    return RegExp(r'^[0-9]{9}$').hasMatch(phone);
  }

  static String getNameInitials(String name) {
    var nameInitials = '';
    try {
      final nameComponents = name.trim().split(' ');
      switch (nameComponents.length) {
        case 1:
          nameInitials = nameComponents.first[0];
          break;
        case 2:
        case 3:
          nameInitials = nameComponents[0].characters.first + nameComponents[1].characters.first;
          break;
        case 4:
          nameInitials = nameComponents[0].characters.first + nameComponents[2].characters.first;
          break;
        default:
          nameInitials = nameComponents.first[0];
      }
    } catch (e) {
      nameInitials = '';
    }
    return nameInitials;
  }

  static void shareText(String title, content) {
    Share.text(title, content, 'text/plain');
  }

  static String timestampToDateFormat(int seconds, int nano, String dateFormat) {
    var timestamp = Timestamp(seconds, nano);
    var df = DateFormat(dateFormat);
    return df.format(timestamp.toDate());
  }
}
