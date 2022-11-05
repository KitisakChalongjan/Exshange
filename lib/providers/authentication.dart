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
    print(currentUser!.uid);
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await db.collection('users').doc(currentUser!.uid).set(
      {
        'email': email,
        'name': 'noname',
        'phone': '',
        'userAddressId': '',
        'tradeCount': 0,
        'donateCount': 0,
        'rating': 0.0,
        'favoriteCategories': [],
        'favoriteItems': [],
        'profileImageUrl': 'https://firebasestorage.googleapis.com/v0/b/exshange-project.appspot.com/o/images%2Fperson-icon.png?alt=media&token=e32d807b-eeaa-42cb-89e1-291c0af9e852',
      },
    );
    print('Registered : ${currentUser!.email}');
    print(currentUser!.uid);
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      print('signout');
    } catch (e) {
      print(e.toString());
    }
  }
}
