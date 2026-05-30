import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/providers/exercise_provider.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Header(),
              const _BenefitsCard(),
              const _WeeklyProgress(),
              const _LevelBanner(),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Rutinas recomendadas para ti',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Basado en tu nivel y objetivos personales',
                  style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
                ),
              ),
              const SizedBox(height: 16),
              const _RoutineCard(
                title: 'Caminata consciente',
                durationMinutes: 30,
                intensity: 'Intensidad baja',
                intensityColor: Color(0xFF4CAF50),
                imageUrl:
                    'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=800&q=80',
                exercises: [
                  _Exercise(
                    name: 'Caminata lenta',
                    sets: '5 min',
                    description: 'Ritmo tranquilo, respiración profunda.',
                  ),
                  _Exercise(
                    name: 'Caminata activa',
                    sets: '20 min',
                    description:
                        'Paso firme, balanceo de brazos, atención plena.',
                  ),
                  _Exercise(
                    name: 'Enfriamiento',
                    sets: '5 min',
                    description: 'Baja el ritmo gradualmente.',
                  ),
                ],
              ),
              const _RoutineCard(
                title: 'Fuerza en casa',
                durationMinutes: 20,
                intensity: 'Intensidad moderada',
                intensityColor: Color(0xFFFF9800),
                imageUrl:
                    'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800&q=80',
                exercises: [
                  _Exercise(
                    name: 'Sentadillas',
                    sets: '3 × 10 reps',
                    description: 'Pies al ancho de hombros, espalda recta.',
                  ),
                  _Exercise(
                    name: 'Plancha',
                    sets: '3 × 20 seg',
                    description: 'Core activado, cuerpo alineado.',
                  ),
                  _Exercise(
                    name: 'Estocadas',
                    sets: '3 × 8 por pierna',
                    description: 'Rodilla trasera cerca del suelo.',
                  ),
                  _Exercise(
                    name: 'Flexiones de pared',
                    sets: '3 × 10 reps',
                    description: 'Palmas a la altura del pecho en la pared.',
                  ),
                ],
              ),
              const _RoutineCard(
                title: 'Estiramientos',
                durationMinutes: 15,
                intensity: 'Intensidad baja',
                intensityColor: Color(0xFF4CAF50),
                imageUrl:
                    'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800&q=80',
                exercises: [
                  _Exercise(
                    name: 'Cuello y hombros',
                    sets: '30 seg c/lado',
                    description: 'Inclina la cabeza suavemente a cada lado.',
                  ),
                  _Exercise(
                    name: 'Estiramiento de cuádriceps',
                    sets: '30 seg c/pierna',
                    description: 'De pie, lleva el talón hacia el glúteo.',
                  ),
                  _Exercise(
                    name: 'Flexión hacia adelante',
                    sets: '45 seg',
                    description: 'Dobla la cintura, deja caer los brazos.',
                  ),
                  _Exercise(
                    name: 'Torsión de columna',
                    sets: '30 seg c/lado',
                    description:
                        'Sentado, gira el torso suavemente hacia cada lado.',
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final level = context.watch<ExerciseProvider>().level;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Actividad física',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Tu nivel actual',
                style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => _showLevelSheet(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: level.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: level.color.withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    level.label,
                    style: TextStyle(
                      fontSize: 13,
                      color: level.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.expand_more, size: 16, color: level.color),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLevelSheet(BuildContext context) {
    final provider = context.read<ExerciseProvider>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selecciona tu nivel de actividad',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...ExerciseLevel.values.map(
                (lvl) => _LevelOption(
                  level: lvl,
                  isSelected: provider.level == lvl,
                  onTap: () {
                    provider.setLevel(lvl);
                    Navigator.pop(ctx);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LevelOption extends StatelessWidget {
  final ExerciseLevel level;
  final bool isSelected;
  final VoidCallback onTap;

  const _LevelOption({
    required this.level,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? level.color.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? level.color : const Color(0xFFE0E0E0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: level.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    level.label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? level.color : const Color(0xFF2D2D2D),
                    ),
                  ),
                  Text(
                    level.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: level.color, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─── Benefits Card ────────────────────────────────────────────────────────────

class _BenefitsCard extends StatelessWidget {
  const _BenefitsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6B9E6B), Color(0xFF4A7C59)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Beneficios de hoy',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'El ejercicio mejora tu sensibilidad a la insulina, reduce la presión arterial y eleva tu estado de ánimo.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _BenefitChip(
                icon: Icons.favorite_outline,
                label: 'Ideal para principiantes',
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _BenefitChip(
                icon: Icons.fitness_center,
                label: 'Fortalece tu cuerpo',
              ),
              const SizedBox(width: 8),
              _BenefitChip(
                icon: Icons.self_improvement,
                label: 'Mejora tu flexibilidad',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BenefitChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _BenefitChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}

// ─── Weekly Progress ──────────────────────────────────────────────────────────

class _WeeklyProgress extends StatelessWidget {
  const _WeeklyProgress();

  @override
  Widget build(BuildContext context) {
    final ex = context.watch<ExerciseProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.flag_outlined,
              value: '${ex.level.goalMinutes} min',
              label: 'Objetivo de hoy',
              sub: ex.level.label,
              color: const Color(0xFF6B9E6B),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StreakCard(streak: ex.streakCount),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _WeeklyTimeCard(weeklyMinutes: ex.weeklyMinutes),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final String sub;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.sub,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Color(0xFF888888)),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: const TextStyle(fontSize: 9, color: Color(0xFFAAAAAA)),
          ),
        ],
      ),
    );
  }
}

// ─── Streak Card ─────────────────────────────────────────────────────────────

class _StreakCard extends StatelessWidget {
  final int streak;
  const _StreakCard({required this.streak});

  String get _streakMessage {
    if (streak == 0) return 'Empieza hoy';
    if (streak >= 5) return '¡Semana completa!';
    return '¡Vas por buen camino!';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            color: Color(0xFF5B8DB8),
            size: 20,
          ),
          const SizedBox(height: 6),
          Text(
            '$streak de 5',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5B8DB8),
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Días esta semana',
            style: TextStyle(fontSize: 10, color: Color(0xFF888888)),
          ),
          const SizedBox(height: 2),
          Text(
            _streakMessage,
            style: const TextStyle(fontSize: 9, color: Color(0xFFAAAAAA)),
          ),
        ],
      ),
    );
  }
}

// ─── Weekly Time Card ────────────────────────────────────────────────────────

class _WeeklyTimeCard extends StatelessWidget {
  final int weeklyMinutes;
  const _WeeklyTimeCard({required this.weeklyMinutes});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAddMinutesDialog(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.timer_outlined,
                  color: Color(0xFFE07B54),
                  size: 20,
                ),
                Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE07B54),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 12),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '$weeklyMinutes min',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE07B54),
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Tiempo esta semana',
              style: TextStyle(fontSize: 10, color: Color(0xFF888888)),
            ),
            const SizedBox(height: 2),
            const Text(
              'Toca para registrar',
              style: TextStyle(fontSize: 9, color: Color(0xFFAAAAAA)),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMinutesDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          '¿Cuántos minutos hiciste hoy?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Ej: 30',
            suffixText: 'min',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE07B54), width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE07B54),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              final mins = int.tryParse(controller.text.trim());
              if (mins != null && mins > 0) {
                context.read<ExerciseProvider>().addMinutes(mins);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('¡$mins minutos registrados!'),
                    backgroundColor: const Color(0xFFE07B54),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}

