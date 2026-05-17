import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:project001/theme/app_theme.dart';
import 'package:project001/screens/notifications_screen.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

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
                'Alerts',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Past notifications from your school',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const NotificationsScreen()),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'View all',
                          style: TextStyle(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(LucideIcons.chevronRight,
                            size: 14, color: AppTheme.primaryBlue),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _AlertListItem(
                    icon: LucideIcons.moveRight, // Closest to running person
                    label: 'EVACUATE',
                    time: 'Today • 11:30 AM',
                    title: 'Earthquake drill — evacuate to main field immediately.',
                    school: 'DPS Patna',
                    color: AppTheme.alertRed,
                  ),
                  _AlertListItem(
                    icon: LucideIcons.checkCircle2,
                    label: 'ALL CLEAR',
                    time: 'Today • 11:48 AM',
                    title: 'All clear. Return to classrooms.',
                    school: 'DPS Patna',
                    color: AppTheme.safeGreen,
                  ),
                  _AlertListItem(
                    icon: LucideIcons.home,
                    label: 'SHELTER',
                    time: 'Yesterday • 3:15 PM',
                    title: 'Heavy rain warning. Shelter in place.',
                    school: 'DPS Patna',
                    color: AppTheme.warningOrange,
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

class _AlertListItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String time;
  final String title;
  final String school;
  final Color color;

  const _AlertListItem({
    required this.icon,
    required this.label,
    required this.time,
    required this.title,
    required this.school,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  school,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
