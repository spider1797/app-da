import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Register with email, password, name, role, schoolCode
  Future<String?> register({
    required String email,
    required String password,
    required String name,
    required String role,
    required String schoolCode,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Update display name
      await credential.user!.updateDisplayName(name.trim());

      // Save user profile to Firestore
      await _db.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'name': name.trim(),
        'email': email.trim(),
        'role': role,
        'schoolCode': schoolCode.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null; // null means success
    } on FirebaseAuthException catch (e) {
      return _getErrorMessage(e.code);
    } catch (e) {
      return 'Something went wrong. Please try again.';
    }
  }

  // Login with email and password
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null; // null means success
    } on FirebaseAuthException catch (e) {
      return _getErrorMessage(e.code);
    } catch (e) {
      return 'Something went wrong. Please try again.';
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Get user profile from Firestore
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      return null;
    }
  }

  // Map Firebase error codes to readable messages
  String _getErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered. Please login.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Invalid email or password. Please try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'No internet connection. Please check your network.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
