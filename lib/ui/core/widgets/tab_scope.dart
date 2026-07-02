import 'package:flutter/material.dart';

/// Lets descendant screens (e.g. Home quick actions) switch the active tab of
/// the [MainShell] without depending on it. Resolves to `null` when a screen is
/// shown standalone (such as in the screenshot test), so callers no-op safely.
class TabScope extends InheritedWidget {
  const TabScope({
    super.key,
    required this.goToTab,
    required super.child,
  });

  final ValueChanged<int> goToTab;

  static TabScope? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TabScope>();

  @override
  bool updateShouldNotify(TabScope oldWidget) => false;
}
