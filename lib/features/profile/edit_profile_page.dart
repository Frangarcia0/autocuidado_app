import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/providers/user_provider.dart';
import '../../shared/providers/habits_provider.dart';
import '../../shared/providers/recommendations_provider.dart';
import '../../shared/providers/education_provider.dart';
import '../../shared/models/user_model.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String _selectedCondition = 'diabetes';
  String? _selectedGender;

  static const _green = Color(0xFF6B8F55);
  static const _bgColor = Color(0xFFF7F4EF);

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user;
    if (user != null) {
      _nameController.text = user.name;
      _selectedCondition = user.condition;
      _selectedGender = user.gender;
      if (user.birthDate != null) {
        _birthDateController.text = user.birthDate!;
      } else {
        // Retro-compat: si sólo hay edad, la mostramos vacía
        _birthDateController.text = '';
      }
      if (user.height != null) {
        _heightController.text = user.height!.toStringAsFixed(0);
      }
      if (user.weight != null) {
        _weightController.text = user.weight!.toStringAsFixed(0);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  bool get _canSave => _nameController.text.trim().isNotEmpty;

  int _ageFromBirthDate(String bd) {
    try {
      final parts = bd.split('-');
      if (parts.length != 3) return 0;
      final birth = DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
      final today = DateTime.now();
      int age = today.year - birth.year;
      if (today.month < birth.month ||
          (today.month == birth.month && today.day < birth.day)) {
        age--;
      }
      return age < 0 ? 0 : age;
    } catch (_) {
      return 0;
    }
  }

  Future<void> _save() async {
    final age = _birthDateController.text.isNotEmpty
        ? _ageFromBirthDate(_birthDateController.text)
        : (context.read<UserProvider>().user?.age ?? 0);

    final updated = UserModel(
      name: _nameController.text.trim(),
      age: age,
      condition: _selectedCondition,
      height: double.tryParse(_heightController.text),
      weight: double.tryParse(_weightController.text),
      gender: _selectedGender,
      birthDate: _birthDateController.text.isNotEmpty
          ? _birthDateController.text
          : null,
    );

    final userProvider = context.read<UserProvider>();
    final habitsProvider = context.read<HabitsProvider>();
    final recsProvider = context.read<RecommendationsProvider>();
    final eduProvider = context.read<EducationProvider>();
    final oldCondition = userProvider.condition;
    await userProvider.updateUser(updated);

    if (oldCondition != _selectedCondition && mounted) {
      await habitsProvider.loadHabitsForCondition(_selectedCondition);
      await recsProvider.loadForCondition(_selectedCondition);
      await eduProvider.loadForCondition(_selectedCondition);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final userName = context.watch<UserProvider>().displayName;
    final initial =
        userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: _bgColor,
      body: Column(
        children: [
          // ── Header con ola ──────────────────────────────────
          _WaveHeader(
            initial: initial,
            onSave: _canSave ? _save : null,
          ),

          // ── Campos ─────────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              children: [
                // Card de información personal
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título sección
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person_outline,
                              color: _green,
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Información personal',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: _green,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Nombre
                      _EditField(
                        icon: Icons.person_outline,
                        label: 'Nombre',
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        onChanged: (_) => setState(() {}),
                      ),
                      const _FieldDivider(),

                      // Fecha de nacimiento
                      _EditField(
                        icon: Icons.calendar_today_outlined,
                        label: 'Fecha de nacimiento',
                        controller: _birthDateController,
                        hint: 'DD-MM-AAAA',
                        keyboardType: TextInputType.datetime,
                      ),
                      const _FieldDivider(),

                      // Estatura
                      _EditField(
                        icon: Icons.straighten,
                        label: 'Estatura',
                        controller: _heightController,
                        hint: 'ej: 158',
                        suffix: 'cm',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                      const _FieldDivider(),

                      // Peso
                      _EditField(
                        icon: Icons.monitor_weight_outlined,
                        label: 'Peso',
                        controller: _weightController,
                        hint: 'ej: 75',
                        suffix: 'kg',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                      const _FieldDivider(),

                      // Sexo
                      _GenderField(
                        selected: _selectedGender,
                        onChanged: (v) => setState(() => _selectedGender = v),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Condición de salud
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite_outline,
                              color: _green,
                              size: 22,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Mi condición',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: _green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...[
                        ('Diabetes', Icons.water_drop_outlined, 'diabetes'),
                        ('Hipertensión', Icons.favorite_outline, 'hypertension'),
                        (
                          'Resistencia a la insulina',
                          Icons.monitor_heart_outlined,
                          'insulin_resistance'
                        ),
                        (
                          'Diabetes e hipertensión',
                          Icons.health_and_safety_outlined,
                          'both'
                        ),
                      ].map(
                        (item) => _ConditionTile(
                          label: item.$1,
                          icon: item.$2,
                          value: item.$3,
                          selected: _selectedCondition == item.$3,
                          onTap: () =>
                              setState(() => _selectedCondition = item.$3),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
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

// ── Wave Header ───────────────────────────────────────────────

class _WaveHeader extends StatelessWidget {
  final String initial;
  final VoidCallback? onSave;

  const _WaveHeader({required this.initial, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _WaveClipper(),
      child: Container(
        height: 200,
        color: const Color(0xFFECF1E5),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Planta decorativa
              Positioned(
                right: 30,
                bottom: 30,
                child: Image.asset(
                  'assets/branding/cat_meditation.png',
                  width: 80,
                  errorBuilder: (ctx, e, s) => const SizedBox.shrink(),
                ),
              ),

              // Barra superior: título + guardar
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFF4A6741),
                        size: 20,
                      ),
                    ),
                    const Text(
                      'Editar perfil',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                    TextButton(
                      onPressed: onSave,
                      child: Text(
                        'Guardar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: onSave != null
                              ? const Color(0xFF6B8F55)
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Avatar centrado
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Center(
                  child: Stack(
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
                          initial,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height - 20,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - 40,
      size.width,
      size.height - 20,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// ── Campo editable ────────────────────────────────────────────

class _EditField extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? suffix;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;

  const _EditField({
    required this.icon,
    required this.label,
    required this.controller,
    this.hint,
    this.suffix,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFF4F7EF),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF6B8F55)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              onChanged: onChanged,
              style: const TextStyle(fontSize: 15, color: Color(0xFF2D2D2D)),
              decoration: InputDecoration(
                labelText: label,
                hintText: hint,
                suffixText: suffix,
                border: InputBorder.none,
                labelStyle: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF888888),
                ),
                suffixStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF888888),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Selector de género ────────────────────────────────────────

class _GenderField extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onChanged;

  const _GenderField({required this.selected, required this.onChanged});

  static const _options = [
    ('Femenino', 'femenino'),
    ('Masculino', 'masculino'),
    ('Otro', 'otro'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFF4F7EF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.wc_outlined,
              size: 18,
              color: Color(0xFF6B8F55),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sexo',
                  style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _options.map((opt) {
                    final isSelected = selected == opt.$2;
                    return GestureDetector(
                      onTap: () => onChanged(opt.$2),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF6B8F55)
                              : const Color(0xFFF4F7EF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          opt.$1,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF5A5A5A),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Condición ─────────────────────────────────────────────────

class _ConditionTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  const _ConditionTile({
    required this.label,
    required this.icon,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF6B8F55);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: selected
                    ? green.withValues(alpha: 0.12)
                    : const Color(0xFFF4F7EF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 18,
                color: selected ? green : const Color(0xFF888888),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                      selected ? FontWeight.bold : FontWeight.normal,
                  color: selected ? green : const Color(0xFF2D2D2D),
                ),
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, color: green, size: 20),
          ],
        ),
      ),
    );
  }
}

class _FieldDivider extends StatelessWidget {
  const _FieldDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, color: Color(0xFFF0F0F0)),
    );
  }
}
