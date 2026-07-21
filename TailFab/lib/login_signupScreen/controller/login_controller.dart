import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class UserModel {
  String email = '';
  String password = '';
}

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  final UserModel userModel = UserModel();
  
  String? emailError;
  String? passwordError;

  // Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validate inputs
  bool validateInputs() {
    emailError = null;
    passwordError = null;

    if (userModel.email.isEmpty) {
      emailError = 'Email is required';
      return false;
    }

    if (!_isValidEmail(userModel.email)) {
      emailError = 'Enter a valid email address';
      return false;
    }

    if (userModel.password.isEmpty) {
      passwordError = 'Password is required';
      return false;
    }

    if (userModel.password.length < 6) {
      passwordError = 'Password must be at least 6 characters';
      return false;
    }

    return true;
  }

  // Login with email and password
  Future<bool> login() async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: userModel.email.trim(),
        password: userModel.password,
      );
      
      if (userCredential.user != null) {
        debugPrint('Login successful: ${userCredential.user!.email}');
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code}');
      
      switch (e.code) {
        case 'user-not-found':
          emailError = 'No user found with this email';
          break;
        case 'wrong-password':
          passwordError = 'Incorrect password';
          break;
        case 'invalid-email':
          emailError = 'Invalid email address';
          break;
        case 'user-disabled':
          emailError = 'This account has been disabled';
          break;
        case 'too-many-requests':
          passwordError = 'Too many attempts. Try again later';
          break;
        case 'invalid-credential':
          passwordError = 'Invalid email or password';
          break;
        default:
          passwordError = 'Login failed: ${e.message}';
      }
      return false;
    } catch (e) {
      debugPrint('Error during login: $e');
      passwordError = 'An unexpected error occurred';
      return false;
    }
  }

  // Social login handler
  Future<bool> socialLogin(String provider) async {
    try {
      if (provider == 'Google') {
        return await signInWithGoogle();
      } else if (provider == 'Facebook') {
        // Implement Facebook sign-in
        debugPrint('Facebook sign-in not implemented yet');
        return false;
      } else if (provider == 'Apple') {
        // Implement Apple sign-in
        debugPrint('Apple sign-in not implemented yet');
        return false;
      }
      return false;
    } catch (e) {
      debugPrint('Social login error: $e');
      return false;
    }
  }

  // Google Sign-In
  Future<bool> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User canceled the sign-in
        return false;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        debugPrint('Google sign-in successful: ${userCredential.user!.email}');
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException during Google sign-in: ${e.code}');
      return false;
    } catch (e) {
      debugPrint('Error during Google sign-in: $e');
      return false;
    }
  }

  // Password reset
  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint('Password reset error: ${e.code}');
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _auth.currentUser != null;
  }
}