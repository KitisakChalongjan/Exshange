import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserModel {
  String _userId;
  String _email;
  String _name;
  String _phone;
  List<Map<String, dynamic>> _addresses;
  int _tradeCount;
  int _donateCount;
  double _rating;
  List<dynamic> _favoriteCategories;
  List<dynamic> _favoriteItems;
  String _profileImageUrl;

  get userId => this._userId;

  get email => this._email;

  set email(value) => this._email = value;

  get name => this._name;

  set name(value) => this._name = value;

  get phone => this._phone;

  set phone(value) => this._phone = value;

  get addresses => this._addresses;

  set addresses(value) => this._addresses = value;

  get tradeCount => this._tradeCount;

  set tradeCount(value) => this._tradeCount = value;

  get donateCount => this._donateCount;

  set donateCount(value) => this._donateCount = value;

  get rating => this._rating;

  set rating(value) => this._rating = value;

  get favoriteCategories => this._favoriteCategories;

  set favoriteCategories(value) => this._favoriteCategories = value;

  get favoriteItems => this._favoriteItems;

  set favoriteItems(value) => this._favoriteItems = value;

  get profileImageUrl => this._profileImageUrl;

  set profileImageUrl(value) => this._profileImageUrl = value;

  UserModel(
    this._userId,
    this._email,
    this._name,
    this._phone,
    this._addresses,
    this._tradeCount,
    this._donateCount,
    this._rating,
    this._favoriteCategories,
    this._favoriteItems,
    this._profileImageUrl,
  );

  factory UserModel.fromMap(
    String uid,
    Map<String, dynamic> data,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> dataAddress,
  ) {
    List<Map<String, dynamic>> addresses = [];
    for (var element in dataAddress) {
      addresses.add(element.data());
    }
    return UserModel(
        uid,
        data['email'],
        data['name'],
        data['phone'],
        addresses,
        data['tradeCount'],
        data['donateCount'],
        data['rating'],
        data['favoriteCategories'],
        data['favoriteItems'],
        data['profileImageUrl'],
    );
  }
}
