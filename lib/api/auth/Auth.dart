import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/pages/home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  Future<String> register(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Send verification email
      await userCredential.user!.sendEmailVerification();
      return "success - Please verify your email";
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      switch (e.code) {
        case 'email-already-in-use':
          return 'An account already exists with this email';

        case 'invalid-email':
          return 'Invalid email address format';

        case 'operation-not-allowed':
          return 'Email/password accounts are not enabled';

        case 'weak-password':
          return 'Password is too weak. Please use a stronger password';

        case 'network-request-failed':
          return 'Network error. Please check your connection';

        default:
          print("Firebase Auth Error: ${e.code}");
          return 'Registration failed: ${e.message}';
      }
    } catch (e) {
      // Handle any other errors
      print("Registration error: $e");
      return 'An unexpected error occurred. Please try again';
    }
  }

  Future<String> login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user!.emailVerified) {
        print("Email verified user");
        return "success";
      } else {
        // Resend verification email if needed
        print("Email not verified. Sending verification link...");
        await userCredential.user!.sendEmailVerification();
        return "Please verify your email first. Verification email sent again on your registered email ID.";
      }
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException Code: ${e.code}"); // Debug print

      if (e.code == 'wrong-password') {
        return 'The password entered is incorrect.';
      } else if (e.code == 'user-not-found') {
        return 'No user found with this email.';
      } else if (e.code == 'invalid-email') {
        return 'Invalid email format.';
      } else if (e.code == 'user-disabled') {
        return 'This user account has been disabled.';
      } else if (e.code == 'too-many-requests') {
        return 'Too many failed login attempts. Please try again later.';
      } else if (e.code == 'operation-not-allowed') {
        return 'Email & Password sign-in is not enabled.';
      } else if (e.code == 'network-request-failed') {
        return 'Network error. Please check your connection.';
      } else {
        print("Unhandled FirebaseAuthException: ${e.code}");
        return "Login error: ${e.code}";
      }
    } catch (e) {
      print("Unexpected error during login: $e");
      return "Login failed. Please try again.";
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print("could not logout user");
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      return  FirebaseAuth.instance.currentUser;
    } catch (e) {
      print("could not get current user");
      return null;
    }
  }

  Future<String> passwordReset(String email) async {
  try {
    // Trim and clean the email
    String trimmedEmail = email.trim().toLowerCase();

    // Check if the email is not empty after trimming
    if (trimmedEmail.isEmpty) {
      return 'Please enter a valid email address.';
    }

    // api to call and check whether email exists in postgres or not

    // If user exists, attempt to send the password reset email
    await FirebaseAuth.instance.sendPasswordResetEmail(email: trimmedEmail);

    // If successful, return this message
    return 'Password reset link sent! Check your email';

  } on FirebaseAuthException catch (e) {
    // Handle specific Firebase Auth errors
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email address format';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      default:
        print("Firebase Auth Error: ${e.code}");
        return 'Failed to send password reset link: ${e.message}';
    }
  } catch (e) {
    // Catch any unexpected errors
    print("Password reset error: $e");
    return 'An unexpected error occurred';
  }
}

  /*
  1. add a google provider to your authentication of  firebase project 
  2. provide the sha-1 key and the replace the android file (google-services.json) from android/app and add GoogleService-info.plist into ios/Runner
  3. Inject the following code  
  */
  Future<void> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      // User cancelled the sign-in
      return;
    }

    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Sign in/up with Firebase
    await FirebaseAuth.instance.signInWithCredential(credential);

    // If successful, navigate to the desired screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()), // Replace HomeScreen with your destination screen
    );
  } catch (e) {
    print('Could not sign in through Google because of exception -> $e');
  }
}

}
