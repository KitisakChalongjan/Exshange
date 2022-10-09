import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String id;
  String ownerid;
  String name;
  String detail;
  String address;
  String province;
  String category;
  String subCategory;
  List<dynamic> imagesUrl;
  String itemType;
  double latitude;
  double longitude;
  String status;
  int timestamp;

  Item({
    required this.id,
    required this.ownerid,
    required this.name,
    required this.detail,
    required this.address,
    required this.province,
    required this.category,
    required this.subCategory,
    required this.imagesUrl,
    required this.itemType,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.timestamp,
  });

  factory Item.fromQueryDocumentSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> item) {
    var itemMap = item.data();
    return Item(
      id: item.id,
      ownerid: itemMap['ownerId'],
      name: itemMap['name'],
      detail: itemMap['detail'],
      address: itemMap['address'],
      province: itemMap['province'],
      category: itemMap['category'],
      subCategory: itemMap['subCategory'],
      imagesUrl: itemMap['imagesUrl'],
      itemType: itemMap['itemType'],
      latitude: itemMap['latitude'],
      longitude: itemMap['longitude'],
      status: itemMap['status'],
      timestamp: itemMap['timestamp'],
    );
  }

    factory Item.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>>? item) {
    var itemMap = item!.data()!;
    return Item(
      id: item.id,
      ownerid: itemMap['ownerId'],
      name: itemMap['name'],
      detail: itemMap['detail'],
      address: itemMap['address'],
      province: itemMap['province'],
      category: itemMap['category'],
      subCategory: itemMap['subCategory'],
      imagesUrl: itemMap['imagesUrl'],
      itemType: itemMap['itemType'],
      latitude: itemMap['latitude'],
      longitude: itemMap['longitude'],
      status: itemMap['status'],
      timestamp: itemMap['timestamp'],
    );
  }

  static Map<String, dynamic> toMap(
    String ownerId,
    String name,
    String detail,
    String address,
    String province,
    String category,
    String subCategory,
    List<String> imagesUrl,
    String itemType,
    double latitude,
    double longitude,
    String status,
    int timestamp,
  ) {
    return {
      'ownerId': ownerId,
      "name": name,
      "detail": detail,
      "address": address,
      "province": province,
      "category": category,
      "subCategory": subCategory,
      "imagesUrl": imagesUrl,
      "itemType": itemType,
      "latitude": latitude,
      "longitude": longitude,
      "status": status,
      "timestamp": timestamp,
    };
  }
}
