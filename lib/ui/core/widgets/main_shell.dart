import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fitness/core/app_repositories.dart';
import 'package:fitness/ui/core/widgets/tab_scope.dart';
import 'package:fitness/ui/features/home/view_models/home_view_model.dart';
import 'package:fitness/ui/features/home/views/home_screen.dart';
import 'package:fitness/ui/features/plans/view_models/plans_view_model.dart';
import 'package:fitness/ui/features/plans/views/plans_screen.dart';
import 'package:fitness/ui/features/profile/view_models/profile_view_model.dart';
import 'package:fitness/ui/features/profile/views/profile_screen.dart';
import 'package:fitness/ui/features/progress/view_models/progress_view_model.dart';
import 'package:fitness/ui/features/progress/views/progress_screen.dart';

/// Root tab container: a [BottomNavigationBar] over an [IndexedStack] so each
/// tab keeps its state. This is the app's home destination in the router.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _goToTab(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    final tabs = <Widget>[
      ChangeNotifierProvider<HomeViewModel>(
        create: (_) => HomeViewModel(repository: appRepositories.workout),
        child: const HomeScreen(),
      ),
      ChangeNotifierProvider<PlansViewModel>(
        create: (_) => PlansViewModel(repository: appRepositories.plan),
        child: const PlansScreen(),
      ),
      ChangeNotifierProvider<ProgressViewModel>(
        create: (_) => ProgressViewModel(repository: appRepositories.progress),
        child: const ProgressScreen(),
      ),
      ChangeNotifierProvider<ProfileViewModel>(
        create: (_) => ProfileViewModel(repository: appRepositories.profile),
        child: const ProfileScreen(),
      ),
    ];

    return TabScope(
      goToTab: _goToTab,
      child: Scaffold(
        body: IndexedStack(index: _index, children: tabs),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: _goToTab,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center_rounded),
              label: 'Treinos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insights_rounded),
              label: 'Progresso',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
