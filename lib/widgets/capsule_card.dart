import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/capsule.dart';
import '../theme/app_theme.dart';

class CapsuleCard extends StatelessWidget {
  final TimeCapsule capsule;
  final VoidCallback onOpen;

  const CapsuleCard({
    super.key,
    required this.capsule,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isUnlocked = capsule.isReadyToUnlock || capsule.isOpened;
    final unlockDateStr = DateFormat('MMMM yyyy').format(capsule.unlockDate);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isUnlocked ? onOpen : null,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isUnlocked
                ? (isDark ? const Color(0xFF1E1B3A) : const Color(0xFFF5F3FF))
                : theme.cardTheme.color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isUnlocked
                  ? AppTheme.primaryViolet.withOpacity(0.5)
                  : (isDark ? const Color(0xFF28293D) : const Color(0xFFE8EAF2)),
              width: isUnlocked ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isUnlocked
                    ? AppTheme.primaryViolet.withOpacity(0.12)
                    : Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isUnlocked
                          ? AppTheme.primaryViolet.withOpacity(0.15)
                          : (isDark ? const Color(0xFF232433) : const Color(0xFFEFF1F7)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        isUnlocked ? '✨' : '🔒',
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          capsule.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isUnlocked
                              ? 'Your future self left you something'
                              : 'Opens: $unlockDateStr',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isUnlocked
                                ? AppTheme.primaryViolet
                                : (isDark ? Colors.white54 : const Color(0xFF6B7280)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isUnlocked)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF252638) : const Color(0xFFEDEFF7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${capsule.daysRemaining}d left',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white70 : const Color(0xFF4B5563),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF13141C) : Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? const Color(0xFF222330) : const Color(0xFFE5E7EB),
                  ),
                ),
                child: isUnlocked
                    ? Row(
                        children: [
                          Expanded(
                            child: Text(
                              capsule.message.split('\n').first,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: onOpen,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryViolet,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            icon: const Icon(Icons.lock_open_rounded, size: 14),
                            label: const Text('Reveal', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 16,
                            color: isDark ? Colors.white38 : Colors.black38,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'This memory is sealed in time.',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: isDark ? Colors.white38 : Colors.black45,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
