import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
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

    // Debug: Print Google Sign-In availability
    _checkGoogleSignInAvailability();
  }

  Future<void> _checkGoogleSignInAvailability() async {
    try {
      await _googleSignIn.isSignedIn();
      print('DEBUG: Google Sign-In is available');
    } catch (e) {
      print('DEBUG: Google Sign-In availability error: $e');
    }
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

  // Sign in with Google - with detailed debugging
  Future<bool> signInWithGoogle() async {
    try {
      print('DEBUG: Starting Google Sign-In process...');
      _setLoading(true);
      _setError('');

      // Check if Google Play Services are available
      print('DEBUG: Checking Google Sign-In availability...');
      final bool isAvailable = await _googleSignIn.isSignedIn();
      print('DEBUG: Currently signed in: $isAvailable');

      // Start the sign-in process
      print('DEBUG: Initiating sign-in...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('DEBUG: User canceled sign-in');
        _setLoading(false);
        return false;
      }

      print('DEBUG: Google user obtained: ${googleUser.email}');

      // Get authentication tokens
      print('DEBUG: Getting authentication tokens...');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      print('DEBUG: Access token: ${googleAuth.accessToken != null ? "✓" : "✗"}');
      print('DEBUG: ID token: ${googleAuth.idToken != null ? "✓" : "✗"}');

      // Create Firebase credential
      print('DEBUG: Creating Firebase credential...');
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      print('DEBUG: Signing in to Firebase...');
      UserCredential result = await _auth.signInWithCredential(credential);
      _user = result.user;

      print('DEBUG: Firebase sign-in successful: ${_user?.email}');
      _setLoading(false);
      return true;

    } catch (e, stackTrace) {
      print('DEBUG: Google Sign-In error: $e');
      print('DEBUG: Stack trace: $stackTrace');
      _setLoading(false);
      _setError(_getErrorMessage(e.toString()));
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      print('DEBUG: Signing out...');
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      _user = null;
      print('DEBUG: Sign out successful');
    } catch (e) {
      print('DEBUG: Sign out error: $e');
      _setError(_getErrorMessage(e.toString()));
    }
  }

  String _getErrorMessage(String error) {
    print('DEBUG: Processing error: $error');

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
    } else if (error.contains('account-exists-with-different-credential')) {
      return 'An account already exists with the same email but different sign-in credentials.';
    } else if (error.contains('sign_in_canceled')) {
      return 'Sign in was canceled.';
    } else if (error.contains('sign_in_failed')) {
      return 'Google sign in failed. Please try again.';
    } else if (error.contains('network_error')) {
      return 'Network error. Please check your internet connection.';
    } else if (error.contains('GoogleService')) {
      return 'Google Services configuration error. Please contact support.';
    } else {
      return 'An error occurred: $error';
    }
  }
}