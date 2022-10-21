import 'package:flutter/material.dart';

class Filter with ChangeNotifier {
  String filterCategory = 'หมวดหมู่ทั้งหมด';
  String filterSubCategory = 'หมวดหมู่รองทั้งหมด';
  double filterDistance = 1;
  String itemType = 'ทั้งหมด';
  bool isFilter = false;


  void noti(){
    notifyListeners();
  }
}
