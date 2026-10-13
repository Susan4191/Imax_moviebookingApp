import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:imax_movie_ticket_booking/firebase_options.dart';
import 'package:imax_movie_ticket_booking/utils/app_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthService {
  Future<FirebaseAuth?> _getAuthInstance() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      return FirebaseAuth.instance;
    } catch (e) {
      try {
        if (Firebase.apps.isEmpty) {
          await Firebase.initializeApp();
        }
        return FirebaseAuth.instance;
      } catch (err) {
        debugPrint('Firebase init error: $err');
        return null;
      }
    }
  }

  User? get currentUser {
    try {
      if (Firebase.apps.isNotEmpty) {
        return FirebaseAuth.instance.currentUser;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Stream<User?> get authStateChanges {
    try {
      if (Firebase.apps.isNotEmpty) {
        return FirebaseAuth.instance.authStateChanges();
      }
      return const Stream.empty();
    } catch (_) {
      return const Stream.empty();
    }
  }

  /// Create account with Email, Password, and Display Name in Firebase Authentication
  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final auth = await _getAuthInstance();
      if (auth == null) {
        AppToast.showError(
          'Firebase Auth is not connected. Please verify Firebase setup.',
        );
        return null;
      }

      final UserCredential credential = await auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      final User? user = credential.user;

      if (user != null && name != null && name.trim().isNotEmpty) {
        await user.updateDisplayName(name.trim());
        await user.reload();
      }

      return auth.currentUser ?? user;
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Failed to create account';
      if (e.code == 'weak-password') {
        errorMessage =
            'The password provided is too weak (at least 6 characters required).';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'An account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      } else if (e.code == 'operation-not-allowed') {
        errorMessage =
            'Email/Password accounts are not enabled in Firebase Console.';
      } else if (e.message != null && e.message!.isNotEmpty) {
        errorMessage = e.message!;
      }
      AppToast.showError(errorMessage);
      return null;
    } catch (e) {
      AppToast.showError('An error occurred during account creation: $e');
      return null;
    }
  }

  /// Sign in with Email and Password in Firebase Authentication
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final auth = await _getAuthInstance();
      if (auth == null) {
        AppToast.showError(
          'Firebase Auth is not connected. Please verify Firebase setup.',
        );
        return null;
      }

      final UserCredential credential = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Authentication failed';
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        errorMessage = 'Invalid email or password.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address format is invalid.';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'This user account has been disabled.';
      } else if (e.message != null && e.message!.isNotEmpty) {
        errorMessage = e.message!;
      }
      AppToast.showError(errorMessage);
      return null;
    } catch (e) {
      AppToast.showError('An error occurred during login: $e');
      return null;
    }
  }

  /// Sign out current user from Firebase & Local Storage
  Future<void> signOut() async {
    try {
      if (Firebase.apps.isNotEmpty) {
        await FirebaseAuth.instance.signOut();
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      await prefs.remove('userRole');
      await prefs.remove('userEmail');
      AppToast.showInfo('Signed out successfully');
    } catch (e) {
      AppToast.showError('Error signing out: $e');
    }
  }
}
