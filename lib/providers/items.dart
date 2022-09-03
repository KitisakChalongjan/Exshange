import 'package:exshange/models/item.dart';
import 'package:flutter/material.dart';

class Items with ChangeNotifier {
  List<Item> _items = [
    Item(
      'Shirt',
      'Good Shirt',
      'bangkok',
      'cloth',
      'man cloth',
    ),
    Item(
      'Shirt',
      'Good Shirt',
      'bangkok',
      'cloth',
      'man cloth',
    ),
    Item(
      'Shirt',
      'Good Shirt',
      'bangkok',
      'cloth',
      'man cloth',
    ),
    Item(
      'Shirt',
      'Good Shirt',
      'bangkok',
      'cloth',
      'man cloth',
    ),
    Item(
      'Shirt',
      'Good Shirt',
      'bangkok',
      'cloth',
      'man cloth',
    ),
    Item(
      'Shirt',
      'Good Shirt',
      'bangkok',
      'cloth',
      'man cloth',
    ),
  ];

  List<Item> get items{
    return _items;
  }
}
