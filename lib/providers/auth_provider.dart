import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project001/services/auth_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthStatus _status = AuthStatus.initial;
  User? _user;
  Map<String, dynamic>? _userProfile;
  String? _errorMessage;

  AuthStatus get status => _status;
  User? get user => _user;
  Map<String, dynamic>? get userProfile => _userProfile;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _status == AuthStatus.loading;

  AuthProvider() {
    // Listen to auth state changes
    _authService.authStateChanges.listen((User? user) async {
      _user = user;
      if (user != null) {
        _status = AuthStatus.authenticated;
        _userProfile = await _authService.getUserProfile(user.uid);
      } else {
        _status = AuthStatus.unauthenticated;
        _userProfile = null;
      }
      notifyListeners();
    });
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String role,
    required String schoolCode,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final error = await _authService.register(
      email: email,
      password: password,
      name: name,
      role: role,
      schoolCode: schoolCode,
    );

    if (error != null) {
      _status = AuthStatus.unauthenticated;
      _errorMessage = error;
      notifyListeners();
      return false;
    }
    return true;
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final error = await _authService.login(
      email: email,
      password: password,
    );

    if (error != null) {
      _status = AuthStatus.unauthenticated;
      _errorMessage = error;
      notifyListeners();
      return false;
    }
    return true;
  }

  Future<void> logout() async {
    await _authService.logout();
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
