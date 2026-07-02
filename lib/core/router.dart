import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:fitness/core/app_repositories.dart';
import 'package:fitness/ui/core/widgets/main_shell.dart';
import 'package:fitness/ui/features/nutrition/view_models/nutrition_view_model.dart';
import 'package:fitness/ui/features/nutrition/views/nutrition_screen.dart';
import 'package:fitness/ui/features/ranking/view_models/ranking_view_model.dart';
import 'package:fitness/ui/features/ranking/views/ranking_screen.dart';
import 'package:fitness/ui/features/workout/view_models/exercise_player_view_model.dart';
import 'package:fitness/ui/features/workout/view_models/workout_detail_view_model.dart';
import 'package:fitness/ui/features/workout/views/exercise_player_screen.dart';
import 'package:fitness/ui/features/workout/views/workout_detail_screen.dart';

/// Declarative navigation with go_router.
///
/// The [MainShell] (bottom-navigation tabs) is the home destination; workout,
/// exercise, plan, nutrition and ranking are pushed on top of it.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const MainShell(),
    ),
    GoRoute(
      path: '/workout/:id',
      builder: (context, state) => ChangeNotifierProvider<WorkoutDetailViewModel>(
        create: (_) => WorkoutDetailViewModel(
          repository: appRepositories.workout,
          workoutId: state.pathParameters['id'],
        ),
        child: const WorkoutDetailScreen(),
      ),
    ),
    GoRoute(
      // A plan opens a representative session, reusing the workout detail view.
      path: '/plan/:id',
      builder: (context, state) => ChangeNotifierProvider<WorkoutDetailViewModel>(
        create: (_) =>
            WorkoutDetailViewModel(repository: appRepositories.workout),
        child: const WorkoutDetailScreen(),
      ),
    ),
    GoRoute(
      path: '/exercise/:id',
      builder: (context, state) =>
          ChangeNotifierProvider<ExercisePlayerViewModel>(
        create: (_) => ExercisePlayerViewModel(
          repository: appRepositories.workout,
          workoutId: state.pathParameters['id'],
        ),
        child: const ExercisePlayerScreen(),
      ),
    ),
    GoRoute(
      path: '/nutrition',
      builder: (context, state) => ChangeNotifierProvider<NutritionViewModel>(
        create: (_) =>
            NutritionViewModel(repository: appRepositories.nutrition),
        child: const NutritionScreen(),
      ),
    ),
    GoRoute(
      path: '/ranking',
      builder: (context, state) => ChangeNotifierProvider<RankingViewModel>(
        create: (_) => RankingViewModel(repository: appRepositories.ranking),
        child: const RankingScreen(),
      ),
    ),
  ],
);
