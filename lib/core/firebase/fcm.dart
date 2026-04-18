import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import '../../di.dart';
import '../api/prefs_helper.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

@lazySingleton
class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final prefs = getIt<PrefsHelper>();

  Future<void> initNotification() async {

    await _fcm.requestPermission(alert: true, badge: true, sound: true);
    _fcm.onTokenRefresh.listen((newToken) async {
      print("🔄 FCM Token Refreshed: $newToken");
      await sendTokenToServer(newToken);
    });




    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'orders_channel',
      'تنبيهات الطلبات',
      description: 'تستخدم لإشعارات الطلبات الجديدة وتحديثات المخزون',
      importance: Importance.max,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);


    String? token = await _fcm.getToken();
    if (token != null) {
      print("🚀 Your FCM Token: $token");

      await retryTokenSync();
    }


    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message received in foreground: ${message.notification?.title}");
      _showLocalNotification(message);
    });
  }





  Future<void> retryTokenSync() async {
    try {


      await _fcm.deleteToken();


      String? freshToken = await _fcm.getToken();

      if (freshToken != null) {
        print("🚀 Fresh Token for Sync: $freshToken");


        await sendTokenToServer(freshToken);


        await autoRegisterAllZidWebhooks();
      }
    } catch (e) {
      print("❌ Error during retryTokenSync: $e");
    }
  } Future<void> autoRegisterAllZidWebhooks() async {
    try {
       final accessToken = prefs.getAccessToken(); // ده الـ Access Token بتاع المتجر


      if (accessToken == null) return;
       final url = Uri.parse('https://api.zid.sa/v1/managers/webhooks');

       const myVercelUrl = 'https://zid-backend-vercel.vercel.app/api/zid-webhook';

       final events = ["order.create", "order.status.update", "product.update"];
      for (var event in events) {
        final response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer ${prefs.getManagerToken()}', // حط هنا الـ Partner Token بتاعك
            'X-Manager-Token': accessToken,
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Accept-Language': 'ar',
          },
          body: jsonEncode({
            "event": event,
            "target_url": myVercelUrl, // زيد بتسميها target_url مش url
            "original_id": "2404", // حط هنا الـ App ID بتاعك من لوحة تحكم مطوري زيد
          }),
        );
        print("Webhook sync for $event: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("⚠️ Webhook Registration Error: $e");
    }
  }
  Future<void> sendTokenToServer(String token) async {
    final url = Uri.parse('https://zid-backend-vercel.vercel.app/api/save-token');
    String? realStoreId;
    try {
      realStoreId = getIt<PrefsHelper>().getStoreId();
    } catch (e) {
      print("⚠️ DI or Prefs not ready yet");
    }

    if (realStoreId == null || realStoreId.isEmpty) {
      print("ℹ️ Token sync skipped: No Store ID found in Prefs.");
      return;
    }

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'store_id': realStoreId,
          'fcmToken': token,
        }),
      );

      if (response.statusCode == 200) {
        print("✅ Token Synced for Store: $realStoreId");
      } else {
        print("❌ Server rejected token: ${response.body}");
      }
    } catch (e) {
      print("❌ Error sending token to server: $e");
    }
  }

  void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
    id:   notification.hashCode,
    title:   notification.title,
    body:   notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'orders_channel',
          'تنبيهات الطلبات',
          importance: Importance.max,
          priority: Priority.high,
          icon: 'ic_stat_brand_identity_section', // تأكد إن الأيقونة دي موجودة في drawable
          channelShowBadge: true,
        ),
      ),
    );
  }
}
