import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/quick_capture_sheet.dart';
import 'home_screen.dart';
import 'vault_screen.dart';
import 'connect_screen.dart';
import 'capsules_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    VaultScreen(),
    ConnectScreen(),
    CapsulesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 800;

        if (isDesktop) {
          // Desktop & Tablet Navigation Rail Layout
          return Scaffold(
            body: Row(
              children: [
                // Left Navigation Rail
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) {
                    setState(() => _currentIndex = index);
                  },
                  backgroundColor: isDark ? const Color(0xFF13141E) : Colors.white,
                  minWidth: 72,
                  minExtendedWidth: 200,
                  extended: constraints.maxWidth >= 1050,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryViolet,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            if (constraints.maxWidth >= 1050) ...[
                              const SizedBox(width: 10),
                              const Text(
                                'MINDVAULT',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 24),
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
              const VerticalDivider(width: 1, thickness: 1),
              // Main Screen Area
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _screens[_currentIndex],
                ),
              ),
            ],
          ),
        );
      }

      // Mobile Navigation Bar Layout
      return Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _screens[_currentIndex],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          elevation: 2,
          backgroundColor: isDark ? const Color(0xFF13141F) : Colors.white,
          indicatorColor: AppTheme.primaryViolet.withOpacity(0.15),
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home_rounded, color: AppTheme.primaryViolet),
              label: 'Home',
            ),
            NavigationDestination(
              icon: const Icon(Icons.inventory_2_outlined),
              selectedIcon: const Icon(Icons.inventory_2_rounded, color: AppTheme.primaryViolet),
              label: 'Vault',
            ),
            NavigationDestination(
              icon: const Icon(Icons.hub_outlined),
              selectedIcon: const Icon(Icons.hub_rounded, color: AppTheme.primaryViolet),
              label: 'Connect',
            ),
            NavigationDestination(
              icon: const Icon(Icons.lock_clock_outlined),
              selectedIcon: const Icon(Icons.lock_clock_rounded, color: AppTheme.primaryViolet),
              label: 'Capsules',
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline_rounded),
              selectedIcon: const Icon(Icons.person_rounded, color: AppTheme.primaryViolet),
              label: 'Profile',
            ),
          ],
        ),
        floatingActionButton: _currentIndex != 2 // Hide on Connect graph to give full canvas
            ? FloatingActionButton(
                onPressed: () => QuickCaptureSheet.show(context),
                backgroundColor: AppTheme.primaryViolet,
                foregroundColor: Colors.white,
                child: const Icon(Icons.add_rounded, size: 28),
              )
            : null,
      );
    });
  }
}
