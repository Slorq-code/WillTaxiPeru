import 'package:injectable/injectable.dart';
import 'package:taxiapp/app/locator.dart';

import 'storage_service.dart';

@lazySingleton
class Token {

  final shared = locator<Storage>();
  
  Future<Map<String, String>> buildHeaders() async {
    var token = await shared.getString('token');
    return {'Content-Type': 'application/json', 'Accept': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Future<void> saveToken(String value) => shared.saveString('token', value);

  void deleteToken() {
    shared.deleteString('token');
  }

  Future<bool> hasToken() async {
    if (await shared.getString('token') != null) return true;
    return false;
  }

}
