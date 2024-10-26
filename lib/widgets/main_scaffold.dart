import 'package:flatwork/config/config.dart';
import 'package:flatwork/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final bottomNavigationIndexProvider = StateProvider<int>((ref) => 0);

class MainScaffold extends ConsumerWidget {
  final Widget child;

  const MainScaffold({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavigationIndexProvider);
    final colors = context.colorScheme;

    return SafeArea(
      child: Scaffold(
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: colors.primary, // Background color of the navigation bar
          selectedItemColor: Colors.white, // Color of the selected icon and text
          unselectedItemColor: Colors.grey, // Color of the unselected icons and text
          selectedIconTheme: const IconThemeData(size: 30, color: Colors.white), // Size and color of selected icons
          unselectedIconTheme: const IconThemeData(size: 24, color: Colors.grey), // Size and color of unselected icons
          // selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold), // Style for selected labels
          // unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal), // Style for unselected labels
          currentIndex: currentIndex,
          onTap: (index) {
            ref.read(bottomNavigationIndexProvider.notifier).state = index;
            switch (index) {
              case 0:
                context.goNamed(RouteLocation.home);
                break;
              case 1:
                context.goNamed(RouteLocation.projects);
                break;
              case 2:
                context.goNamed(RouteLocation.settings);
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work),
              label: 'Projects',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
