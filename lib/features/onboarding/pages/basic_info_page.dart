import 'package:flutter/material.dart';

class BasicInfoPage extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController ageController;

  const BasicInfoPage({
    super.key,
    required this.nameController,
    required this.ageController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Cuéntanos un poco sobre ti',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Tu nombre',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Tu edad',
              prefixIcon: Icon(Icons.cake_outlined),
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}