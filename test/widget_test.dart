import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:fitness/data/repositories/workout_repository.dart';
import 'package:fitness/data/services/workout_api_service.dart';
import 'package:fitness/ui/features/home/view_models/home_view_model.dart';
import 'package:fitness/ui/features/home/views/home_screen.dart';

Widget _wrap() => MaterialApp(
      home: ChangeNotifierProvider(
        create: (_) => HomeViewModel(
          repository: WorkoutRepository(api: WorkoutApiService()),
        ),
        child: const HomeScreen(),
      ),
    );

void main() {
  testWidgets('renders home header and today workouts', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(500, 1200);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_wrap());
    await tester.pump();

    expect(find.text('Ana Souza'), findsOneWidget);
    expect(find.text('Full Body Power'), findsOneWidget);
  });

  testWidgets('shows seeded goal and play buttons', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(500, 1200);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_wrap());
    await tester.pump();

    expect(find.text('Meta diária'), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow_rounded), findsWidgets);
  });
}
