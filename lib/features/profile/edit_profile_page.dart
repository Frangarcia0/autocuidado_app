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
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String _selectedCondition = 'diabetes';

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user;
    if (user != null) {
      _nameController.text = user.name;
      _ageController.text = user.age.toString();
      _selectedCondition = user.condition;
      if (user.height != null) {
        _heightController.text = user.height!.toStringAsFixed(1);
      }
      if (user.weight != null) {
        _weightController.text = user.weight!.toStringAsFixed(1);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  bool get _canSave {
    return _nameController.text.trim().isNotEmpty &&
        int.tryParse(_ageController.text) != null;
  }

  Future<void> _save() async {
    final updated = UserModel(
      name: _nameController.text.trim(),
      age: int.parse(_ageController.text),
      condition: _selectedCondition,
      height: double.tryParse(_heightController.text),
      weight: double.tryParse(_weightController.text),
    );

    final userProvider = context.read<UserProvider>();
    final oldCondition = userProvider.condition;
    await userProvider.updateUser(updated);

    if (oldCondition != _selectedCondition && mounted) {
      await context.read<HabitsProvider>().loadHabitsForCondition(
        _selectedCondition,
      );
      await context.read<RecommendationsProvider>().loadForCondition(
        _selectedCondition,
      );
      await context.read<EducationProvider>().loadForCondition(
        _selectedCondition,
      );
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar perfil')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Nombre
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nombre',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),

          // Edad
          TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Edad',
              prefixIcon: Icon(Icons.cake_outlined),
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),

          // Estatura y peso en fila
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _heightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Estatura (cm)',
                    prefixIcon: Icon(Icons.height),
                    border: OutlineInputBorder(),
                    hintText: 'ej: 170',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Peso (kg)',
                    prefixIcon: Icon(Icons.monitor_weight_outlined),
                    border: OutlineInputBorder(),
                    hintText: 'ej: 70',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Opcionales — nos ayudan a personalizar mejor tus recomendaciones.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),

          // Condición
          Text('Mi condición', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          _ConditionOption(
            label: 'Diabetes',
            icon: Icons.water_drop,
            value: 'diabetes',
            selected: _selectedCondition == 'diabetes',
            onTap: () => setState(() => _selectedCondition = 'diabetes'),
          ),
          const SizedBox(height: 8),
          _ConditionOption(
            label: 'Hipertensión',
            icon: Icons.favorite,
            value: 'hypertension',
            selected: _selectedCondition == 'hypertension',
            onTap: () => setState(() => _selectedCondition = 'hypertension'),
          ),
          const SizedBox(height: 8),
          _ConditionOption(
            label: 'Resistencia a la insulina',
            icon: Icons.monitor_heart,
            value: 'insulin_resistance',
            selected: _selectedCondition == 'insulin_resistance',
            onTap: () => setState(() => _selectedCondition = 'insulin_resistance'),
          ),
          const SizedBox(height: 8),
          _ConditionOption(
            label: 'Diabetes e hipertensión',
            icon: Icons.health_and_safety,
            value: 'both',
            selected: _selectedCondition == 'both',
            onTap: () => setState(() => _selectedCondition = 'both'),
          ),
          const SizedBox(height: 32),

          // Botón guardar
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _canSave ? _save : null,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Guardar cambios',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConditionOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  const _ConditionOption({
    required this.label,
    required this.icon,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: selected ? color.withOpacity(0.08) : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? color : Colors.grey),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (selected) Icon(Icons.check_circle, color: color),
          ],
        ),
      ),
    );
  }
}
