import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Categories with ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Map<String, List<String>> _categories = {};

  Map<String, List<String>> get categories => _categories;

  Future<Map<String, List<String>>> fetchCategories() async {
    try {
      _categories = {
        'หมวดหมู่ทั้งหมด': ['หมวดหมู่รองทั้งหมด']
      };
      var categoriesLoad =
          await db.collection('categories').doc('categories').get();
      var cateData = categoriesLoad.data()!;
      cateData.keys.forEach((categoryKey) {
        var listString = (cateData[categoryKey] as List)
            .map((cate) => cate as String)
            .toList();
        Map<String, List<String>> newCategory = {categoryKey: listString};
        _categories.addAll(newCategory);
      });
    } catch (e) {
      print(e);
    }
    print(_categories);
    return _categories;
  }
}
