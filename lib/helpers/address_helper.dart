import 'package:exshange/helpers/firestore_helper.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:flutter/cupertino.dart';

class AddressHelper with ChangeNotifier {
  List<Map<String, dynamic>> _addresses = [];
  List<String> _allAddress = ['เลือกที่อยู่', 'เพิ่มที่อยู่ใหม่'];

  final db = FirestoreHelper().db;
  final currentUser = Authentication().currentUser;

  List<Map<String, dynamic>> get addresses{
    return _addresses;
  }

  List<String> get allAddress {
    return _allAddress;
  }

  void fetchAddress() async {
    var newAddress = ['เลือกที่อยู่', 'เพิ่มที่อยู่ใหม่'];
    var fetchedAddresses = await db
        .collection('users')
        .doc('${currentUser!.uid}')
        .collection('addresses')
        .get();
    fetchedAddresses.docs.forEach((snapshot) {
      _addresses.add(snapshot.data());
      newAddress.insert(1, snapshot.data()['address']);
    });
    _allAddress = newAddress;
    notifyListeners();
  }
}
