import 'package:exshange/screens/home/add_address_screen.dart';
import 'package:exshange/screens/profile/edit_address_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MyAddressScreen extends StatefulWidget {
  const MyAddressScreen({Key? key}) : super(key: key);
  final routeName = '/myaddress';

  @override
  State<MyAddressScreen> createState() => _MyAddressScreenState();
}

class _MyAddressScreenState extends State<MyAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ที่อยู่ของฉัน'),
      ),
      body: ListView.builder(
        itemBuilder: ((context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(EditAddressScreen().routeName);
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 140,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      index.toString(),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      "bangkok 1995",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        itemCount: 2,
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
