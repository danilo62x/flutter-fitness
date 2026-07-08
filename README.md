# Flutter Fitness

[Leia em português](./README.pt-BR.md)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE) ![Free](https://img.shields.io/badge/price-free-brightgreen)

Flutter Fitness is a free workout and activity tracking UI template built with Flutter 3.44 and Material 3. It has 8 screens with light and dark themes: a home with a daily goal ring and activity stats, a workout detail with the exercise list, an exercise player with a circular timer, a progress screen with line charts and achievements, training plans by level, a nutrition screen with macros and water intake, a profile, and a ranking with a podium. Charts and rings are drawn with CustomPaint, no chart package required. All data is local mock data, so the app runs with no backend, and the http service stubs mark where a real API would plug in. It is part of the free tier of the [template.dev.br](https://template.dev.br) catalog.

## Screens

8 screens plus a tab shell (`lib/ui/core/widgets/main_shell.dart`):

- Home (`home_screen.dart`): daily goal ring, activity stats and today's workouts.
- Workout (`workout_detail_screen.dart`): workout detail with the exercise list.
- Exercise (`exercise_player_screen.dart`): exercise player with a circular countdown timer.
- Progress (`progress_screen.dart`): line charts of metrics over time and achievements.
- Plans (`plans_screen.dart`): training plans grouped by level.
- Nutrition (`nutrition_screen.dart`): daily macros, meals and water tracking.
- Profile (`profile_screen.dart`): user data and settings.
- Ranking (`ranking_screen.dart`): leaderboard with a podium.

### Screenshots

The `screenshots/` folder has 16 captures. A sample:

![Home](screenshots/fitness.png)
![Workout](screenshots/fitness-2.png)
![Exercise](screenshots/fitness-3.png)
![Progress](screenshots/fitness-4.png)
![Plans](screenshots/fitness-5.png)
![Nutrition](screenshots/fitness-6.png)

## Tech stack

- Flutter 3.44, stable channel (pinned through FVM in `.fvmrc`)
- Dart SDK `^3.12.2`
- Material 3 (`useMaterial3: true`, `ColorScheme.fromSeed`)
- go_router `^17.3.0`: declarative routing
- provider `^6.1.5+1`: state management (MVVM view models)
- http `^1.6.0`: API service layer
- intl `^0.20.3`: number and date formatting
- cupertino_icons `^1.0.8`
- flutter_lints `^6.0.0` (dev)

Exact resolved versions are in `pubspec.lock`. Target platforms included in the repo: Android, iOS, web and Windows.

## Requirements

- Flutter SDK, stable channel. The lockfile requires Flutter 3.38 or newer; the template was built against 3.44.
- Dart 3.12.2 or newer (bundled with the Flutter SDK).
- Platform tooling for your target: Android Studio and the Android SDK, Xcode for iOS, Chrome for web, or Visual Studio with the C++ workload for Windows.
- Optional: [FVM](https://fvm.app). The repo has a `.fvmrc` pinning the stable channel, so `fvm use` selects a matching SDK.

## How to run

```bash
flutter pub get
flutter run
```

Pick a device with `flutter run -d chrome` (web), `flutter run -d windows`, or a device id from `flutter devices`.

Release builds:

```bash
flutter build apk       # Android
flutter build ipa       # iOS (requires macOS and Xcode)
flutter build web       # Web
flutter build windows   # Windows
```

With FVM, prefix the commands: `fvm flutter pub get`, `fvm flutter run`. Run the widget tests with `flutter test`.

## Project structure

```
lib/
  main.dart               # entry point
  app.dart                # MaterialApp.router, light/dark theme wiring
  core/
    app_repositories.dart # composition root: builds the repository graph once
    router.dart           # go_router route table
    theme.dart            # Material 3 theme (seed color, component themes)
  data/
    models/               # API models with fromJson/toJson
    repositories/         # workout, plan, progress, nutrition, profile, ranking
    services/             # http-based API service stubs
  domain/
    models/               # Workout, Exercise, TrainingPlan, NutritionDay, Meal,
                          # Macro, MetricSeries, Achievement, RankedUser, UserProfile
  ui/
    core/widgets/         # shared widgets, CustomPaint charts, tab shell
    features/<feature>/   # views/ (screens) and view_models/ per feature
```

## Theming and customization

The theme lives in `lib/core/theme.dart`. Light and dark schemes are generated from a single seed color:

```dart
static const Color seed = Color(0xFF16A34A); // green
```

Change `seed` to re-skin the app: `ColorScheme.fromSeed` derives every surface and accent color for both brightnesses. The font family is Roboto, set in the same file, along with component themes for the app bar, filled buttons and cards (rounded corners, flat elevation). `app.dart` passes `AppTheme.light()` and `AppTheme.dark()` to `MaterialApp.router`, so the app follows the system theme mode. The goal rings and line charts in `lib/ui/core/widgets/charts.dart` take their colors from the active `ColorScheme`, so they follow the seed as well.

## State management

MVVM with provider. Each screen has a `ChangeNotifier` view model under `lib/ui/features/<feature>/view_models/`, provided through `ChangeNotifierProvider` in `lib/core/router.dart` and the tab shell. Repositories are built once in `lib/core/app_repositories.dart` (the composition root) and shared with the router and the shell; they return mock data through the API-shaped services in `lib/data/services/`.

## Support this project

This template is free and MIT licensed. Donations keep the free templates maintained and updated to new Flutter releases: https://template.dev.br/doar?template=flutter-fitness

## More templates

The full catalog, free and premium, is at https://template.dev.br.

## License

[MIT](./LICENSE), © 2026 Danilo Quinelato.
