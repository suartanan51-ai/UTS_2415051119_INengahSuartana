import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'task_list_screen.dart';
import 'completed_screen.dart';
import 'profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key, required this.databaseConfigured});
  final bool databaseConfigured;

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(databaseConfigured: widget.databaseConfigured),
      const TaskListScreen(),
      const CompletedScreen(),
      const ProfileScreen(),
    ];
    return LayoutBuilder(builder: (context, constraints) {
      final wide = constraints.maxWidth >= 700;
      if (wide) {
        return Scaffold(
          body: Row(children: [
            NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: (value) => setState(() => _index = value),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: Text('Home')),
                NavigationRailDestination(icon: Icon(Icons.assignment_outlined), selectedIcon: Icon(Icons.assignment), label: Text('Tugas')),
                NavigationRailDestination(icon: Icon(Icons.task_alt), label: Text('Selesai')),
                NavigationRailDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: Text('Profil')),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: pages[_index]),
          ]),
        );
      }
      return Scaffold(
        body: pages[_index],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (value) => setState(() => _index = value),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.assignment_outlined), selectedIcon: Icon(Icons.assignment), label: 'Tugas'),
            NavigationDestination(icon: Icon(Icons.task_alt), label: 'Selesai'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      );
    });
  }
}
