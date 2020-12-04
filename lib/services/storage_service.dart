import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class Storage {
  Future<void> saveString(key, value) async {
    var pref = await SharedPreferences.getInstance();
    await pref.setString(key, value);
  }

  Future<void> saveBool(key, value) async {
    var pref = await SharedPreferences.getInstance();
    await pref.setBool(key, value);
  }

  Future<void> deleteString(key) async {
    var pref = await SharedPreferences.getInstance();
    await pref.remove(key);
  }

  Future<void> deleteBool(key) async {
    var pref = await SharedPreferences.getInstance();
    await pref.remove(key);
  }

  Future<String> getString(key) async {
    var pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }

  Future<bool> getBool(key) async {
    var pref = await SharedPreferences.getInstance();
    return pref.getBool(key) ?? false;
  }
}
