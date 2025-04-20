import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class Notifications {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> initNotifications() async {
    try {
      await _firebaseMessaging.requestPermission();

      final token = await _firebaseMessaging.getToken();

      return token;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<void> initPushNotification() async {}
}
