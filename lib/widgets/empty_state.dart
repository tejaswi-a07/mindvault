import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.buttonText,
    this.onButtonPressed,
  });

  factory EmptyStateWidget.vaultEmpty({VoidCallback? onCapture}) {
    return EmptyStateWidget(
      title: 'Your vault is quiet.',
      subtitle: 'Capture something worth remembering.',
      icon: Icons.inventory_2_outlined,
      buttonText: 'Capture Memory',
      onButtonPressed: onCapture,
    );
  }

  factory EmptyStateWidget.searchEmpty({VoidCallback? onClear}) {
    return EmptyStateWidget(
      title: 'Nothing surfaced.',
      subtitle: 'Try another memory, topic, or keyword.',
      icon: Icons.search_off_rounded,
      buttonText: onClear != null ? 'Clear Search' : null,
      onButtonPressed: onClear,
    );
  }

  factory EmptyStateWidget.capsulesEmpty({VoidCallback? onCreate}) {
    return EmptyStateWidget(
      title: 'No time capsules yet.',
      subtitle: 'Seal a message for your future self to uncover.',
      icon: Icons.lock_clock_outlined,
      buttonText: 'Create Capsule',
      onButtonPressed: onCreate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E202E) : const Color(0xFFF1F3FA),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? const Color(0xFF2C2E42) : const Color(0xFFE2E5F0),
                ),
              ),
              child: Icon(
                icon,
                size: 36,
                color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                height: 1.4,
              ),
            ),
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryViolet,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(buttonText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
