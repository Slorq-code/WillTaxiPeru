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
    var settings = await _fcm.requestNotificationPermissions(
        const IosNotificationSettings(
            alert: true, sound: true, badge: true, provisional: false));

    await _saveDeviceToken();
    _handleNotificationData = handleNotificationData;
    _fcm.configure(
      onMessage: handleOnMessage,
      onLaunch: handleOnLaunch,
      onResume: handleOnResume,
    );
  }

  Future<String> getTokenFCM() async {
    return await _secureStorage.getString('tokenFCM');
  }

  void _saveDeviceToken() async {
    var token = await _secureStorage.getString('tokenFCM');
    if (token == null) {
      var deviceToken = await _fcm.getToken();
      print(deviceToken);
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
