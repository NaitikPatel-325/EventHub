import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;

  Future googleLogin() async {
    await dotenv.load(fileName: ".env");
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        return;
      }

      _user = googleUser;
      print("User signed in: ${_user!.email}");

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final userCredential = await _auth.signInWithCredential(credential);

      // Print additional Firebase user information
      print("Firebase User ID: ${userCredential.user?.uid}");
      print("Firebase User Email: ${userCredential.user?.email}");
      print("Firebase User Display Name: ${userCredential.user?.displayName}");

      // Notify listeners to update the UI
      notifyListeners();
    } catch (e) {
      print("Error during Google Sign-In: ${e.toString()}");
    }
  }

  Future logout() async {
    await googleSignIn.disconnect();
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
