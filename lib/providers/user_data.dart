import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/main.dart';
import 'package:exshange/models/user.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserData with ChangeNotifier {
  
  FirebaseFirestore db = FirebaseFirestore.instance;

  final User? user = FirebaseAuth.instance.currentUser;

  UserModel? _userModel;

  UserModel? get userModel {
    return _userModel;
  }

  void clearUserModel() async {
    _userModel = null;
  }

  Future<void> fetchUserData() async {
    String userId = user!.uid;
    List<Map<String, dynamic>> addresses = [];
    String email;
    var loadedUserDataRef = db.collection('users').doc('${userId}');
    var emailData = await loadedUserDataRef.get();
    email = emailData['email'];
    var addressesData = await loadedUserDataRef.collection('addresses').get();
    addressesData.docs.forEach((snapshot) {
      addresses.add(snapshot.data());
    });
    _userModel = UserModel(userId, addresses, email);
    print('Fetch User\'s Data Successful!');
    notifyListeners();
  }
}