// ─── Level Banner ─────────────────────────────────────────────────────────────

class _LevelBanner extends StatelessWidget {
  const _LevelBanner();

  @override
  Widget build(BuildContext context) {
    final level = context.watch<ExerciseProvider>().level;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: level.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: level.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.star_outline, color: level.color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${level.description} · ${level.label}',
              style: TextStyle(fontSize: 13, color: level.color),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Routine Card ─────────────────────────────────────────────────────────────

class _Exercise {
  final String name;
  final String sets;
  final String description;
  const _Exercise({
    required this.name,
    required this.sets,
    required this.description,
  });
}

class _RoutineCard extends StatefulWidget {
  final String title;
  final int durationMinutes;
  final String intensity;
  final Color intensityColor;
  final String imageUrl;
  final List<_Exercise> exercises;

  const _RoutineCard({
    required this.title,
    required this.durationMinutes,
    required this.intensity,
    required this.intensityColor,
    required this.imageUrl,
    required this.exercises,
  });

  @override
  State<_RoutineCard> createState() => _RoutineCardState();
}

class _RoutineCardState extends State<_RoutineCard> {
  bool _expanded = false;

  void _addRoutineTime() {
    context.read<ExerciseProvider>().addMinutes(widget.durationMinutes);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.durationMinutes} min de "${widget.title}" registrados',
        ),
        backgroundColor: const Color(0xFF6B9E6B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.network(
              widget.imageUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  height: 160,
                  color: const Color(0xFFEEEEEE),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF6B9E6B),
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
              errorBuilder: (context, e, s) => Container(
                height: 160,
                color: const Color(0xFFEEEEEE),
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  color: Color(0xFFCCCCCC),
                  size: 40,
                ),
              ),
            ),
          ),
          // Info row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                            size: 14,
                            color: Color(0xFF888888),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.durationMinutes} min',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF888888),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: widget.intensityColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.intensity,
                            style: TextStyle(
                              fontSize: 13,
                              color: widget.intensityColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Botón + para registrar tiempo
                GestureDetector(
                  onTap: _addRoutineTime,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6B9E6B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 22),
                  ),
                ),
              ],
            ),
          ),
          // Expand / collapse
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _expanded ? 'Ocultar ejercicios' : 'Ver ejercicios',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B9E6B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF6B9E6B),
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            ...widget.exercises.map((e) => _ExerciseTile(exercise: e)),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  final _Exercise exercise;
  const _ExerciseTile({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 5),
            decoration: const BoxDecoration(
              color: Color(0xFF6B9E6B),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      exercise.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        exercise.sets,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF388E3C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  exercise.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF888888),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
