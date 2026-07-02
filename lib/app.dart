import 'package:flutter/material.dart';

import 'package:fitness/core/router.dart';
import 'package:fitness/core/theme.dart';

/// Root widget. Wires the Material 3 theme with declarative routing (go_router).
class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Fitness Template',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: appRouter,
    );
  }
}
