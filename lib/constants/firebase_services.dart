import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await FirebaseApi.handleBackgroundMessage(message);
}

class FirebaseApi {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final box = GetStorage();
  String token = '';

  static final FlutterLocalNotificationsPlugin localNotifications =
      FlutterLocalNotificationsPlugin();

  static const String _badgeKey = 'badge_count';
  static const String _channelId = 'desalite_connect_app';
  static const int _apnsMaxAttempts = 8;
  static const Duration _apnsRetryDelay = Duration(milliseconds: 700);

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        _channelId,
        'Desalite Notifications',
        description: 'Important notifications',
        importance: Importance.high,
        showBadge: true,
      );

  // ---------------- INIT ----------------
  Future<void> initNotifications() async {
    await _requestPermission();
    // iOS: Ensure alerts/sounds/badge are shown in foreground
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _listenForTokenRefresh();

    String? apnsToken;
    if (_isAppleMessagingPlatform) {
      // On Apple platforms, APNs registration can arrive a little later.
      apnsToken = await getAPNSToken(waitForAvailability: true);
    }

    final shouldFetchFcmNow = !_isAppleMessagingPlatform || apnsToken != null;
    if (shouldFetchFcmNow) {
      await _fetchAndStoreFcmToken();
    } else {
      log(
        'Skipping immediate FCM token fetch because APNs token is still unavailable.',
      );
    }

    await _initLocalNotifications();

    FirebaseMessaging.onMessage.listen(_onForeground);
    FirebaseMessaging.onMessageOpenedApp.listen(_onOpened);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    box.writeIfNull(_badgeKey, 0);
  }

  // ---------------- PERMISSIONS ----------------
  Future<void> _requestPermission() async {
    await _fcm.requestPermission(alert: true, badge: true, sound: true);
  }

  Future<String?> getAPNSToken({bool waitForAvailability = false}) async {
    try {
      final String? apnsToken = waitForAvailability
          ? await _waitForAPNSToken()
          : await _fcm.getAPNSToken();
      log('APNs Token: $apnsToken');
      if (apnsToken != null) {
        box.write('APNsToken', apnsToken);
      } else {
        log('Failed to retrieve APNs Token');
      }
      return apnsToken;
    } catch (e) {
      log('Error retrieving APNs Token: $e');
      return null;
    }
  }

  Future<void> _fetchAndStoreFcmToken() async {
    try {
      final String? firebaseToken = await _fcm.getToken();

      if (firebaseToken != null && firebaseToken.isNotEmpty) {
        box.write('Token', firebaseToken);
        token = firebaseToken;
        log('FCM token retrieved successfully.');
      } else {
        log('Failed to retrieve FCM token.');
      }

      log('FCM token: $firebaseToken');
    } on FirebaseException catch (e, st) {
      if (e.code == 'apns-token-not-set') {
        log('FCM token unavailable: APNs token is not set yet.');
        return;
      }
      log('Error retrieving FCM token: $e', stackTrace: st);
    } catch (e, st) {
      log('Error retrieving FCM token: $e', stackTrace: st);
    }
  }

  Future<String?> _waitForAPNSToken() async {
    for (int attempt = 1; attempt <= _apnsMaxAttempts; attempt++) {
      final apnsToken = await _fcm.getAPNSToken();
      if (apnsToken != null && apnsToken.isNotEmpty) {
        return apnsToken;
      }

      if (attempt < _apnsMaxAttempts) {
        await Future.delayed(_apnsRetryDelay);
      }
    }
    return null;
  }

  bool get _isAppleMessagingPlatform {
    return !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS);
  }

  void _listenForTokenRefresh() {
    _fcm.onTokenRefresh.listen(
      (newToken) {
        if (newToken.isEmpty) return;
        box.write('Token', newToken);
        token = newToken;
        log('FCM token refreshed: $newToken');
      },
      onError: (Object error, StackTrace stackTrace) {
        log('FCM token refresh listener error: $error', stackTrace: stackTrace);
      },
    );
  }

  // ---------------- LOCAL NOTIFICATION ----------------
  Future<void> _initLocalNotifications() async {
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await localNotifications.initialize(settings: initSettings);

    await localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);
  }

  // ---------------- BADGE STATE ----------------
  int _incrementBadge() {
    final count = (box.read(_badgeKey) ?? 0) + 1;
    box.write(_badgeKey, count);
    return count;
  }

  void clearBadge() {
    box.write(_badgeKey, 0);
  }

  // ---------------- FOREGROUND ----------------
  Future<void> _onForeground(RemoteMessage message) async {
    final badge = _incrementBadge();
    bool isEnabled = box.read("pushNotifications") ?? true;

    if (!isEnabled) {
      log('Background notification blocked (disabled)');
      return;
    }

    await localNotifications.show(
      id: message.hashCode,
      title: message.notification?.title,
      body: message.notification?.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'Desalite Notifications',
          importance: Importance.high,
          priority: Priority.high,
          number: badge, // Android launcher badge
        ),
        iOS: DarwinNotificationDetails(
          badgeNumber: badge, // iOS badge
          presentBadge: true,
          presentAlert: true,
        ),
      ),
    );
  }

  // ---------------- BACKGROUND ----------------
  @pragma('vm:entry-point')
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    final box = GetStorage();
    final isEnabled = box.read("pushNotifications") ?? true;

    if (!isEnabled) {
      log('Background notification blocked (disabled)');
      return;
    }
    final badge = (box.read(_badgeKey) ?? 0) + 1;
    box.write(_badgeKey, badge);
  }

  // ---------------- OPEN ----------------
  void _onOpened(RemoteMessage message) {
    clearBadge(); // Reset when user opens notification
  }
}
