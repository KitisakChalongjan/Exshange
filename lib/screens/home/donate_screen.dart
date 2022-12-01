import 'package:exshange/helpers/geolocator.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:exshange/providers/items.dart';
import 'package:exshange/providers/offers.dart';
import 'package:exshange/providers/user_data.dart';
import 'package:exshange/screens/home/add_address_screen.dart';
import 'package:exshange/screens/home/item_overview_screen.dart';
import 'package:exshange/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({Key? key}) : super(key: key);
  final routeName = '/donate';

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  String address = '';
  String province = '';
  String category = '';
  String subCategory = '';
  double? latitude;
  double? longitude;

  List<String> imagesSelectedUrl = [];

  TextEditingController _donateDescController = TextEditingController();

  String _selectedAddress = 'เลือกที่อยู่';
  List<String> allAddress = [];

  User? user;
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    user = context.read<Authentication>().currentUser;
    final args = ModalRoute.of(context)!.settings.arguments as ItemArgs;
    var itemsData = context.read<Items>();
    final item =
        itemsData.items.firstWhere((element) => element.id == args.itemId);
    var userModel = context.watch<UserData>().userModel;
    final offers = context.read<Offers>();
    List<Map<String, dynamic>> addresses = userModel!.addresses;
    allAddress = ['เลือกที่อยู่', 'เพิ่มที่อยู่ใหม่'];
    for (var addressSnapshot in addresses) {
      allAddress.insert(1, addressSnapshot['address']);
    }
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('บริจาค'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 57, 57, 57),
                          borderRadius: BorderRadius.circular(20)),
                      height: 280,
                      width: 280,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Hero(
                          tag: 'heroItem${args.index}',
                          child: Image.network(
                            item.imagesUrl[0],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Icon(
                        Icons.loop_sharp,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                    Container(
                      height: 280,
                      width: 280,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.25),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(1, 3),
                            ),
                          ]),
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: "คำอธิบายเพิ่มเติม..."),
                        minLines: 1,
                        maxLines: 2,
                        controller: _donateDescController,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                    SizedBox(
                      height: 20,
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
                          value: _selectedAddress,
                          items: allAddress
                              .map(
                                (address) => DropdownMenuItem<String>(
                                  value: address,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        address.length > 30
                                            ? '${address.substring(0, 30)}...'
                                            : address,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2,
                                      ),
                                      address == 'เพิ่มที่อยู่ใหม่'
                                          ? Icon(Icons.add_home_rounded)
                                          : const SizedBox(
                                              width: 0,
                                              height: 0,
                                            ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (address) {
                            if (address == 'เพิ่มที่อยู่ใหม่') {
                              Navigator.of(context)
                                  .pushNamed(AddAdressScreen().routeName);
                            } else {
                              setState(() {
                                _selectedAddress = address!;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.red),
                  height: 60,
                  child: Text(
                    'ยกเลิก',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                onTap: (() {
                  Navigator.of(context).pop();
                }),
              ),
            ),
            Expanded(
              child: GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  decoration:
                      BoxDecoration(color: Theme.of(context).focusColor),
                  height: 60,
                  child: Text(
                    'ยืนยัน',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                onTap: (() async {
                  setState(() {
                    isLoading = true;
                  });

                  province = addresses.firstWhere((element) =>
                      element['address'] == _selectedAddress)['province'];

                  Position geo = await GeolocatorHelper().determinePosition();
                  latitude = geo.latitude;
                  longitude = geo.longitude;

                  imagesSelectedUrl = [
                    'https://firebasestorage.googleapis.com/v0/b/exshange-project.appspot.com/o/images%2F72-724263_donate-icon-investment-thenounproject-hd-png-download.png?alt=media&token=cfeb6f6a-69c4-4089-8eef-797ad439bc1e'
                  ];

                  var docId = await itemsData.addItemToFireStore(
                    user!.uid,
                    'ขอรับบริจาค',
                    _donateDescController.text,
                    _selectedAddress,
                    province,
                    'หมวดหมู่ทั้งหมด',
                    '_selectedSubCategory',
                    imagesSelectedUrl,
                    item.itemType,
                    latitude!,
                    longitude!,
                    'off',
                    'false',
                  );
                  var firstOfferItemId = item.id;
                  var firstUserId = item.ownerid;
                  var secondOfferItemId = docId;
                  var secondUserId = user!.uid;

                  await offers.addOfferToFireBase(
                    firstUserId,
                    secondUserId,
                    firstOfferItemId,
                    secondOfferItemId,
                    'offer',
                    false,
                    false,
                    false,
                    false,
                  );

                  setState(() {
                    isLoading = false;
                  });
                  Navigator.of(context).pop();
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
