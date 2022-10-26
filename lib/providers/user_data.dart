import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/main.dart';
import 'package:exshange/models/user.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class UserData with ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;

  UserModel? _userModel;

  UserModel? get userModel {
    return _userModel;
  }

  void clearUserModel() async {
    _userModel = null;
  }

  Future<String> fetchUserData(String uid) async {
    print('startFetchUserData');
    String userId = uid;

    var usersRef = db.collection('users').doc('${userId}');
    var userAddressRef =
        db.collection('userAddress').where('userId', isEqualTo: userId);

    var usersSnapshot = await usersRef.get();
    print('usersSnapshotOk');
    var userAddresSnapshot = await userAddressRef.get();
    print('userAddresSnapshotOk');
    var usersData = usersSnapshot.data()!;
    var userAddresData = userAddresSnapshot.docs;
    print('convertDataOk');
    _userModel = UserModel.fromMap(userId, usersData, userAddresData);
    print('_userModelOk');
    print('UserId(${_userModel!.userId})');
    print('Fetch User\'s Data Successful!');
    notifyListeners();
    return 'done';
  }

  Future<UserModel> getUserFromId(String uid) async {
    var usersRef = db.collection('users').doc('${uid}');
    var userAddressRef =
        db.collection('userAddress').where('userId', isEqualTo: uid);

    var usersSnapshot = await usersRef.get();
    var userAddresSnapshot = await userAddressRef.get();

    var usersData = usersSnapshot.data()!;
    var userAddresData = userAddresSnapshot.docs;

    var user = UserModel.fromMap(uid, usersData, userAddresData);

    return user;
  }

  Future<String> deleteAddress(String addressId) async {
    var userAddressRef = db.collection('userAddress').doc(addressId);
    await userAddressRef.delete();
    _userModel!.addresses
        .removeWhere((address) => address['addressId'] == addressId);
    print('Delete Address(${addressId}) Of User(${_userModel!.userId})');
    notifyListeners();
    return 'done';
  }
}
