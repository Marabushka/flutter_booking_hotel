import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _fAuth = FirebaseAuth.instance;

  User? get getCurrentUser => _fAuth.currentUser;
  String? _errorMessage;
  String? _errorRegisterMessage;
  String? get errorMessage => _errorMessage;
  String? get errorRegisterMessage => _errorRegisterMessage;

  Future<void> registerInWithEmail(
      {required String email, required String password}) async {
    try {
      await _fAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print(e);
      _errorRegisterMessage = 'Неправильный формат логина';
    }
  }

  Future<void> singInInWithEmail(
      {required String email, required String password}) async {
    try {
      await _fAuth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      _errorMessage = 'Неправильный логин или пароль';

      notifyListeners();
    }
  }

  Future logOut() async {
    await _fAuth.signOut();
  }

  Stream<User?> get authChanges => _fAuth.authStateChanges();
}
