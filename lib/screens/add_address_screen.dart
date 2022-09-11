import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/helpers/address_helper.dart';
import 'package:exshange/helpers/firestore_helper.dart';
import 'package:exshange/helpers/province_helper.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddAdressScreen extends StatefulWidget {
  const AddAdressScreen({Key? key}) : super(key: key);
  final routeName = '/addaddress';

  @override
  State<AddAdressScreen> createState() => _AddAdressScreenState();
}

class _AddAdressScreenState extends State<AddAdressScreen> {
  User? currentUser = Authentication().currentUser;

  List<String> provinces = ProvinceHelper().provinces;

  String selectedProvince = 'กรุงเทพฯ';

  FirebaseFirestore db = FirestoreHelper().db;

  TextEditingController _itemAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AddressHelper addressHelper = Provider.of<AddressHelper>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มที่อยู่ใหม่'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: 10,
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.25),
                    spreadRadius: 3,
                    blurRadius: 3,
                    offset: Offset(1, 3),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              width: 360,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "ที่อยู่"),
                minLines: 4,
                maxLines: 8,
                controller: _itemAddressController,
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.25),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(1, 3),
                  ),
                ],
              ),
              width: 360,
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: Colors.white,
                  value: selectedProvince,
                  items: provinces
                      .map(
                        (province) => DropdownMenuItem<String>(
                          child: Text(
                            province,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          value: province,
                        ),
                      )
                      .toList(),
                  onChanged: (province) {
                    setState(() {
                      selectedProvince = province!;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () async {
          var newAddress = {
            'address': _itemAddressController.text,
            'province': selectedProvince,
          };
           db.collection('users').doc('${currentUser!.uid}').collection('addresses').add(newAddress);
           print('New Address Added! => ${newAddress}');
           Navigator.of(context).pop();
           addressHelper.fetchAddress();
          // WTF!!
          // var newAddresses = {'addresses': []};
          // await db.collection('users').doc('${currentUser!.uid}').get().then(
          //   (value) {
          //     var userData = value.data();
          //     var addressesData = userData!['addresses'];
          //     var converted = List<Map<dynamic, dynamic>>.from(addressesData);
          //     converted.forEach((addressItem) {
          //       newAddresses['addresses']?.add({
          //         'address': addressItem['address'],
          //         'province': addressItem['province'],
          //       });
          //     });
          //     newAddresses['addresses']?.add({
          //       'address': _itemAddressController.text,
          //       'province': selectedProvince,
          //     });
          //     print(newAddresses);
          //   },
          // );
          // await db
          //     .collection('users')
          //     .doc('${currentUser!.uid}')
          //     .set(newAddresses);
        },
        child: BottomAppBar(
          color: Theme.of(context).primaryColor,
          child: Container(
            height: 40,
            child: Text(
              "ตกลง",
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
