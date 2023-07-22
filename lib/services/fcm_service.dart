import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/services/secure_storage_service.dart';

@lazySingleton
class FCMService {
  final _fcm = FirebaseMessaging();
  final SecureStorage _secureStorage = locator<SecureStorage>();

  final StreamController<String> _messageStreamController =
      StreamController.broadcast();

  Function _handleNotificationData;

  Future<void> initializeFCM(Function handleNotificationData) async {
    // configuracion IOS inexistente

    // final settings = await _fcm.requestNotificationPermissions(
    //     const IosNotificationSettings(
    //         alert: true, sound: true, badge: true, provisional: false));

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
    final title = data['notification']['title'] ?? 'Notificación';
    final body = data['notification']['body'] ?? 'Cuerpo de la notificación';

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettings =
        const InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your_channel_id', 'Your Channel Name', 'Your Channel Description',
        importance: Importance.max, priority: Priority.high);
    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );

    // Luego de mostrar la alerta, llamamos a la función que maneja la notificación.
    _handleNotificationData(data);
  }

  Future handleOnResume(Map<String, dynamic> data) async {
    _handleNotificationData(data);
  }

  claseStreams() => {_messageStreamController.close()};
}
