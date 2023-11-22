import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

class FirebaseMessagingService {
  factory FirebaseMessagingService() {
    return _instance;
  }

  FirebaseMessagingService._internal();

  late NavigatorState navigator;

  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();

  static FirebaseMessagingService get instance => _instance;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize(NavigatorState nav) async {
    navigator = nav;
    await _checkInitialMessage();
    if (!kIsWeb) {
      await _firebaseMessaging.requestPermission();

      FirebaseMessaging.onMessage.listen(_handleMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      final fcm = await _firebaseMessaging.getToken();
      print(fcm);

      await _setupLocalNotifications();
    }
  }

  Future<void> _checkInitialMessage() async {
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print(initialMessage.data);
    }
  }

  Stream<String> onRefreshToken() {
    return FirebaseMessaging.instance.onTokenRefresh;
  }

  Future<void> _handleMessageTap(RemoteMessage message) async {
    // await navigator.push(
    //   MaterialPageRoute<void>(
    //     builder: (context) => const MainMenuPage(),
    //   ),
    // );
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    final payload = NotificationPayload.fromMap(message.data);

    switch (payload.type) {
      case 'textNoti':
        await _handleTextNotification(payload, message.notification);
      default:
        await _handleDefaultNotification(message.notification);
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  Future<void> _setupLocalNotifications() async {
    const androidInitializationSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher'); // Make sure to have a proper icon

    const iOSInitializationSettings = DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> _handleTextNotification(
    NotificationPayload payload,
    RemoteNotification? notification,
  ) async {
    //
  }

  Future<void> _handleDefaultNotification(
      RemoteNotification? notification) async {
    if (notification != null && !kIsWeb) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        platformChannelSpecifics,
      );
    }
  }
}

class NotificationPayload {
  NotificationPayload({this.type, this.image});

  factory NotificationPayload.fromMap(Map<String, dynamic> data) {
    return NotificationPayload(
      type: data['type']?.toString(),
      image: data['image'].toString(),
    );
  }

  final String? type;
  final String? image;
}
