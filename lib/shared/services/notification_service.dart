import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    final tzInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(tzInfo.identifier));
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);
    _initialized = true;
  }

  Future<bool> requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final granted = await android?.requestNotificationsPermission();
    return granted ?? false;
  }

  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    await _plugin.cancel(0);
    await _plugin.zonedSchedule(
      0,
      '¿Cómo vas con tus hábitos hoy? 🌿',
      'Recuerda registrar tus hábitos en Eira.',
      _nextInstanceOf(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Recordatorio diario',
          channelDescription: 'Recordatorio para registrar hábitos',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  Future<void> cancelDailyReminder() async {
    await _plugin.cancel(0);
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  Future<void> showTestNotification() async {
    await _plugin.show(
      99,
      '¡Notificaciones activadas! 🎉',
      'Eira te recordará cuidarte cada día.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Prueba',
          channelDescription: 'Canal de prueba',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }
}
