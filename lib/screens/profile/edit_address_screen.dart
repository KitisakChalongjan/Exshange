import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/helpers/provinces.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:exshange/providers/user_data.dart';
import 'package:exshange/screens/profile/my_address_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class EditAddressScreen extends StatefulWidget {
  const EditAddressScreen({Key? key}) : super(key: key);
  final routeName = '/editaddress';

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  FirebaseFirestore db = FirebaseFirestore.instance;

  List<String> provinces = Provinces().provinces;

  String _selectedProvince = 'กรุงเทพฯ';

  var flag = true;

  TextEditingController _itemAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as AddressArgs;
    if (flag) {
      _selectedProvince = args.province;
      flag = false;
    }
    User? user = context.read<Authentication>().currentUser;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('แก้ไขที่อยู่'),
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
                    hintText: args.address),
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
                  value: _selectedProvince,
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
                      _selectedProvince = province!;
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
          var address;
          if(_itemAddressController.text == ''){
            address = args.address;
          }
          else{
            address = _itemAddressController.text;
          }
          var newAddress = {
            'address': address,
            'province': _selectedProvince,
            'userId': user!.uid,
          };
          db.collection('userAddress').doc(args.addressId).set(newAddress);

          print('Edit Address at => ${args.addressId}');
          await context.read<UserData>().fetchUserData(user.uid);
          Navigator.of(context).pop();
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
