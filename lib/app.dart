import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'shared/providers/user_provider.dart';
import 'shared/providers/habits_provider.dart';
import 'shared/providers/recommendations_provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => HabitsProvider()),
        ChangeNotifierProvider(create: (_) => RecommendationsProvider()),
      ],
      child: const _AppWithInit(),
    );
  }
}

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
    final userProvider = context.read<UserProvider>();
    await userProvider.loadUser();

    if (mounted) {
      final condition = userProvider.condition;
      await context.read<HabitsProvider>().loadHabitsForCondition(condition);
      await context.read<RecommendationsProvider>().loadForCondition(condition);
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
