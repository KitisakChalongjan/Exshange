import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/models/item.dart';
import 'package:exshange/models/offer.dart';
import 'package:exshange/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Offers with ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  User? user;

  List<Offer> _offers = [];

  List<Offer> get offers {
    return _offers;
  }

  Future<String> fetchMyOffersData() async {
    print('startFetchMyOffersData');
    user = FirebaseAuth.instance.currentUser;
    List<Offer> tempOffers = [];
    var loadedOffers = await db.collection("offers").get();
    for (var offerSnapshot in loadedOffers.docs) {
      print('a');
      var offerData = offerSnapshot.data();
      print('1');
      String firstUserId = offerData['firstUserId'];
      var firstUser = await db.collection('users').doc(firstUserId).get();
      var firstUserAddressesSnapshot = await db.collection('userAddress').get();
      var firstUserAddress = firstUserAddressesSnapshot.docs
          .where((address) => address.data()['userId'] == firstUserId)
          .toList();
      print('2');
      String secondUserId = offerData['secondUserId'];
      var secondUser = await db.collection('users').doc(secondUserId).get();
      var secondUserAddressesSnapshot =
          await db.collection('userAddress').get();
      var secondUserAddress = secondUserAddressesSnapshot.docs
          .where((address) => address.data()['userId'] == secondUserId)
          .toList();
      print('3');
      String firstItemId = offerData['firstOfferItemId'];
      var firstItem = await db.collection('items').doc(firstItemId).get();
      String secondItemId = offerData['secondOfferItemId'];
      var secondItem = await db.collection('items').doc(secondItemId).get();
      String status = offerData['status'];
      bool firstUserAccepted = offerData['firstUserAccepted'];
      bool secondUserAccepted = offerData['secondUserAccepted'];
      bool isFirstUserRating = offerData['isFirstUserRating'];
      bool isSecondUserRating = offerData['isSecondUserRating'];
      int createdTimestamp = offerData['createdTimestamp'];
      print('4');
      var offer = Offer(
        id: offerSnapshot.id,
        firstUser: UserModel.fromMap(
            firstUser.id, firstUser.data()!, firstUserAddress),
        secondUser: UserModel.fromMap(
            secondUser.id, secondUser.data()!, secondUserAddress),
        firstOfferItem: Item.fromDocumentSnapshot(firstItem),
        secondOfferItem: Item.fromDocumentSnapshot(secondItem),
        status: status,
        firstUserAccepted: firstUserAccepted,
        secondUserAccepted: secondUserAccepted,
        isFirstUserRating: isFirstUserRating,
        isSecondUserRating: isSecondUserRating,
        createdTimestamp: createdTimestamp,
      );
      print('createOffer');
      tempOffers.add(offer);
      print('add');
    }
    print('Fetch Offers Data Successful!');
    _offers = tempOffers;
    return 'done';
  }

  void notify() {
    notifyListeners();
  }

  Future<String> addOfferToFireBase(
    String firstUserId,
    String secondUserId,
    String firstOfferItemId,
    String secondOfferItemId,
    String status,
    bool firstUserAccepted,
    bool secondUserAccepted,
    bool isFirstUserRating,
    bool isSecondUserRating,
  ) async {
    final offer = Offer.toMap(
      firstUserId,
      secondUserId,
      firstOfferItemId,
      secondOfferItemId,
      status,
      firstUserAccepted,
      secondUserAccepted,
      isFirstUserRating,
      isSecondUserRating,
      DateTime.now().millisecondsSinceEpoch,
    );

    DocumentReference doc = await db.collection('offers').add(offer);
    print('Document Offer Created! ID : ${doc.id}');
    return doc.id;
  }
}
