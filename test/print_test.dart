import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:fitness/core/app_repositories.dart';
import 'package:fitness/core/theme.dart';
import 'package:fitness/ui/features/home/view_models/home_view_model.dart';
import 'package:fitness/ui/features/home/views/home_screen.dart';
import 'package:fitness/ui/features/nutrition/view_models/nutrition_view_model.dart';
import 'package:fitness/ui/features/nutrition/views/nutrition_screen.dart';
import 'package:fitness/ui/features/plans/view_models/plans_view_model.dart';
import 'package:fitness/ui/features/plans/views/plans_screen.dart';
import 'package:fitness/ui/features/profile/view_models/profile_view_model.dart';
import 'package:fitness/ui/features/profile/views/profile_screen.dart';
import 'package:fitness/ui/features/progress/view_models/progress_view_model.dart';
import 'package:fitness/ui/features/progress/views/progress_screen.dart';
import 'package:fitness/ui/features/ranking/view_models/ranking_view_model.dart';
import 'package:fitness/ui/features/ranking/views/ranking_screen.dart';
import 'package:fitness/ui/features/workout/view_models/exercise_player_view_model.dart';
import 'package:fitness/ui/features/workout/view_models/workout_detail_view_model.dart';
import 'package:fitness/ui/features/workout/views/exercise_player_screen.dart';
import 'package:fitness/ui/features/workout/views/workout_detail_screen.dart';

import 'golden_utils.dart';

typedef PageBuilder = Widget Function();

/// Captures every screen in light then dark themes and writes real PNGs to
/// `screenshots/`:
///
///   screenshots/fitness.png       -> screen 1 (light)
///   screenshots/fitness-2.png     -> screen 2 (light) … fitness-8.png
///   screenshots/fitness-9.png     -> screen 1 (dark)  … fitness-16.png
///
///   flutter test test/print_test.dart
void main() {
  final pages = <(String, PageBuilder)>[
    (
      'Home',
      () => ChangeNotifierProvider<HomeViewModel>(
            create: (_) => HomeViewModel(repository: appRepositories.workout),
            child: const HomeScreen(),
          ),
    ),
    (
      'Treino',
      () => ChangeNotifierProvider<WorkoutDetailViewModel>(
            create: (_) => WorkoutDetailViewModel(
              repository: appRepositories.workout,
              workoutId: 'w1',
            ),
            child: const WorkoutDetailScreen(),
          ),
    ),
    (
      'Exercicio',
      () => ChangeNotifierProvider<ExercisePlayerViewModel>(
            create: (_) => ExercisePlayerViewModel(
              repository: appRepositories.workout,
              workoutId: 'w1',
            ),
            child: const ExercisePlayerScreen(),
          ),
    ),
    (
      'Progresso',
      () => ChangeNotifierProvider<ProgressViewModel>(
            create: (_) =>
                ProgressViewModel(repository: appRepositories.progress),
            child: const ProgressScreen(),
          ),
    ),
    (
      'Planos',
      () => ChangeNotifierProvider<PlansViewModel>(
            create: (_) => PlansViewModel(repository: appRepositories.plan),
            child: const PlansScreen(),
          ),
    ),
    (
      'Nutricao',
      () => ChangeNotifierProvider<NutritionViewModel>(
            create: (_) =>
                NutritionViewModel(repository: appRepositories.nutrition),
            child: const NutritionScreen(),
          ),
    ),
    (
      'Perfil',
      () => ChangeNotifierProvider<ProfileViewModel>(
            create: (_) =>
                ProfileViewModel(repository: appRepositories.profile),
            child: const ProfileScreen(),
          ),
    ),
    (
      'Ranking',
      () => ChangeNotifierProvider<RankingViewModel>(
            create: (_) =>
                RankingViewModel(repository: appRepositories.ranking),
            child: const RankingScreen(),
          ),
    ),
  ];

  testWidgets('fitness screenshots (claro + escuro)', (tester) async {
    await loadGoldenFonts();
    tester.binding.focusManager.highlightStrategy =
        FocusHighlightStrategy.alwaysTouch;
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    var idx = 0;
    for (final theme in <ThemeData>[AppTheme.light(), AppTheme.dark()]) {
      for (final page in pages) {
        final key = GlobalKey();
        await tester.pumpWidget(
          RepaintBoundary(
            key: key,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: theme,
              home: page.$2(),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 600));

        await tester.runAsync(() async {
          final boundary =
              key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
          final image = await boundary.toImage(pixelRatio: 3.0);
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          final suffix = idx == 0 ? '' : '-${idx + 1}';
          final file = File('screenshots/fitness$suffix.png');
          await file.create(recursive: true);
          await file.writeAsBytes(bytes!.buffer.asUint8List());
        });
        idx++;
      }
    }
  });
}
