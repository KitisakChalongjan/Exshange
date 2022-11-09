import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/models/item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class Items with ChangeNotifier {
  List<String> itemType = ['ทั้งหมด', 'บริจาค', 'แลกเปลี่ยน'];

  FirebaseFirestore db = FirebaseFirestore.instance;

  Reference storageRef = FirebaseStorage.instance.ref();

  List<Item> _items = [];

  List<Item> get items {
    return _items;
  }

  Future<String> initItemsData() async {
    List<Item> tempItems = [];
    var loadedItems = await db.collection("items").get();
    for (var item in loadedItems.docs) {
      tempItems.add(
        Item.fromQueryDocumentSnapshot(item),
      );
    }
    _items = tempItems;
    print('Initialize Items Data Successful!');
    notifyListeners();
    return 'done';
  }

  Future<List<String>> addImageToStorage(List<XFile> imagesSelectedUrl) async {
    List<String> imagesUrl = [];
    for (var image in imagesSelectedUrl) {
      Reference imagesRef = storageRef.child('images/');
      imagesSelectedUrl.clear;
      File file = File(image.path);
      String filename = basename(file.path);
      Reference imageFileRef = imagesRef.child(filename);
      await imageFileRef.putFile(file);
      String imgUrl = await imageFileRef.getDownloadURL();
      imagesUrl.add(imgUrl);
    }
    return imagesUrl;
  }

  Future<String> addItemToFireStore(
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
  ) async {
    final item = Item.toMap(
      ownerId,
      name,
      detail,
      address,
      province,
      category,
      subCategory,
      imagesUrl,
      itemType,
      latitude,
      longitude,
      status,
      DateTime.now().millisecondsSinceEpoch,
    );

    DocumentReference doc = await db.collection('items').add(item);
    print('Document Item Created! ID : ${doc.id}');
    return doc.id;
  }

  Future<Item> getItemById(String itemId) async {
    var itemDoc = await db.collection('items').doc('${itemId}').get();
    Item item = Item.fromDocumentSnapshot(itemDoc);
    return item;
  }
}
