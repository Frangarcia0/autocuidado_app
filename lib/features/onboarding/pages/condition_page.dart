import 'package:flutter/material.dart';

class ConditionPage extends StatelessWidget {
  final String? selectedCondition;
  final ValueChanged<String> onSelected;

  const ConditionPage({
    super.key,
    required this.selectedCondition,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '¿Cuál es tu condición?',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'Personalizaremos los consejos según tu situación.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          _ConditionOption(
            label: 'Diabetes',
            icon: Icons.water_drop,
            value: 'diabetes',
            selected: selectedCondition == 'diabetes',
            onTap: () => onSelected('diabetes'),
          ),
          const SizedBox(height: 12),
          _ConditionOption(
            label: 'Hipertensión',
            icon: Icons.favorite,
            value: 'hypertension',
            selected: selectedCondition == 'hypertension',
            onTap: () => onSelected('hypertension'),
          ),
          const SizedBox(height: 12),
          _ConditionOption(
            label: 'Resistencia a la insulina',
            icon: Icons.monitor_heart,
            value: 'insulin_resistance',
            selected: selectedCondition == 'insulin_resistance',
            onTap: () => onSelected('insulin_resistance'),
          ),
          const SizedBox(height: 12),
          _ConditionOption(
            label: 'Diabetes e hipertensión',
            icon: Icons.health_and_safety,
            value: 'both',
            selected: selectedCondition == 'both',
            onTap: () => onSelected('both'),
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
          color: selected ? color.withAlpha((0.08 * 255).round()) : null,
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
