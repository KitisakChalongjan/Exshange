import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/models/item.dart';
import 'package:exshange/models/user.dart';

class Offer {
  String id;
  UserModel firstUser;
  UserModel secondUser;
  Item firstOfferItem;
  Item secondOfferItem;

  String userStatus;
  int createdTimestamp;

  Offer({
    required this.id,
    required this.firstUser,
    required this.secondUser,
    required this.firstOfferItem,
    required this.secondOfferItem,
    required this.userStatus,
    required this.createdTimestamp,
  });

  factory Offer.fromMap(QueryDocumentSnapshot<Map<String, dynamic>> offer) {
    var itemMap = offer.data();
    return Offer(
      id: offer.id,
      firstUser: offer['firstOfferItemId'],
      secondUser: offer['firstUserId'],
      firstOfferItem: offer['secondOfferItemId'],
      secondOfferItem: offer['secondUserId'],
      userStatus: offer['userStatus'],
      createdTimestamp: offer['createdTimestamp'],
    );
  }

  static Map<String, dynamic> toMap(
    String firstUserId,
    String secondUserId,
    String firstOfferItemId,
    String secondOfferItemId,
    String userStatus,
    int createdTimestamp,
  ) {
    return {
      'firstUserId': firstUserId,
      "secondUserId": secondUserId,
      "firstOfferItemId": firstOfferItemId,
      "secondOfferItemId": secondOfferItemId,
      "userStatus": userStatus,
      "createdTimestamp": createdTimestamp,
    };
  }

  get getId => this.id;

  get getFirstUser => this.firstUser;

  set setFirstUser(firstUser) => this.firstUser = firstUser;

  get getSecondUser => this.secondUser;

  set setSecondUser(secondUser) => this.secondUser = secondUser;

  get getFirstOfferItem => this.firstOfferItem;

  set setFirstOfferItem(firstOfferItem) => this.firstOfferItem = firstOfferItem;

  get getSecondOfferItem => this.secondOfferItem;

  set setSecondOfferItem(secondOfferItem) =>
      this.secondOfferItem = secondOfferItem;

  get getUserStatus => this.userStatus;

  set setUserStatus(userStatus) => this.userStatus = userStatus;

  get getCreatedTimestamp => this.createdTimestamp;

  set setCreatedTimestamp(createdTimestamp) =>
      this.createdTimestamp = createdTimestamp;
}
