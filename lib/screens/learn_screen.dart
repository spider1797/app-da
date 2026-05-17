import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:project001/theme/app_theme.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Learn',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                'Disaster safety modules',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _ModuleListItem(
                    icon: LucideIcons.sun,
                    title: 'Heatwave',
                    subtitle: 'Extreme heat ...',
                    level: 'MEDIUM',
                    color: AppTheme.warningOrange,
                  ),
                  _ModuleListItem(
                    icon: LucideIcons.cloudLightning,
                    title: 'Lightning',
                    subtitle: 'Thunderstorm saf...',
                    level: 'LOW',
                    color: AppTheme.safeGreen,
                  ),
                  _ModuleListItem(
                    icon: LucideIcons.users,
                    title: 'Stampede',
                    subtitle: 'Crowd safety proc...',
                    level: 'LOW',
                    color: AppTheme.safeGreen,
                  ),
                  _ModuleListItem(
                    icon: LucideIcons.flaskConical,
                    title: 'Chemical',
                    subtitle: 'Hazardous spill re...',
                    level: 'LOW',
                    color: AppTheme.safeGreen,
                  ),
                  _ModuleListItem(
                    icon: LucideIcons.bug,
                    title: 'Epidemic',
                    subtitle: 'Disease outbreak ...',
                    level: 'LOW',
                    color: AppTheme.safeGreen,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String level;
  final Color color;

  const _ModuleListItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.level,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              level,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
