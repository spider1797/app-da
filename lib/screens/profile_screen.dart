import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:project001/theme/app_theme.dart';
import 'package:project001/providers/auth_provider.dart';
import 'package:project001/screens/qr_checkin_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showLogin = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.isAuthenticated) {
      return _LoggedInView(auth: auth);
    }

    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _showLogin
              ? _LoginView(
                  key: const ValueKey('login'),
                  onToggle: () => setState(() => _showLogin = false),
                )
              : _JoinView(
                  key: const ValueKey('join'),
                  onLoginTap: () => setState(() => _showLogin = true),
                ),
        ),
      ),
    );
  }
}

// ─── Logged In View ───────────────────────────────────────────────────────────

class _LoggedInView extends StatelessWidget {
  final AuthProvider auth;
  const _LoggedInView({required this.auth});

  @override
  Widget build(BuildContext context) {
    final profile = auth.userProfile;
    final name = profile?['name'] ?? auth.user?.displayName ?? 'User';
    final email = auth.user?.email ?? '';
    final role = profile?['role'] ?? 'Student';
    final schoolCode = profile?['schoolCode'] ?? '-';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.user,
                  size: 60,
                  color: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Info Cards
              _InfoRow(label: 'Role', value: role, icon: LucideIcons.shieldCheck),
              const SizedBox(height: 12),
              _InfoRow(label: 'School Code', value: schoolCode, icon: LucideIcons.school),

              // Admin-only: QR Drill Check-in
              if (role.toLowerCase() == 'admin') ...
                [
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const QrCheckinScreen(),
                        ));
                      },
                      icon: const Icon(LucideIcons.qrCode, size: 20),
                      label: const Text('Start Drill QR Check-in'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],

              const Spacer(),

              // Logout button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => auth.logout(),
                  icon: const Icon(LucideIcons.logOut, color: AppTheme.alertRed),
                  label: const Text(
                    'Logout',
                    style: TextStyle(color: AppTheme.alertRed, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.alertRed),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryBlue, size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
        ],
      ),
    );
  }
}

// ─── Join View ─────────────────────────────────────────────────────────────────

class _JoinView extends StatelessWidget {
  final VoidCallback onLoginTap;
  const _JoinView({super.key, required this.onLoginTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Icon(LucideIcons.shield, size: 80, color: AppTheme.primaryBlue),
          ),
          const SizedBox(height: 24),
          const Text(
            'Join App-da',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 16),
          const Text(
            'Create an account to track progress,\nearn badges, and join your school\'s\ndrills.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 16, height: 1.4),
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const _RegisterPage(),
                ));
              },
              child: const Text('Register'),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onLoginTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryBlue,
                side: const BorderSide(color: AppTheme.primaryBlue, width: 2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              child: const Text('Login'),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'Continue as guest',
              style: TextStyle(color: AppTheme.textSecondary, decoration: TextDecoration.underline),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Login View ────────────────────────────────────────────────────────────────

class _LoginView extends StatefulWidget {
  final VoidCallback onToggle;
  const _LoginView({super.key, required this.onToggle});

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.login(email: _emailCtrl.text, password: _passCtrl.text);
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Login failed'),
          backgroundColor: AppTheme.alertRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text('Welcome Back',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
          const SizedBox(height: 8),
          const Text('Login to continue', style: TextStyle(color: AppTheme.textSecondary)),
          const SizedBox(height: 32),
          _buildLabel('Email'),
          _buildTextField(_emailCtrl, 'you@school.in', false),
          const SizedBox(height: 16),
          _buildLabel('Password'),
          _buildTextField(_passCtrl, '••••••••', true),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: auth.isLoading ? null : _login,
              child: auth.isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Login'),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: GestureDetector(
              onTap: widget.onToggle,
              child: const Text.rich(TextSpan(
                text: 'Don\'t have an account? ',
                style: TextStyle(color: AppTheme.textSecondary),
                children: [
                  TextSpan(text: 'Register', style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold)),
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
      );

  Widget _buildTextField(TextEditingController ctrl, String hint, bool obscure) {
    return TextField(
      controller: ctrl,
      obscureText: obscure ? _obscure : false,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.withValues(alpha: 0.05),
        suffixIcon: obscure
            ? IconButton(
                icon: Icon(_obscure ? LucideIcons.eyeOff : LucideIcons.eye, size: 18, color: AppTheme.textSecondary),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppTheme.primaryBlue)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

// ─── Register Page ─────────────────────────────────────────────────────────────

class _RegisterPage extends StatefulWidget {
  const _RegisterPage();

  @override
  State<_RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<_RegisterPage> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _schoolCtrl = TextEditingController();
  String _selectedRole = 'Student';
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _schoolCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_nameCtrl.text.isEmpty || _emailCtrl.text.isEmpty ||
        _passCtrl.text.isEmpty || _schoolCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields'), backgroundColor: AppTheme.warningOrange),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      email: _emailCtrl.text,
      password: _passCtrl.text,
      name: _nameCtrl.text,
      role: _selectedRole,
      schoolCode: _schoolCtrl.text,
    );

    if (mounted) {
      if (success) {
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(auth.errorMessage ?? 'Registration failed'), backgroundColor: AppTheme.alertRed),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(LucideIcons.arrowLeft),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: 16),
              // Role toggle
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: ['Student', 'Admin'].map((role) {
                    final isSelected = _selectedRole == role;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedRole = role),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            role,
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppTheme.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 32),
              _buildField('Full name', _nameCtrl, 'Rahul Kumar', false),
              const SizedBox(height: 16),
              _buildField('Email', _emailCtrl, 'you@school.in', false),
              const SizedBox(height: 16),
              _buildField('Password', _passCtrl, '••••••••', true),
              const SizedBox(height: 16),
              _buildField('School code', _schoolCtrl, 'DPS492', false),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: auth.isLoading ? null : _register,
                  child: auth.isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Create Account'),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text.rich(TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(color: AppTheme.textSecondary),
                    children: [
                      TextSpan(text: 'Login', style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold)),
                    ],
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, String hint, bool obscure) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          obscureText: obscure ? _obscure : false,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey.withValues(alpha: 0.05),
            suffixIcon: obscure
                ? IconButton(
                    icon: Icon(_obscure ? LucideIcons.eyeOff : LucideIcons.eye, size: 18, color: AppTheme.textSecondary),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppTheme.primaryBlue)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}
