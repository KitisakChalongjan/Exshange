import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Authentication with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseFirestore db = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    print(currentUser!.email);
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    print(currentUser!.email);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
