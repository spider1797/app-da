import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:project001/theme/app_theme.dart';
import 'package:project001/providers/auth_provider.dart';
import 'package:project001/services/deep_link_service.dart';

/// Step 7: QR Code screen for Admin
/// Generates a deep-link QR code for drill check-in.
/// Students scan this QR → app opens → attendance recorded in Firestore.
class QrCheckinScreen extends StatefulWidget {
  const QrCheckinScreen({super.key});

  @override
  State<QrCheckinScreen> createState() => _QrCheckinScreenState();
}

class _QrCheckinScreenState extends State<QrCheckinScreen>
    with SingleTickerProviderStateMixin {
  String? _drillId;
  String? _schoolCode;
  String? _qrData;
  bool _isCreating = false;
  int _checkinCount = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _startDrillCheckin() async {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;
    if (user == null) return;

    setState(() => _isCreating = true);

    try {
      // Fetch school code from Firestore user profile
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final data = userDoc.data();
      final school = data?['schoolCode'] as String? ?? 'SCHOOL';

      // Create a drill session in Firestore
      final drillRef =
          await FirebaseFirestore.instance.collection('drills').add({
        'schoolCode': school,
        'adminUid': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'type': 'fire', // default — admin can change
        'status': 'active',
        'checkins': [],
      });

      final uri = DeepLinkService.buildCheckinUri(
        schoolCode: school,
        drillId: drillRef.id,
      );

      setState(() {
        _drillId = drillRef.id;
        _schoolCode = school;
        _qrData = uri.toString();
        _isCreating = false;
      });

      // Live-listen to check-in count
      FirebaseFirestore.instance
          .collection('drills')
          .doc(drillRef.id)
          .snapshots()
          .listen((snap) {
        if (!mounted) return;
        final checkins = snap.data()?['checkins'] as List<dynamic>? ?? [];
        setState(() => _checkinCount = checkins.length);
      });
    } catch (e) {
      setState(() => _isCreating = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.alertRed,
          ),
        );
      }
    }
  }

  Future<void> _closeDrill() async {
    if (_drillId == null) return;
    await FirebaseFirestore.instance
        .collection('drills')
        .doc(_drillId!)
        .update({'status': 'closed'});
    setState(() {
      _drillId = null;
      _qrData = null;
      _schoolCode = null;
      _checkinCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        title: const Text(
          'Drill QR Check-in',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _qrData == null ? _buildStartView() : _buildQrView(),
    );
  }

  Widget _buildStartView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.qrCode,
              size: 50,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Start a Drill Session',
            style: AppTheme.headingStyle.copyWith(
              fontSize: 22,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Generate a QR code that students scan to mark attendance for today\'s drill.',
            textAlign: TextAlign.center,
            style: AppTheme.bodyStyle.copyWith(color: AppTheme.textLight),
          ),
          const SizedBox(height: 48),
          _buildInfoCard(
            LucideIcons.scan,
            'Students scan QR',
            'Each student opens the App-da app and scans this code.',
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            LucideIcons.checkCircle,
            'Automatic check-in',
            'Attendance is recorded instantly in Firestore.',
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            LucideIcons.barChart2,
            'Real-time count',
            'See how many students have checked in live.',
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isCreating ? null : _startDrillCheckin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isCreating
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      'Generate QR Code',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.primaryBlue, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(desc,
                    style: TextStyle(
                        fontSize: 12, color: AppTheme.textLight)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Live checkin count
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              color: AppTheme.safeGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                  color: AppTheme.safeGreen.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.users,
                    color: AppTheme.safeGreen, size: 18),
                const SizedBox(width: 8),
                Text(
                  '$_checkinCount students checked in',
                  style: const TextStyle(
                    color: AppTheme.safeGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // QR Code with pulse animation
          ScaleTransition(
            scale: _pulseAnim,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: QrImageView(
                data: _qrData!,
                version: QrVersions.auto,
                size: 240,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: AppTheme.primaryBlue,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Color(0xFF1a1a2e),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Session info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1)),
            ),
            child: Column(
              children: [
                _buildInfoRow('School Code', _schoolCode ?? '-'),
                const Divider(height: 20),
                _buildInfoRow('Drill ID',
                    _drillId != null ? '${_drillId!.substring(0, 8)}...' : '-'),
                const Divider(height: 20),
                _buildInfoRow('Status', '🟢 Active'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'Show this QR code on the projector or pass the phone to students.',
            textAlign: TextAlign.center,
            style: AppTheme.bodyStyle
                .copyWith(color: AppTheme.textLight, fontSize: 13),
          ),
          const SizedBox(height: 32),

          // Close drill button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _closeDrill,
              icon: const Icon(LucideIcons.xCircle, color: AppTheme.alertRed),
              label: const Text(
                'Close Drill Session',
                style: TextStyle(
                    color: AppTheme.alertRed, fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: AppTheme.alertRed, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(color: AppTheme.textLight, fontSize: 13)),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppTheme.textDark)),
      ],
    );
  }
}
