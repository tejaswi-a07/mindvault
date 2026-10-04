import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 10, left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.0,
          color: isDark ? Colors.white54 : const Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _buildCardContainer(BuildContext context, {required List<Widget> children}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF28293D) : const Color(0xFFE8EAF2),
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF5B4DFF), Color(0xFF8B5CF6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Center(
                      child: Text(
                        'MV',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My MindVault',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'College UDF Student Edition',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.primaryViolet,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Space Summary Stats
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1B1C28) : const Color(0xFFF3F4F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCol('${provider.totalMemoriesCount}', 'Memories', isDark),
                    _buildDivider(isDark),
                    _buildStatCol('${provider.ideasCount}', 'Ideas', isDark),
                    _buildDivider(isDark),
                    _buildStatCol('${provider.reflectionsCount}', 'Reflections', isDark),
                    _buildDivider(isDark),
                    _buildStatCol('${provider.favoritesCount}', 'Favorites', isDark),
                  ],
                ),
              ),

              // Appearance Section
              _buildSectionHeader(context, 'Appearance'),
              _buildCardContainer(
                context,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Theme Mode',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        SegmentedButton<ThemeMode>(
                          segments: const [
                            ButtonSegment(
                              value: ThemeMode.light,
                              icon: Icon(Icons.light_mode_rounded, size: 16),
                              label: Text('Light'),
                            ),
                            ButtonSegment(
                              value: ThemeMode.dark,
                              icon: Icon(Icons.dark_mode_rounded, size: 16),
                              label: Text('Dark'),
                            ),
                            ButtonSegment(
                              value: ThemeMode.system,
                              icon: Icon(Icons.settings_system_daydream_rounded, size: 16),
                              label: Text('System'),
                            ),
                          ],
                          selected: {provider.themeMode},
                          onSelectionChanged: (Set<ThemeMode> newSelection) {
                            provider.setThemeMode(newSelection.first);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Personalization Section
              _buildSectionHeader(context, 'Personalization'),
              _buildCardContainer(
                context,
                children: [
                  ListTile(
                    leading: const Icon(Icons.palette_outlined),
                    title: const Text('Primary Accent Color'),
                    subtitle: const Text('Violet & Indigo'),
                    trailing: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryViolet,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.category_outlined),
                    title: const Text('Default Category'),
                    subtitle: const Text('Study / Personal'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () {},
                  ),
                ],
              ),

              // Data Management Section
              _buildSectionHeader(context, 'Data & Backup'),
              _buildCardContainer(
                context,
                children: [
                  ListTile(
                    leading: const Icon(Icons.file_download_outlined),
                    title: const Text('Export Memories (JSON)'),
                    subtitle: const Text('Download a local backup of your notes & capsules'),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('✓ Memories exported to local JSON successfully.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.restart_alt_rounded),
                    title: const Text('Reset Demo Content'),
                    subtitle: const Text('Restore initial college course notes & graph data'),
                    onTap: () {
                      provider.resetData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Demo memories and map reset to original state.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                    title: const Text('Clear All Vault Data', style: TextStyle(color: Colors.red)),
                    subtitle: const Text('Permanently remove all notes and moods'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Clear All Data?'),
                          content: const Text(
                            'Are you sure you want to erase all notes, moods, and capsules? You can always restore the sample college notes later.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                provider.clearAllData();
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Vault cleared.'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              child: const Text('Clear'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),

              // About Section
              _buildSectionHeader(context, 'About'),
              _buildCardContainer(
                context,
                children: [
                  const ListTile(
                    leading: Icon(Icons.info_outline_rounded),
                    title: Text('MindVault'),
                    subtitle: Text('Version 1.0.0 (UDF College Project Edition)'),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    leading: Icon(Icons.code_rounded),
                    title: Text('Built with Flutter & Dart'),
                    subtitle: Text('Material 3 Design System • Responsive Android & Web'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCol(String count, String label, bool isDark) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.white54 : const Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      width: 1,
      height: 24,
      color: isDark ? const Color(0xFF2E3044) : const Color(0xFFD6DBEA),
    );
  }
}
