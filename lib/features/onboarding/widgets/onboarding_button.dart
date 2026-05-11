import 'package:flutter/material.dart';

/// Botón principal del onboarding — estilo consistente entre pantallas.
class OnboardingButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;

  const OnboardingButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: isPrimary
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(label, style: const TextStyle(fontSize: 16)),
            )
          : TextButton(
              onPressed: onPressed,
              child: Text(label, style: const TextStyle(fontSize: 16)),
            ),
    );
  }
}