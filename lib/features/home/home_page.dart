import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:go_router/go_router.dart';
import '../../shared/providers/user_provider.dart';
import '../../shared/providers/habits_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }

  String _getSubtitle() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Hoy es un gran día para cuidar de tu salud';
    if (hour < 19) return 'Sigue así, vas muy bien hoy';
    return 'Recuerda descansar bien esta noche';
  }

  String _getTip(String condition) {
    if (condition == 'diabetes') {
      return 'El ejercicio y el sueño son tus mejores aliados. '
          'Cada caminata post-comida y cada noche de buen descanso '
          'mejoran directamente la respuesta de tu cuerpo a la insulina.';
    }
    if (condition == 'hypertension') {
      return 'Reducir el estrés y mantener una rutina de sueño regular '
          'tiene un impacto directo en tu presión arterial. '
          'Pequeños cambios diarios hacen una gran diferencia.';
    }
    return 'Mantener hábitos saludables constantes es más importante '
        'que cambios drásticos. Cada pequeño paso cuenta.';
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();
    final habits = context.watch<HabitsProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            _HeaderSection(
              greeting: _getGreeting(),
              name: user.displayName,
              subtitle: _getSubtitle(),
            ),
            const SizedBox(height: 20),
            _ProgressCard(
              completed: habits.completedToday,
              total: habits.total,
              progress: habits.todayProgress,
              habits: habits.habits,
            ),
            const SizedBox(height: 20),
            _TipCard(
              tip: _getTip(user.condition),
              onLearnMore: () => context.go('/education'),
            ),
            const SizedBox(height: 24),
            const _QuickAccessSection(),
            const SizedBox(height: 24),
            _MetricsSection(weight: user.weight),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────

class _HeaderSection extends StatelessWidget {
  final String greeting;
  final String name;
  final String subtitle;

  const _HeaderSection({
    required this.greeting,
    required this.name,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting, $name!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D3D3D),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7A7A7A),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 44,
          height: 44,
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
            color: Color(0xFF5E5A55),
            size: 22,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => context.go('/profile'),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFA3B18A),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 24),
          ),
        ),
      ],
    );
  }
}

// ── Progreso ──────────────────────────────────────────────────

class _ProgressCard extends StatelessWidget {
  final int completed;
  final int total;
  final double progress;
  final List habits;

  const _ProgressCard({
    required this.completed,
    required this.total,
    required this.progress,
    required this.habits,
  });

