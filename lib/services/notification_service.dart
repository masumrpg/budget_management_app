import 'dart:async';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            macOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);

    await _notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) {});

    // Request permissions for Android 13+
    _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    tz_data.initializeTimeZones();
  }

  static Future<void> showNotification(String title, String body) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'budget_channel',
        'Budget Notifications',
        channelDescription: 'Notifications for budget updates',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker'),
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
      linux: LinuxNotificationDetails(),
    );
    await _notificationsPlugin.show(0, title, body, notificationDetails);
  }

  static Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      // Desktop platforms often don't support zonedSchedule well in this plugin.
      // We implement a simple Timer check for the active session.
      // Note: This only works while the app is running.
      _scheduleTimerBasedNotification(id, title, body, hour, minute);
      return;
    }

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_budget_channel',
          'Daily Budget Reminders',
          channelDescription: 'Daily reminders for budget input',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
        // macOS: DarwinNotificationDetails(), // Handled in desktop block above
        // linux: LinuxNotificationDetails(), // Handled in desktop block above
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // uiLocalNotificationDateInterpretation:
      //     UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static void _scheduleTimerBasedNotification(
      int id, String title, String body, int hour, int minute) {
    // Calculate duration until next occurrence
    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    final timeUntil = scheduledDate.difference(now);

    Timer(timeUntil, () async {
      await showNotification(title, body);
      // Reschedule for next day?
      // For a simple session-based approach, we might stop here or loop.
      // Real desktop background scheduling requires specific OS tools (cron/Task Scheduler).
      // Here we just ensure it fires if the app is open.
      _scheduleTimerBasedNotification(id, title, body, hour, minute);
    });
  }

  static Future<void> scheduleEveryMinuteTest({
    required int id,
    required String title,
    required String body,
  }) async {
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
        Timer.periodic(const Duration(minutes: 1), (timer) async {
            await showNotification(title, body);
        });
        return;
    }

    // Schedules a notification to repeat every minute
    await _notificationsPlugin.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.everyMinute,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test Notifications',
          channelDescription: 'Test notifications every minute',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
        // macOS: DarwinNotificationDetails(),
        // linux: LinuxNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
