import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/services/preferences_service.dart';
import 'pages/welcome_page.dart';
import 'pages/disclaimer_page.dart';
import 'pages/condition_page.dart';
import 'pages/basic_info_page.dart';
import 'widgets/onboarding_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final PreferencesService _prefs = PreferencesService();

  int _currentPage = 0;
  String? _selectedCondition;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  bool get _canAdvance {
    if (_currentPage == 2) return _selectedCondition != null;
    if (_currentPage == 3) {
      return _nameController.text.trim().isNotEmpty &&
          int.tryParse(_ageController.text) != null;
    }
    return true;
  }

  void _next() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    await _prefs.saveUserProfile(
      name: _nameController.text.trim(),
      age: int.parse(_ageController.text),
      condition: _selectedCondition!,
    );
    await _prefs.setOnboardingCompleted();
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Indicador de progreso
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: List.generate(4, (i) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: i <= _currentPage
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            // Páginas
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  const WelcomePage(),
                  const DisclaimerPage(),
                  ConditionPage(
                    selectedCondition: _selectedCondition,
                    onSelected: (v) => setState(() => _selectedCondition = v),
                  ),
                  BasicInfoPage(
                    nameController: _nameController,
                    ageController: _ageController,
                  ),
                ],
              ),
            ),
            // Botón inferior
            Padding(
              padding: const EdgeInsets.all(24),
              child: OnboardingButton(
                label: _currentPage == 3 ? 'Comenzar' : 'Continuar',
                onPressed: _canAdvance ? _next : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}