import 'dart:io';

import 'package:exshange/helpers/categories.dart';
import 'package:exshange/helpers/geolocator.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:exshange/providers/items.dart';
import 'package:exshange/providers/offers.dart';
import 'package:exshange/providers/user_data.dart';
import 'package:exshange/screens/home/add_address_screen.dart';
import 'package:exshange/screens/home/item_overview_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({Key? key}) : super(key: key);
  final routeName = '/offer';

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  User? user;
  var isAddItemLoading = false;

  TextEditingController _itemNameController = TextEditingController();
  TextEditingController _itemDetailController = TextEditingController();

  List<XFile> imageSelected = [];
  List<String> imagesSelectedUrl = [];
  final ImagePicker imagePicker = ImagePicker();

  final allCategory = Categories().allCategory;

  String _selectedCategory = 'หมวดหมู่ทั้งหมด';
  List<String> category2 = ['หมวดหมู่รองทั้งหมด'];
  String _selectedSubCategory = 'หมวดหมู่รองทั้งหมด';

  String _selectedAddress = 'เลือกที่อยู่';
  List<String> allAddress = [];

  String address = '';
  String province = '';
  String category = '';
  String subCategory = '';
  double? latitude;
  double? longitude;

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
      appBar: AppBar(
        title: Text('เสนอ'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                height: 240,
                width: 240,
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
              imageSelected.isEmpty
                  ? Container(
                      alignment: Alignment.center,
                      height: 280,
                      width: 280,
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                        color: Colors.grey[350],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'กรุณาเลือกรูปภาพ',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    )
                  : Container(
                      height: 280,
                      width: 280,
                      decoration: BoxDecoration(
                        color: Colors.grey[350],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              File(imageSelected[0].path),
                              fit: BoxFit.cover,
                              height: 280,
                              width: 280,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              primary: Colors.red[600],
                            ),
                            child: Icon(
                              size: 20,
                              Icons.close_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                imageSelected.clear();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      XFile? images = await imagePicker.pickImage(
                          source: ImageSource.gallery);
                      if (images == null) {
                        return;
                      } else {
                        imageSelected.clear();
                        imageSelected.add(images);
                        print(imageSelected);
                        setState(() {});
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 120,
                      child: Text('เลือกจากแกลเลอรี่'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      XFile? image = await imagePicker.pickImage(
                          source: ImageSource.camera);
                      if (image == null) {
                        return;
                      } else {
                        imageSelected.clear();
                        imageSelected.add(image);
                        print(imageSelected);
                        setState(() {});
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 120,
                      child: Text('เลือกจากกล้อง'),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                ),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      spreadRadius: 1,
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
                      hintText: "ชื่อสิ่งของ"),
                  minLines: 1,
                  maxLines: 2,
                  controller: _itemNameController,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
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
                      hintText: "รายละเอียดสิ่งของ"),
                  minLines: 3,
                  maxLines: 40,
                  controller: _itemDetailController,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                ),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(1, 3),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 360,
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: Colors.white,
                    value: _selectedCategory,
                    items: allCategory.keys
                        .toList()
                        .map(
                          (item) => DropdownMenuItem<String>(
                            child: Text(
                              item,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            value: item,
                          ),
                        )
                        .toList(),
                    onChanged: (category) {
                      setState(() {
                        _selectedCategory = category!;
                        allCategory.forEach((key, subCategory) {
                          if (key == category) {
                            category2.clear();
                            if (key != 'หมวดหมู่ทั้งหมด') {
                              category2 = ['หมวดหมู่รองทั้งหมด'];
                            }
                            category2.addAll(subCategory);
                            _selectedSubCategory = 'หมวดหมู่รองทั้งหมด';
                          }
                        });
                        print(
                            '${_selectedCategory} => ${_selectedSubCategory}');
                      });
                    },
                  ),
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
                    value: _selectedSubCategory,
                    items: category2
                        .map(
                          (item) => DropdownMenuItem<String>(
                            child: Text(
                              item,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            value: item,
                          ),
                        )
                        .toList(),
                    onChanged: (subCategory) {
                      setState(() {
                        _selectedSubCategory = subCategory!;
                        print(
                            '${_selectedCategory} => ${_selectedSubCategory}');
                      });
                    },
                  ),
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
                    value: _selectedAddress,
                    items: allAddress
                        .map(
                          (address) => DropdownMenuItem<String>(
                            value: address,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  address.length > 30
                                      ? '${address.substring(0, 30)}...'
                                      : address,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.subtitle2,
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
                      BoxDecoration(color: Theme.of(context).accentColor),
                  height: 60,
                  child: Text(
                    'ยืนยัน',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                onTap: (() async {
                  setState(() {
                    isAddItemLoading = true;
                  });

                  province = addresses.firstWhere((element) =>
                      element['address'] == _selectedAddress)['province'];

                  Position geo = await GeolocatorHelper().determinePosition();
                  latitude = geo.latitude;
                  longitude = geo.longitude;

                  imagesSelectedUrl =
                      await itemsData.addImageToStorage(imageSelected);

                  var docId = await itemsData.addItemToFireStore(
                      user!.uid,
                      _itemNameController.text,
                      _itemDetailController.text,
                      _selectedAddress,
                      province,
                      _selectedCategory,
                      _selectedSubCategory,
                      imagesSelectedUrl,
                      item.itemType,
                      latitude!,
                      longitude!,
                      'off');
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
                  );

                  setState(() {
                    isAddItemLoading = false;
                  });
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
