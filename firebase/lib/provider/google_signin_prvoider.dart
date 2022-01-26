import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  late bool _isSigningIn;
  //it will help in showing progress bar

  bool get isSigningIn => _isSigningIn;
  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  GoogleSignInProvider() {
    _isSigningIn = false;
  }
  Future login() async {
    _isSigningIn = true;
    final user = await googleSignIn.signIn();
    if (user == null) {
      _isSigningIn = false;
      return;
    } else {
      final googleAuth = await user.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      isSigningIn = false;
    }
  }

  void logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
