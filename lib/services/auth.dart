import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signInWithEmail(String email, String password);
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signInWithEmail(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = await _firebaseAuth.currentUser();
    return await user.getIdToken(refresh: true);
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}