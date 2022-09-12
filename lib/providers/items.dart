import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/models/item.dart';
import 'package:flutter/material.dart';

class Items with ChangeNotifier {
  List<String> itemType = ['ทั้งหมด', 'บริจาค', 'แลกเปลื่ยน'];

  FirebaseFirestore db = FirebaseFirestore.instance;

  List<Item> _items = [];

  List<Item> get items {
    return _items;
  }

  Future<void> initItemsData() async {
    List<Item> loadedData = [];
    await db.collection("items").get().then((items) {
      for (var doc in items.docs) {
        loadedData.add(Item(
          doc.id,
          doc['ownerId'],
          doc['name'],
          doc['detail'],
          doc['address'],
          doc['province'],
          doc['category'],
          doc['subCategory'],
          doc['imagesUrl'],
          doc['itemType'],
          doc['latitude'],
          doc['longitude'],
        ));
      _items = loadedData;
      notifyListeners();
      }
    });
  }
}
