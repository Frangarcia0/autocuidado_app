import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../shared/providers/user_provider.dart';
import '../../shared/services/preferences_service.dart';
import 'edit_profile_page.dart';
import 'privacy_page.dart';
import 'notifications_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  String _getConditionLabel(String condition) {
    switch (condition) {
      case 'diabetes':
        return 'Diabetes';
      case 'hypertension':
        return 'Hipertensión';
      case 'both':
        return 'Diabetes e Hipertensión';
      default:
        return 'No definida';
    }
  }

  String _getConditionIcon(String condition) {
    switch (condition) {
      case 'diabetes':
        return '💧';
      case 'hypertension':
        return '❤️';
      case 'both':
        return '🏥';
      default:
        return '❓';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Tarjeta de perfil
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Avatar con inicial
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Text(
                      user.displayName.isNotEmpty
                          ? user.displayName[0].toUpperCase()
                          : 'U',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Nombre
                  Text(
                    user.displayName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Condición
                  Text(
                    '${_getConditionIcon(user.condition)} '
                    '${_getConditionLabel(user.condition)}',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 12),

                  // Chips de datos
                  if (user.user?.age != null)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        _DataChip(
                          label: '${user.user!.age} años',
                          icon: Icons.cake_outlined,
                        ),
                        if (user.height != null)
                          _DataChip(
                            label: '${user.height!.toStringAsFixed(0)} cm',
                            icon: Icons.height,
                          ),
                        if (user.weight != null)
                          _DataChip(
                            label: '${user.weight!.toStringAsFixed(0)} kg',
                            icon: Icons.monitor_weight_outlined,
                          ),
                      ],
                    ),
                  const SizedBox(height: 16),

                  // Botón editar
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Editar perfil'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfilePage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Opciones
          Card(
  child: Column(
    children: [
      _ProfileOption(
        icon: Icons.notifications_outlined,
        title: 'Notificaciones',
        subtitle: 'Configura tus recordatorios diarios',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NotificationsPage(),
            ),
          );
        },
      ),
      const Divider(height: 1),
      _ProfileOption(
        icon: Icons.shield_outlined,
        title: 'Sobre tus datos',
        subtitle: 'Privacidad y uso de la información',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PrivacyPage(),
            ),
          );
        },
      ),
      const Divider(height: 1),
      _ProfileOption(
        icon: Icons.refresh,
        title: 'Resetear app',
        subtitle: 'Borrar datos y volver al inicio',
        color: Colors.red.shade400,
        onTap: () => _confirmReset(context),
      ),
    ],
  ),
        ),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Resetear la app?'),
        content: const Text(
          'Se borrarán todos tus datos locales incluyendo '
          'tu perfil y el registro de hábitos. '
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await PreferencesService().clearAll();
              if (ctx.mounted) {
                Navigator.pop(ctx);
                context.go('/');
              }
            },
            child: const Text('Resetear'),
          ),
        ],
      ),
    );
  }
}

// ── Widgets internos ──────────────────────────────────────────

class _DataChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _DataChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? color;

  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? Theme.of(context).colorScheme.primary;

    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500, color: color),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }
}
