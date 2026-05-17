import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:project001/theme/app_theme.dart';
import 'package:project001/providers/auth_provider.dart';

/// Step 8 — Notifications Screen
/// Shows school-specific FCM alerts stored in Firestore.
/// Unauthenticated users see public (broadcast) alerts.
/// Logged-in students/admins also see their school's alerts.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.bell, color: Colors.white),
            onPressed: () {},
            tooltip: 'Notifications',
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _buildQuery(user?.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryBlue),
            );
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return _buildEmpty();
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return _NotificationCard(data: data);
            },
          );
        },
      ),
    );
  }

  Stream<QuerySnapshot> _buildQuery(String? uid) {
    // Show latest 50 notifications, ordered by timestamp
    return FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots();
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.bellOff,
              size: 64, color: AppTheme.textLight.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(
              color: AppTheme.textLight,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Disaster alerts and drill notices will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textLight, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _NotificationCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final type = data['type'] as String? ?? 'info';
    final title = data['title'] as String? ?? 'Alert';
    final body = data['body'] as String? ?? '';
    final ts = data['createdAt'] as Timestamp?;

    final color = _colorFor(type);
    final icon = _iconFor(type);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Color stripe
          Container(
            width: 6,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppTheme.textDark,
                                ),
                              ),
                            ),
                            _TypeBadge(type: type, color: color),
                          ],
                        ),
                        if (body.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            body,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textLight,
                              height: 1.4,
                            ),
                          ),
                        ],
                        if (ts != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            _formatTime(ts.toDate()),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.textLight.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _colorFor(String type) {
    switch (type) {
      case 'emergency':
        return AppTheme.alertRed;
      case 'drill':
        return AppTheme.warningOrange;
      case 'safe':
        return AppTheme.safeGreen;
      default:
        return AppTheme.primaryBlue;
    }
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'emergency':
        return LucideIcons.alertTriangle;
      case 'drill':
        return LucideIcons.siren;
      case 'safe':
        return LucideIcons.checkCircle;
      default:
        return LucideIcons.info;
    }
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _TypeBadge extends StatelessWidget {
  final String type;
  final Color color;
  const _TypeBadge({required this.type, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        type.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
