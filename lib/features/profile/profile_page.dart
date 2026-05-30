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

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            // ── Header ─────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Mi Perfil',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: Color(0xFF5A5A5A),
                    size: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Tarjeta de perfil ───────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Avatar + nombre + género
                  Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: Color(0xFFDDE8CC),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              user.displayName.isNotEmpty
                                  ? user.displayName[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4A6741),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2D2D2D),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.displayName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D2D2D),
                              ),
                            ),
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: () => _openEdit(context),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.help_outline,
                                    size: 16,
                                    color: Color(0xFFE57373),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    user.gender != null
                                        ? _genderLabel(user.gender!)
                                        : 'Género',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF777777),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.edit_outlined,
                                    size: 14,
                                    color: Color(0xFF888888),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Chips de datos
                  Row(
                    children: [
                      if (user.user?.age != null)
                        Expanded(
                          child: _DataChip(
                            icon: Icons.cake_outlined,
                            value: '${user.user!.age}',
                            unit: 'años',
                          ),
                        ),
                      if (user.user?.age != null) const SizedBox(width: 10),
                      if (user.height != null)
                        Expanded(
                          child: _DataChip(
                            icon: Icons.straighten,
                            value: user.height!.toStringAsFixed(0),
                            unit: 'cm',
                          ),
                        ),
                      if (user.height != null) const SizedBox(width: 10),
                      if (user.weight != null)
                        Expanded(
                          child: _DataChip(
                            icon: Icons.monitor_weight_outlined,
                            value: user.weight!.toStringAsFixed(0),
                            unit: 'kg',
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── Botón Editar perfil ─────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B8F55),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => _openEdit(context),
                child: const Text(
                  'Editar perfil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Opciones ────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _ProfileOption(
                    icon: Icons.notifications_outlined,
                    iconBgColor: const Color(0xFFECF1E5),
                    iconColor: const Color(0xFF6B8F55),
                    title: 'Notificaciones',
                    subtitle: 'Configura tus recordatorios diarios',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationsPage(),
                      ),
                    ),
                  ),
                  const _OptionDivider(),
                  _ProfileOption(
                    icon: Icons.shield_outlined,
                    iconBgColor: const Color(0xFFECF1E5),
                    iconColor: const Color(0xFF6B8F55),
                    title: 'Sobre tus datos',
                    subtitle: 'Privacidad y uso de la información',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PrivacyPage()),
                    ),
                  ),
                  const _OptionDivider(),
                  _ProfileOption(
                    icon: Icons.download_outlined,
                    iconBgColor: const Color(0xFFECF1E5),
                    iconColor: const Color(0xFF6B8F55),
                    title: 'Exportar mis datos',
                    subtitle: 'Descarga tu información personal',
                    onTap: () {},
                  ),
                  const _OptionDivider(),
                  _ProfileOption(
                    icon: Icons.refresh,
                    iconBgColor: const Color(0xFFFFEBEB),
                    iconColor: const Color(0xFFE57373),
                    title: 'Resetear app',
                    subtitle: 'Borrar datos y volver al inicio',
                    titleColor: const Color(0xFFE57373),
                    onTap: () => _confirmReset(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Tarjeta motivacional ────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/branding/cat_meditation.png',
                    width: 72,
                    height: 72,
                    errorBuilder: (ctx, e, s) => const SizedBox(
                      width: 72,
                      height: 72,
                      child: Icon(
                        Icons.spa_outlined,
                        size: 40,
                        color: Color(0xFF6B8F55),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tu salud, tu prioridad',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6B8F55),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Cada decisión cuenta.\nEstamos aquí para acompañarte\nen tu bienestar.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF777777),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openEdit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfilePage()),
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              backgroundColor: const Color(0xFFE57373),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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

  String _genderLabel(String gender) {
    switch (gender) {
      case 'femenino':
        return 'Femenino';
      case 'masculino':
        return 'Masculino';
      case 'otro':
        return 'Otro';
      default:
        return 'Género';
    }
  }
}

// ── Widgets ───────────────────────────────────────────────────

class _DataChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String unit;

  const _DataChip({
    required this.icon,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7EF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF6B8F55)),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF888888),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OptionDivider extends StatelessWidget {
  const _OptionDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, color: Color(0xFFF0F0F0)),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? titleColor;

  const _ProfileOption({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: titleColor ?? const Color(0xFF2D2D2D),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Color(0xFFBBBBBB),
            ),
          ],
        ),
      ),
    );
  }
}
