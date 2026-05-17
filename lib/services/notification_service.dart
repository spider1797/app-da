import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Background message handler — must be a top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('📩 Background message: ${message.messageId}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'appda_alerts',
    'App-da Alerts',
    description: 'Disaster alerts and drill notifications',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  /// Call once in main.dart after Firebase.initializeApp()
  Future<void> initialize() async {
    // Register background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Request permissions
    final permSettings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: true,
    );
    debugPrint('🔔 Permission: ${permSettings.authorizationStatus}');

    // Create Android notification channel
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // v21 API: initialize() uses ALL named params — `settings:` is required
    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        debugPrint('🔔 Notification tapped: ${details.payload}');
      },
    );

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Log FCM token
    final token = await _messaging.getToken();
    debugPrint('📱 FCM Token: $token');
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    final android = message.notification?.android;
    if (notification != null && android != null) {
      // v21 API: show() uses ALL named params — `id:` is required
      _localNotifications.show(
        id: notification.hashCode,
        title: notification.title ?? '',
        body: notification.body ?? '',
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: message.data['route'],
      );
    }
  }

  /// Subscribe to a topic (e.g., school code)
  Future<void> subscribeToTopic(String topic) async {
    final sanitized = topic.replaceAll(RegExp(r'[^a-zA-Z0-9\-_]'), '_');
    await _messaging.subscribeToTopic(sanitized);
    debugPrint('✅ Subscribed to topic: $sanitized');
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    final sanitized = topic.replaceAll(RegExp(r'[^a-zA-Z0-9\-_]'), '_');
    await _messaging.unsubscribeFromTopic(sanitized);
    debugPrint('🔕 Unsubscribed from topic: $sanitized');
  }

  /// Get current FCM device token
  Future<String?> getToken() => _messaging.getToken();
}
