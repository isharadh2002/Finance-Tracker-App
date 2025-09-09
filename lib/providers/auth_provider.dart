import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isLoading = false;
  String _errorMessage = '';

  User? get user => _user;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null;

  AuthProvider() {
    // Listen to authentication state changes
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  // Register with email and password
  Future<bool> register(String email, String password, String name) async {
    try {
      _setLoading(true);
      _setError('');

      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user profile with name
      await result.user?.updateDisplayName(name);
      _user = result.user;

      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError(_getErrorMessage(e.toString()));
      return false;
    }
  }

  // Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    try {
      _setLoading(true);
      _setError('');

      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = result.user;
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError(_getErrorMessage(e.toString()));
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null;
    } catch (e) {
      _setError(_getErrorMessage(e.toString()));
    }
  }

  // Convert Firebase error codes to user-friendly messages
  String _getErrorMessage(String error) {
    if (error.contains('weak-password')) {
      return 'The password is too weak.';
    } else if (error.contains('email-already-in-use')) {
      return 'An account already exists for this email.';
    } else if (error.contains('invalid-email')) {
      return 'Please enter a valid email address.';
    } else if (error.contains('user-not-found')) {
      return 'No user found for this email.';
    } else if (error.contains('wrong-password')) {
      return 'Wrong password provided.';
    } else if (error.contains('invalid-credential')) {
      return 'Invalid email or password.';
    } else {
      return 'An error occurred. Please try again.';
    }
  }
}