import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/quick_capture_sheet.dart';
import 'capsules_screen.dart';
import 'connect_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'vault_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  static const _screens = <Widget>[
    HomeScreen(),
    VaultScreen(),
    ConnectScreen(),
    CapsulesScreen(),
    ProfileScreen(),
  ];

  void _selectTab(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;
        final isWide = constraints.maxWidth >= 1150;

        if (isDesktop) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: _selectTab,
                  backgroundColor: isDark ? AppTheme.darkSurface : Colors.white,
                  indicatorColor: AppTheme.primaryViolet.withOpacity(0.14),
                  minWidth: 78,
                  minExtendedWidth: 220,
                  extended: isWide,
                  leading: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 20, 12, 28),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppTheme.primaryViolet, AppTheme.primaryVioletLight],
                                ),
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
                            ),
                            if (isWide) ...[
                              const SizedBox(width: 10),
                              const Text(
                                'MINDVAULT',
                                style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2, fontSize: 15),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 22),
                        FloatingActionButton.small(
                          onPressed: () => QuickCaptureSheet.show(context),
                          backgroundColor: AppTheme.primaryViolet,
                          foregroundColor: Colors.white,
                          tooltip: 'Quick Capture',
                          child: const Icon(Icons.add_rounded),
                        ),
                      ],
                    ),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.inventory_2_outlined),
                      selectedIcon: Icon(Icons.inventory_2_rounded),
                      label: Text('Vault'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.hub_outlined),
                      selectedIcon: Icon(Icons.hub_rounded),
                      label: Text('Connect'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.lock_clock_outlined),
                      selectedIcon: Icon(Icons.lock_clock_rounded),
                      label: Text('Capsules'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline_rounded),
                      selectedIcon: Icon(Icons.person_rounded),
                      label: Text('Profile'),
                    ),
                  ],
                ),
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: KeyedSubtree(
                      key: ValueKey(_currentIndex),
                      child: _screens[_currentIndex],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: KeyedSubtree(
              key: ValueKey(_currentIndex),
              child: _screens[_currentIndex],
            ),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            elevation: 2,
            backgroundColor: isDark ? AppTheme.darkSurface : Colors.white,
            indicatorColor: AppTheme.primaryViolet.withOpacity(0.14),
            onDestinationSelected: _selectTab,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2_rounded), label: 'Vault'),
              NavigationDestination(icon: Icon(Icons.hub_outlined), selectedIcon: Icon(Icons.hub_rounded), label: 'Connect'),
              NavigationDestination(icon: Icon(Icons.lock_clock_outlined), selectedIcon: Icon(Icons.lock_clock_rounded), label: 'Capsules'),
              NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Profile'),
            ],
          ),
          floatingActionButton: _currentIndex == 2
              ? null
              : FloatingActionButton(
                  onPressed: () => QuickCaptureSheet.show(context),
                  tooltip: 'Quick Capture',
                  child: const Icon(Icons.add_rounded, size: 28),
                ),
        );
      },
    );
  }
}
