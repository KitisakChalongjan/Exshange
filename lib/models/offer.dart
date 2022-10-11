import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/models/item.dart';
import 'package:exshange/models/user.dart';

class Offer {
  String id;
  UserModel firstUser;
  UserModel secondUser;
  Item firstOfferItem;
  Item secondOfferItem;
  String status;
  int createdTimestamp;

  Offer({
    required this.id,
    required this.firstUser,
    required this.secondUser,
    required this.firstOfferItem,
    required this.secondOfferItem,
    required this.status,
    required this.createdTimestamp,
  });

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

  get getStatus => this.status;

  set setStatus(status) => this.status = status;

  get getCreatedTimestamp => this.createdTimestamp;

  set setCreatedTimestamp(createdTimestamp) =>
      this.createdTimestamp = createdTimestamp;
}
