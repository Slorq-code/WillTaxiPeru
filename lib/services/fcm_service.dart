import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/services/secure_storage_service.dart';

@lazySingleton
class FCMService {
  final _fcm = FirebaseMessaging();
  final SecureStorage _secureStorage = locator<SecureStorage>();
  Function _handleNotificationData;

  Future<void> initializeFCM(Function handleNotificationData) async {
    _saveDeviceToken();
    _handleNotificationData = handleNotificationData;
    _fcm.configure(
      onMessage: handleOnMessage,
      onLaunch: handleOnLaunch,
      onResume: handleOnResume,
    );
  }

  void _saveDeviceToken() async {
    if (_secureStorage.getString('tokenFCM') == null) {
      var deviceToken = await _fcm.getToken();
      await _secureStorage.save('tokenFCM', deviceToken);
    }
  }

  Future handleOnMessage(Map<String, dynamic> data) async {
    _handleNotificationData(data);
  }

  Future handleOnLaunch(Map<String, dynamic> data) async {
    _handleNotificationData(data);
  }

  Future handleOnResume(Map<String, dynamic> data) async {
    _handleNotificationData(data);
  }
}
