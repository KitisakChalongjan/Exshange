import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/main.dart';
import 'package:exshange/models/user.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

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
    String email;
    String name;
    String phone;
    List<Map<String, dynamic>> addresses = [];
    int tradeCount;
    int donateCount;
    double rating;
    List<dynamic> favoriteCategories;
    List<dynamic> favoriteItems;
    String profileImageUrl;

    var usersRef = db.collection('users').doc('${userId}');
    var userAddressRef =
        db.collection('userAddress').where('userId', isEqualTo: user!.uid);

    var usersSnapshot = await usersRef.get();
    var userAddresSnapshot = await userAddressRef.get();

    var usersData = usersSnapshot.data()!;

    email = usersData['email'];
    name = usersData['name'];
    phone = usersData['phone'];
    for (var element in userAddresSnapshot.docs) {
      addresses.add(element.data());
    }
    tradeCount = usersData['tradeCount'];
    donateCount = usersData['donateCount'];
    rating = usersData['rating'];
    favoriteCategories = usersData['favoriteCategories'];
    favoriteItems = usersData['favoriteItems'];
    profileImageUrl = usersData['profileImageUrl'];

    _userModel = UserModel(
      userId,
      email,
      name,
      phone,
      addresses,
      tradeCount,
      donateCount,
      rating,
      favoriteCategories,
      favoriteItems,
      profileImageUrl,
    );

    print('UserId(${_userModel!.userId})');
    print('Fetch User\'s Data Successful!');
    notifyListeners();
  }

  
}
