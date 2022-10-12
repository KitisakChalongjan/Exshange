import 'package:exshange/providers/user_data.dart';
import 'package:exshange/screens/home/add_address_screen.dart';
import 'package:exshange/screens/profile/edit_address_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class AddressArgs {
  String address;
  String province;
  String userId;
  String addressId;

  AddressArgs({
    required this.address,
    required this.province,
    required this.userId,
    required this.addressId,
  });
}

class MyAddressScreen extends StatefulWidget {
  const MyAddressScreen({Key? key}) : super(key: key);
  final routeName = '/myaddress';

  @override
  State<MyAddressScreen> createState() => _MyAddressScreenState();
}

class _MyAddressScreenState extends State<MyAddressScreen> {
  @override
  Widget build(BuildContext context) {
    var addresses = context.watch<UserData>().userModel!.addresses;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('ที่อยู่ของฉัน'),
      ),
      body: ListView.builder(
        itemBuilder: ((context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                EditAddressScreen().routeName,
                arguments: AddressArgs(
                  address: addresses[index]['address'],
                  province: addresses[index]['province'],
                  userId: addresses[index]['userId'],
                  addressId: addresses[index]['addressId'],
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 140,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        index.toString(),
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      Text(
                        addresses[index]['address'],
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      Text(
                        addresses[index]['addressId'],
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        itemCount: addresses.length,
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(AddAdressScreen().routeName);
        },
        child: BottomAppBar(
          color: Theme.of(context).primaryColor,
          child: Container(
            height: 40,
            child: Text(
              "เพิ่มที่อยู่",
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