  @override
  Widget build(BuildContext context) {
    final preview = habits.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tu progreso de hoy',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D3D3D),
                ),
              ),
              GestureDetector(
                onTap: () => context.go('/habits'),
                child: const Text(
                  'Ver más >',
                  style: TextStyle(fontSize: 13, color: Color(0xFF7A7A7A)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 50,
                lineWidth: 10,
                percent: total > 0 ? progress.clamp(0.0, 1.0) : 0,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$completed',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3D3D3D),
                      ),
                    ),
                    const Text(
                      'de',
                      style: TextStyle(fontSize: 12, color: Color(0xFF7A7A7A)),
                    ),
                    Text(
                      '$total',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7A7A7A),
                      ),
                    ),
                  ],
                ),
                progressColor: const Color(0xFFA3B18A),
                backgroundColor: const Color(0xFFE8EFE0),
                circularStrokeCap: CircularStrokeCap.round,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: preview.map((habit) {
                    return GestureDetector(
                      onTap: () {
                        context.read<HabitsProvider>().toggleHabit(habit.id);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: habit.completedToday
                              ? const Color(0xFFE8EFE0)
                              : const Color(0xFFF7F4EF),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: habit.completedToday
                                ? const Color(0xFFA3B18A)
                                : Colors.transparent,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                habit.title,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: habit.completedToday
                                      ? const Color(0xFF7A7A7A)
                                      : const Color(0xFF3D3D3D),
                                  decoration: habit.completedToday
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              habit.completedToday
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              size: 20,
                              color: habit.completedToday
                                  ? const Color(0xFFA3B18A)
                                  : const Color(0xFFCCCCCC),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Consejo del día ───────────────────────────────────────────

class _TipCard extends StatelessWidget {
  final String tip;
  final VoidCallback onLearnMore;

  const _TipCard({required this.tip, required this.onLearnMore});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EFE0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Consejo del día',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D3D3D),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  tip,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF5E5A55),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: onLearnMore,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFA3B18A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Aprender más',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Image.asset(
              'assets/branding/cat_meditation.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Accesos rápidos ───────────────────────────────────────────

class _QuickAccessSection extends StatelessWidget {
  const _QuickAccessSection();

  @override
  Widget build(BuildContext context) {
    final items = [
      _QuickItem(
  label: 'Ver recetas',
  image: 'assets/branding/icon_recipes.png',
  color: const Color(0xFFFFF0E0),
  enabled: true, // ← cambiar a true
  onTap: () => context.go('/recipes'),
),
      _QuickItem(
        label: 'Actividad física',
        image: 'assets/branding/icon_exercise.png',
        color: const Color(0xFFE8F4E8),
        enabled: true, // ← cambiar a true
        onTap: () => context.go('/exercise'),
      ),
      _QuickItem(
        label: 'Registrar agua',
        image: 'assets/branding/icon_water.png',
        color: const Color(0xFFE8F4FF),
        enabled: true, // ← cambiar a true
        onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (_) => const _WaterLogSheet(),
        ),
      ),
      _QuickItem(
        label: 'Aprender',
        image: 'assets/branding/icon_education.png',
        color: const Color(0xFFF0ECFF),
        enabled: true,
        onTap: () => context.go('/education'),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '¿Qué quieres hacer hoy?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3D3D3D),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: items.map((item) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: item == items.last ? 0 : 8),
                child: _QuickAccessCard(item: item),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _QuickItem {
  final String label;
  final String image;
  final Color color;
  final bool enabled;
  final VoidCallback onTap;

  const _QuickItem({
    required this.label,
    required this.image,
    required this.color,
    required this.enabled,
    required this.onTap,
  });
}

class _QuickAccessCard extends StatelessWidget {
  final _QuickItem item;

  const _QuickAccessCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.enabled
          ? item.onTap
          : () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Próximamente disponible'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
      child: Opacity(
        opacity: item.enabled ? 1.0 : 0.6,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Image.asset(
                item.image,
                height: 56,
                width: 56,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 8),
              Text(
                item.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: item.enabled
                      ? const Color(0xFF3D3D3D)
                      : const Color(0xFF7A7A7A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Métricas ──────────────────────────────────────────────────

class _MetricsSection extends StatelessWidget {
  final double? weight;

  const _MetricsSection({required this.weight});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '¿Cómo estamos el día de hoy?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3D3D3D),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.favorite,
                iconColor: const Color(0xFFFF8FAB),
                label: 'Presión arterial',
                value: '120/80',
                unit: 'mmHg',
                status: 'Ver registro',
                statusColor: const Color(0xFFA3B18A),
                bgColor: const Color(0xFFFFF0F3),
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  builder: (_) => const _BloodPressureLogSheet(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MetricCard(
                icon: Icons.water_drop,
                iconColor: const Color(0xFF4FC3F7),
                label: 'Glucosa',
                value: '98',
                unit: 'mg/dl',
                status: 'Ver registro',
                statusColor: const Color(0xFFA3B18A),
                bgColor: const Color(0xFFE8F8FF),
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  builder: (_) => const _GlucoseLogSheet(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MetricCard(
                icon: Icons.monitor_weight_outlined,
                iconColor: const Color(0xFFB39DDB),
                label: 'Peso',
                value: weight != null ? weight!.toStringAsFixed(0) : '--',
                unit: 'kg',
                status: weight != null ? 'Ver registro' : 'Agrega en perfil',
                statusColor: weight != null
                    ? const Color(0xFFA3B18A)
                    : const Color(0xFFC98B6B),
                bgColor: const Color(0xFFF3F0FF),
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  builder: (_) => const _WeightLogSheet(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Tarjeta de métrica ────────────────────────────────────────

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String unit;
  final String status;
  final Color statusColor;
  final Color bgColor;
  final VoidCallback? onTap;

  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.unit,
    required this.status,
    required this.statusColor,
    required this.bgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: onTap != null
              ? Border.all(
                  color: const Color(0xFFA3B18A).withValues(alpha: 0.3),
                  width: 1,
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 14),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: iconColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onTap != null)
                  const Icon(
                    Icons.add_circle_outline,
                    size: 14,
                    color: Color(0xFFA3B18A),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3D3D3D),
              ),
            ),
            Text(
              unit,
              style: const TextStyle(fontSize: 11, color: Color(0xFF7A7A7A)),
            ),
            const SizedBox(height: 4),
            Text(
              status,
              style: TextStyle(
                fontSize: 10,
                color: statusColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Modal de registro de peso ─────────────────────────────────

class _WeightLogSheet extends StatefulWidget {
  const _WeightLogSheet();

  @override
  State<_WeightLogSheet> createState() => _WeightLogSheetState();
}

class _WeightLogSheetState extends State<_WeightLogSheet> {
  final _controller = TextEditingController();

  final List<Map<String, String>> _logs = [
    {'date': 'Hoy', 'weight': '--'},
    {'date': 'Ayer', 'weight': '--'},
    {'date': 'Hace 2 días', 'weight': '--'},
    {'date': 'Hace 3 días', 'weight': '--'},
    {'date': 'Hace 4 días', 'weight': '--'},
  ];

  bool get _canSave =>
      double.tryParse(_controller.text.replaceAll(',', '.')) != null;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (!_canSave) return;
    final value = double.parse(_controller.text.replaceAll(',', '.'));
    setState(() {
      _logs[0] = {'date': 'Hoy', 'weight': '${value.toStringAsFixed(1)} kg'};
    });
    context.read<UserProvider>().updateUser(
      context.read<UserProvider>().user!.copyWith(weight: value),
    );
    _controller.clear();
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Peso registrado correctamente'),
        backgroundColor: Color(0xFFA3B18A),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F0FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.monitor_weight_outlined,
                    color: Color(0xFFB39DDB),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Registro de peso',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D3D3D),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Ej: 70.5',
                      suffixText: 'kg',
                      filled: true,
                      fillColor: const Color(0xFFF7F4EF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _canSave ? _save : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA3B18A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Guardar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Historial reciente',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3D3D3D),
              ),
            ),
            const SizedBox(height: 12),
            ..._logs.map((log) {
              final hasData = log['weight'] != '--';
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F4EF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      log['date']!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF7A7A7A),
                      ),
                    ),
                    Text(
                      log['weight']!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: hasData
                            ? const Color(0xFF3D3D3D)
                            : const Color(0xFFCCCCCC),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 14,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Este registro es solo informativo para '
                      'compartir con tu médico.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.orange.shade900,
                        height: 1.4,
                      ),
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
}

// ── Modal de registro de glucosa ──────────────────────────────

class _GlucoseLogSheet extends StatefulWidget {
  const _GlucoseLogSheet();

  @override
  State<_GlucoseLogSheet> createState() => _GlucoseLogSheetState();
}

class _GlucoseLogSheetState extends State<_GlucoseLogSheet> {
  final _controller = TextEditingController();
  String _moment = 'Ayunas';

  final List<String> _moments = [
    'Ayunas',
    'Antes de comer',
    'Después de comer',
    'Antes de dormir',
  ];

  final List<Map<String, String>> _logs = [
    {'date': 'Hoy', 'value': '--', 'moment': ''},
    {'date': 'Ayer', 'value': '--', 'moment': ''},
    {'date': 'Hace 2 días', 'value': '--', 'moment': ''},
    {'date': 'Hace 3 días', 'value': '--', 'moment': ''},
    {'date': 'Hace 4 días', 'value': '--', 'moment': ''},
  ];

  bool get _canSave =>
      double.tryParse(_controller.text.replaceAll(',', '.')) != null;

  String _getStatus(double value) {
    if (value < 70) return 'Bajo — consulta tu médico';
    if (value <= 100) return 'En rango';
    if (value <= 125) return 'Elevado';
    return 'Alto — consulta tu médico';
  }

  Color _getStatusColor(double value) {
    if (value < 70 || value > 125) return const Color(0xFFE53935);
    if (value <= 100) return const Color(0xFF4CAF50);
    return const Color(0xFFFFA726);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (!_canSave) return;
    final value = double.parse(_controller.text.replaceAll(',', '.'));
    setState(() {
      _logs[0] = {
        'date': 'Hoy',
        'value': '${value.toStringAsFixed(0)} mg/dl',
        'moment': _moment,
      };
    });
    _controller.clear();
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Glucosa registrada correctamente'),
        backgroundColor: Color(0xFFA3B18A),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.water_drop,
                    color: Color(0xFF4FC3F7),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Registro de glucosa',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D3D3D),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Momento de medición',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5E5A55),
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _moments.map((m) {
                  final selected = _moment == m;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _moment = m),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFF4FC3F7)
                              : const Color(0xFFF7F4EF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          m,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: selected
                                ? Colors.white
                                : const Color(0xFF7A7A7A),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    autofocus: false,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Ej: 98',
                      suffixText: 'mg/dl',
                      filled: true,
                      fillColor: const Color(0xFFF7F4EF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _canSave ? _save : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4FC3F7),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Guardar'),
                  ),
                ),
              ],
            ),
            if (_controller.text.isNotEmpty && _canSave) ...[
              const SizedBox(height: 12),
              Builder(
                builder: (context) {
                  final value = double.parse(
                    _controller.text.replaceAll(',', '.'),
                  );
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(value).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 14,
                          color: _getStatusColor(value),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getStatus(value),
                          style: TextStyle(
                            fontSize: 12,
                            color: _getStatusColor(value),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              'Historial reciente',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3D3D3D),
              ),
            ),
            const SizedBox(height: 12),
            ..._logs.map((log) {
              final hasData = log['value'] != '--';
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F4EF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          log['date']!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF7A7A7A),
                          ),
                        ),
                        if (hasData && log['moment']!.isNotEmpty)
                          Text(
                            log['moment']!,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFFAAAAAA),
                            ),
                          ),
                      ],
                    ),
                    Text(
                      log['value']!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: hasData
                            ? const Color(0xFF3D3D3D)
                            : const Color(0xFFCCCCCC),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 14,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Este registro es informativo para compartir '
                      'con tu médico. No reemplaza su diagnóstico.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.orange.shade900,
                        height: 1.4,
                      ),
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
}

// ── Modal de registro de presión arterial ─────────────────────

class _BloodPressureLogSheet extends StatefulWidget {
  const _BloodPressureLogSheet();

  @override
  State<_BloodPressureLogSheet> createState() => _BloodPressureLogSheetState();
}

class _BloodPressureLogSheetState extends State<_BloodPressureLogSheet> {
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();

  final List<Map<String, String>> _logs = [
    {'date': 'Hoy', 'value': '--'},
    {'date': 'Ayer', 'value': '--'},
    {'date': 'Hace 2 días', 'value': '--'},
    {'date': 'Hace 3 días', 'value': '--'},
    {'date': 'Hace 4 días', 'value': '--'},
  ];

  bool get _canSave =>
      int.tryParse(_systolicController.text) != null &&
      int.tryParse(_diastolicController.text) != null;

  String _getStatus(int systolic, int diastolic) {
    if (systolic < 120 && diastolic < 80) return 'Normal';
    if (systolic < 130 && diastolic < 80) return 'Elevada';
    if (systolic < 140 || diastolic < 90) return 'Hipertensión etapa 1';
    return 'Hipertensión etapa 2 — consulta tu médico';
  }

  Color _getStatusColor(int systolic, int diastolic) {
    if (systolic < 120 && diastolic < 80) return const Color(0xFF4CAF50);
    if (systolic < 130 && diastolic < 80) return const Color(0xFFFFA726);
    if (systolic < 140 || diastolic < 90) return const Color(0xFFFF7043);
    return const Color(0xFFE53935);
  }

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_canSave) return;
    final sys = _systolicController.text;
    final dia = _diastolicController.text;
    setState(() {
      _logs[0] = {'date': 'Hoy', 'value': '$sys/$dia mmHg'};
    });
    _systolicController.clear();
    _diastolicController.clear();
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Presión arterial registrada correctamente'),
        backgroundColor: Color(0xFFA3B18A),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final systolic = int.tryParse(_systolicController.text);
    final diastolic = int.tryParse(_diastolicController.text);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Color(0xFFFF8FAB),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Registro de presión arterial',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D3D3D),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Ingresa sistólica (alta) y diastólica (baja)',
              style: TextStyle(fontSize: 12, color: Color(0xFF7A7A7A)),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sistólica',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5E5A55),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _systolicController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Ej: 120',
                          suffixText: 'mmHg',
                          filled: true,
                          fillColor: const Color(0xFFF7F4EF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Text(
                    '/',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7A7A7A),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Diastólica',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5E5A55),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _diastolicController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Ej: 80',
                          suffixText: 'mmHg',
                          filled: true,
                          fillColor: const Color(0xFFF7F4EF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (systolic != null && diastolic != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(systolic, diastolic).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 14,
                      color: _getStatusColor(systolic, diastolic),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getStatus(systolic, diastolic),
                        style: TextStyle(
                          fontSize: 12,
                          color: _getStatusColor(systolic, diastolic),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _canSave ? _save : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8FAB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Guardar', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Historial reciente',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3D3D3D),
              ),
            ),
            const SizedBox(height: 12),
            ..._logs.map((log) {
              final hasData = log['value'] != '--';
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F4EF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      log['date']!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF7A7A7A),
                      ),
                    ),
                    Text(
                      log['value']!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: hasData
                            ? const Color(0xFF3D3D3D)
                            : const Color(0xFFCCCCCC),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 14,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Este registro es informativo para compartir '
                      'con tu médico. No reemplaza su diagnóstico.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.orange.shade900,
                        height: 1.4,
                      ),
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
}

// ── Modal de registro de agua ────────────────────────────────

class _WaterLogSheet extends StatefulWidget {
  const _WaterLogSheet();

  @override
  State<_WaterLogSheet> createState() => _WaterLogSheetState();
}

class _WaterLogSheetState extends State<_WaterLogSheet> {
  static const int _goal = 8;
  int _glasses = 0;

  void _add() { if (_glasses < _goal) setState(() => _glasses++); }
  void _remove() { if (_glasses > 0) setState(() => _glasses--); }

  @override
  Widget build(BuildContext context) {
    final pct = _glasses / _goal;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const Row(children: [
              Icon(Icons.water_drop, color: Color(0xFF4FC3F7), size: 26),
              SizedBox(width: 10),
              Text('Registro de agua', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 6),
            Text('Meta diaria: $_goal vasos (2 litros aprox.)',
              style: const TextStyle(fontSize: 13, color: Color(0xFF888888))),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_goal, (i) {
                  final filled = i < _glasses;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Icon(
                      filled ? Icons.water_drop : Icons.water_drop_outlined,
                      color: filled ? const Color(0xFF4FC3F7) : Colors.grey.shade300,
                      size: 32,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: pct, minHeight: 10,
                backgroundColor: Colors.grey.shade100,
                color: const Color(0xFF4FC3F7),
              ),
            ),
            const SizedBox(height: 8),
            Text('$_glasses de $_goal vasos',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF4FC3F7))),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _WaterBtn(icon: Icons.remove, onTap: _remove, enabled: _glasses > 0),
                const SizedBox(width: 28),
                Text('$_glasses', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))),
                const SizedBox(width: 28),
                _WaterBtn(icon: Icons.add, onTap: _add, enabled: _glasses < _goal, primary: true),
              ],
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4FC3F7), foregroundColor: Colors.white,
                  elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(_glasses == _goal ? '¡Meta de agua alcanzada! 🎉' : '$_glasses vasos registrados'),
                    backgroundColor: const Color(0xFF4FC3F7),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ));
                },
                child: const Text('Guardar registro', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WaterBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;
  final bool primary;
  const _WaterBtn({required this.icon, required this.onTap, this.enabled = true, this.primary = false});

  @override
  Widget build(BuildContext context) {
    final color = primary ? const Color(0xFF4FC3F7) : const Color(0xFFEEEEEE);
    final iconColor = primary ? Colors.white : const Color(0xFF555555);
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.3,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: 52, height: 52,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 26),
        ),
      ),
    );
  }
}
