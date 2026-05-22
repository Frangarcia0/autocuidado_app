import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'shared/providers/user_provider.dart';
import 'shared/providers/habits_provider.dart';
<<<<<<< HEAD
import 'shared/providers/recommendations_provider.dart';
=======
>>>>>>> 5ee850ee38f487473e9db5bcbe8b5157d187fb34

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => HabitsProvider()),
<<<<<<< HEAD
        ChangeNotifierProvider(create: (_) => RecommendationsProvider()),
=======
>>>>>>> 5ee850ee38f487473e9db5bcbe8b5157d187fb34
      ],
      child: const _AppWithInit(),
    );
  }
}

<<<<<<< HEAD
=======
/// Widget separado que inicializa datos al arrancar la app
>>>>>>> 5ee850ee38f487473e9db5bcbe8b5157d187fb34
class _AppWithInit extends StatefulWidget {
  const _AppWithInit();

  @override
  State<_AppWithInit> createState() => _AppWithInitState();
}

class _AppWithInitState extends State<_AppWithInit> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
<<<<<<< HEAD
    final userProvider = context.read<UserProvider>();
    await userProvider.loadUser();

    if (mounted) {
      final condition = userProvider.condition;
      await context.read<HabitsProvider>().loadHabitsForCondition(condition);
      await context.read<RecommendationsProvider>().loadForCondition(condition);
=======
    // Carga el perfil del usuario
    final userProvider = context.read<UserProvider>();
    await userProvider.loadUser();

    // Carga hábitos según la condición del usuario
    if (mounted) {
      final condition = userProvider.condition;
      context.read<HabitsProvider>().loadHabitsForCondition(condition);
>>>>>>> 5ee850ee38f487473e9db5bcbe8b5157d187fb34
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Eira',
      theme: AppTheme.light,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
