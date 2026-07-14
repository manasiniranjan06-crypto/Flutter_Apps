import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class SignUpUserModel {
  // String name = '';
  // String email = '';
  // String password = '';
  // String confirmPassword = '';
}

class SignUpController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  final SignUpUserModel userModel = SignUpUserModel();
  
  String? nameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  // Validate email format
  // bool _isValidEmail(String email) {
  //   return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  // }

  // Validate inputs
  // bool validateInputs() {
  //   nameError = null;
  //   emailError = null;
  //   passwordError = null;
  //   confirmPasswordError = null;

  //   bool isValid = true;

  //   if (userModel.name.isEmpty) {
  //     nameError = 'Name is required';
  //     isValid = false;
  //   } else if (userModel.name.length < 2) {
  //     nameError = 'Name must be at least 2 characters';
  //     isValid = false;
  //   }

  //   if (userModel.email.isEmpty) {
  //     emailError = 'Email is required';
  //     isValid = false;
  //   } else if (!_isValidEmail(userModel.email)) {
  //     emailError = 'Enter a valid email address';
  //     isValid = false;
  //   }

  //   if (userModel.password.isEmpty) {
  //     passwordError = 'Password is required';
  //     isValid = false;
  //   } else if (userModel.password.length < 6) {
  //     passwordError = 'Password must be at least 6 characters';
  //     isValid = false;
  //   }

  //   if (userModel.confirmPassword.isEmpty) {
  //     confirmPasswordError = 'Please confirm your password';
  //     isValid = false;
  //   } else if (userModel.password != userModel.confirmPassword) {
  //     confirmPasswordError = 'Passwords do not match';
  //     isValid = false;
  //   }

  //   return isValid;
  // }

  // Sign up with email and password
   signUp(String email,String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      // if (userCredential.user != null) {
      //   // Update display name
      //   await userCredential.user!.updateDisplayName(name);
        
      //   // Send email verification
      //   await userCredential.user!.sendEmailVerification();
        
      //   debugPrint('Sign up successful: ${userCredential.user!.email}');
      //   return true;
      // }
      // return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code}');
      
      switch (e.code) {
        case 'email-already-in-use':
          emailError = 'This email is already registered';
          break;
        case 'invalid-email':
          emailError = 'Invalid email address';
          break;
        case 'operation-not-allowed':
          emailError = 'Email/password accounts are not enabled';
          break;
        case 'weak-password':
          passwordError = 'Password is too weak';
          break;
        default:
          passwordError = 'Sign up failed: ${e.message}';
      }
      return false;
    } catch (e) {
      debugPrint('Error during sign up: $e');
      passwordError = 'An unexpected error occurred';
      return false;
    }
  }



  // Social sign up handler
  Future<bool> socialSignUp(String provider) async {
    try {
      if (provider == 'Google') {
        return await signUpWithGoogle();
      } else if (provider == 'Facebook') {
        debugPrint('Facebook sign-up not implemented yet');
        return false;
      } else if (provider == 'Apple') {
        debugPrint('Apple sign-up not implemented yet');
        return false;
      }
      return false;
    } catch (e) {
      debugPrint('Social sign up error: $e');
      return false;
    }
  }

  // Google Sign-Up
  Future<bool> signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        debugPrint('Google sign-up successful: ${userCredential.user!.email}');
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException during Google sign-up: ${e.code}');
      return false;
    } catch (e) {
      debugPrint('Error during Google sign-up: $e');
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
}