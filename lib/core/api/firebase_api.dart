import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:googleapis_auth/auth_io.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Handling a background message: ${message.messageId}");
}

class FirebaseApi {
  final _firebaseMessage = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static String? userToken;
  static String? adminToken;

  Future<void> initNotification() async {

    try {
      final adminDoc = await FirebaseFirestore.instance
          .collection('admins')
          .doc('a.ali2672@su.edu.eg')
          .get();
      adminToken = adminDoc.data()?['fcmToken'];
    } catch (e) {
      log('Error fetching admin token: $e');
    }


    await _firebaseMessage.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );


    await _initLocalNotification();


    userToken = await _firebaseMessage.getToken();
    log('🚀 Your FCM Token: $userToken');
    log('👑 Admin Token: $adminToken');


    _initPushNotification();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Foreground message received: ${message.data}');
      showNotification(message);
    });
  }

  void _initPushNotification() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) log('App opened from initial message: ${message.data}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log('Notification opened app: ${message.data}');
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _initLocalNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');


    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log('Notification clicked with payload: ${response.payload}');
      },
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'high_importance_channel', 
      'High Importance Notifications', 
      channelDescription: 'Used for Zid store alerts',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      id: message.hashCode,
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? '',
      notificationDetails: platformChannelSpecifics,
      payload: message.data.toString(),
    );
  }
}


class FcmSender {
  final String _projectId;
  late AutoRefreshingAuthClient _client;

  FcmSender(this._projectId);

  Future<void> init() async {
    final accountCredentials = ServiceAccountCredentials.fromJson(
      await _readServiceAccountFromAssets(),
    );
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    _client = await clientViaServiceAccount(accountCredentials, scopes);
  }

  Future<bool> sendNotification({
    required String deviceToken,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    final url = 'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send';

    final message = {
      "message": {
        "token": deviceToken,
        "notification": {"title": title, "body": body},
        if (data != null) "data": data,
      },
    };

    final response = await _client.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      log('Notification sent successfully!');
      return true;
    } else {
      log('Failed to send notification: ${response.body}');
      return false;
    }
  }

  Future<Map<String, dynamic>> _readServiceAccountFromAssets() async {

    final jsonStr = await rootBundle.loadString('assets/service-account.json');
    return jsonDecode(jsonStr);
  }

  void close() => _client.close();
}
