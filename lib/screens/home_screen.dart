import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:project001/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'App-da',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(LucideIcons.mapPin, size: 16, color: AppTheme.primaryBlue),
                        const SizedBox(width: 4),
                        const Text(
                          'Patna, Bihar',
                          style: TextStyle(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // High Risk Alert Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.alertRed,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'HIGH RISK',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Icon(LucideIcons.alertTriangle, color: Colors.white),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.globe, color: Colors.white, size: 28),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Earthquake',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Bihar lies in Zones IV-V. Drop,\nCover, Hold On.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'View safety guide',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(LucideIcons.arrowRight, color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Other Risks Section
              const Text(
                'OTHER RISKS',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),

              // Grid of Risks
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  _RiskCard(
                    icon: LucideIcons.wind,
                    title: 'Cyclone',
                    level: 'LOW',
                    color: AppTheme.safeGreen,
                  ),
                  _RiskCard(
                    icon: LucideIcons.mountain,
                    title: 'Landslide',
                    level: 'LOW',
                    color: AppTheme.safeGreen,
                  ),
                  _RiskCard(
                    icon: LucideIcons.sun,
                    title: 'Heatwave',
                    level: 'MEDIUM',
                    color: AppTheme.warningOrange,
                  ),
                  _RiskCard(
                    icon: LucideIcons.cloudLightning,
                    title: 'Lightning',
                    level: 'LOW',
                    color: AppTheme.safeGreen,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Join School Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Join your school\nfor drills',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Enter your school code\nto receive live alerts.',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Join'),
                    ),
                    const SizedBox(width: 12),
                    const Icon(LucideIcons.x, color: AppTheme.textSecondary),
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

class _RiskCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String level;
  final Color color;

  const _RiskCard({
    required this.icon,
    required this.title,
    required this.level,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
