import 'package:flutter/material.dart';
import '../../shared/services/preferences_service.dart';
import '../../shared/services/notification_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _prefs = PreferencesService();
  final _notifications = NotificationService();

  bool _enabled = false;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final settings = await _prefs.getNotificationSettings();
    setState(() {
      _enabled = settings['enabled'] as bool;
      _selectedTime = TimeOfDay(
        hour: settings['hour'] as int,
        minute: settings['minute'] as int,
      );
      _loading = false;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    if (value) {
      final granted = await _notifications.requestPermission();
      if (!granted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Necesitas permitir notificaciones en los ajustes del sistema.',
            ),
          ),
        );
        return;
      }
      await _notifications.scheduleDailyReminder(
        hour: _selectedTime.hour,
        minute: _selectedTime.minute,
      );
      await _notifications.showTestNotification();
    } else {
      await _notifications.cancelDailyReminder();
    }

    await _prefs.saveNotificationSettings(
      enabled: value,
      hour: _selectedTime.hour,
      minute: _selectedTime.minute,
    );

    setState(() => _enabled = value);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
      if (_enabled) {
        await _notifications.scheduleDailyReminder(
          hour: picked.hour,
          minute: picked.minute,
        );
        await _prefs.saveNotificationSettings(
          enabled: true,
          hour: picked.hour,
          minute: picked.minute,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Recordatorio diario',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Te avisaremos para registrar tus hábitos',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      Switch(value: _enabled, onChanged: _toggleNotifications),
                    ],
                  ),
                  if (_enabled) ...[
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hora del recordatorio',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              _selectedTime.format(context),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        OutlinedButton(
                          onPressed: _pickTime,
                          child: const Text('Cambiar'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Las notificaciones son opcionales. '
                      'Puedes desactivarlas en cualquier momento.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue.shade900,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
