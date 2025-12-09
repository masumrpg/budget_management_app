import 'package:flutter/material.dart';

class NotificationService {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static Future<void> init() async {
    // No initialization needed for simple SnackBars
  }

  static Future<void> showNotification(String title, String body) async {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(body),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
      ),
    );
  }

  static Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    // Scheduled notifications are not supported with SnackBars/Toasts
    // We could implement a simple in-memory timer, but it only works while app is open.
    // For now, we will just log or ignore.
    debugPrint(
      'Scheduled notification requested: $title (Not supported in Toast mode)',
    );
  }

  static Future<void> scheduleEveryMinuteTest({
    required int id,
    required String title,
    required String body,
  }) async {
    // Not supported in Toast mode
  }
}
