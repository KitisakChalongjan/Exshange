import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/helpers/geolocator.dart';
import 'package:exshange/helpers/provinces.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:exshange/helpers/categories.dart';
import 'package:exshange/providers/items.dart';
import 'package:exshange/providers/user_data.dart';
import 'package:exshange/screens/add_address_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);
  final routeName = '/additem';
  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  User? currentUser = Authentication().currentUser;

  TextEditingController _itemNameController = TextEditingController();
  TextEditingController _itemDetailController = TextEditingController();

  List<XFile> imageSelected = [];
  List<String> imagesSelectedUrl = [];
  final ImagePicker imagePicker = ImagePicker();

  FirebaseFirestore db = FirebaseFirestore.instance;

  final storageRef = FirebaseStorage.instance.ref();

  final user = Authentication().currentUser;

  final allCategory = Categories().allCategory;

  String? selectedCategory = 'หมวดหมู่ทั้งหมด';
  List<String> category2 = ['หมวดหมู่รองทั้งหมด'];
  String? selectedCategory2 = 'หมวดหมู่รองทั้งหมด';

  List<String> allType = Items().itemType;
  String? selectedType = 'ทั้งหมด';

  String? _selectedAddress = 'เลือกที่อยู่';
  List<String> allAddress = [];

  Widget headText(String text, BuildContext ctx) {
    return Text(
      text,
      style: Theme.of(ctx).textTheme.bodyText1,
    );
  }

  @override
  Widget build(BuildContext context) {
    var itemsData = Provider.of<Items>(context, listen: false);
    var userModel = Provider.of<UserData>(context).userModel;
    var userAddresses = userModel!.addresses as List<Map<String, dynamic>>;
    allAddress = ['เลือกที่อยู่', 'เพิ่มที่อยู่ใหม่'];
    userAddresses.forEach((addressSnapshot) {
      allAddress.insert(1, addressSnapshot['address']);
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มสิ่งของ'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              headText('เพิ่มรูปภาพ', context),
              imageSelected.isEmpty
                  ? Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 140,
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                        color: Colors.grey[350],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'กรุณเลือกรูปภาพ',
                        style: TextStyle(color: Colors.grey[800]),
                      ))
                  : Container(
                      width: double.infinity,
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: imageSelected.length,
                        itemBuilder: (context, index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 6),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Image.file(
                                File(imageSelected[index].path),
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
                                    imageSelected.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      List<XFile>? images = await imagePicker.pickMultiImage();
                      if (images == null) {
                        return;
                      } else {
                        for (var image in images) {
                          imageSelected.add(image);
                        }
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
                        setState(() {
                          imageSelected.add(image);
                        });
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
              // ElevatedButton(
              //   onPressed: () {
              //     try {
              //       var imagesRef = storageRef.child('images/');
              //       imagesSelectedUrl.clear;
              //       imageSelected.forEach((image) async {
              //         var file = File(image.path);
              //         String filename = basename(file.path);
              //         var imageFileRef = imagesRef.child(filename);
              //         await imageFileRef.putFile(file);
              //         var imgUrl = await imageFileRef.getDownloadURL();
              //         setState(() {
              //           imagesSelectedUrl.add(imgUrl);
              //         });
              //         print(imgUrl);
              //       });
              //     } on FirebaseException catch (e) {
              //       print('Error : ${e}');
              //     }
              //   },
              //   child: Text('Send'),
              // ),
              SizedBox(
                height: 20,
              ),
              headText('รายละเอียดสิ่งของ', context),
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
                    value: selectedCategory,
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
                        selectedCategory = category;
                        allCategory.forEach((key, subCategory) {
                          if (key == category) {
                            category2.clear();
                            if (key != 'หมวดหมู่ทั้งหมด') {
                              category2 = ['หมวดหมู่รองทั้งหมด'];
                            }
                            category2.addAll(subCategory);
                            selectedCategory2 = 'หมวดหมู่รองทั้งหมด';
                          }
                        });
                        print('${selectedCategory} => ${selectedCategory2}');
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
                    value: selectedCategory2,
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
                        selectedCategory2 = subCategory;
                        print('${selectedCategory} => ${selectedCategory2}');
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
                    value: selectedType,
                    items: allType
                        .map(
                          (type) => DropdownMenuItem<String>(
                            child: Text(
                              type,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            value: type,
                          ),
                        )
                        .toList(),
                    onChanged: (type) {
                      setState(() {
                        selectedType = type;
                        print('${selectedType}');
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
                                  address,
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
                          _selectedAddress = address;
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () async {
          String name = _itemNameController.text;
          String detail = _itemDetailController.text;
          String address = _selectedAddress!;
          String province = userAddresses.firstWhere(
              (element) => element['address'] == _selectedAddress)['province'];
          String category = selectedCategory!;
          String subCategory = selectedCategory!;
          List<String> imagesUrl = imagesSelectedUrl;
          String itemType = selectedType!;
          double? latitude;
          double? longitude;

          Position geo = await GeolocatorHelper().determinePosition();
          latitude = geo.latitude;
          longitude = geo.longitude;

          // ignore: avoid_function_literals_in_foreach_calls
          imageSelected.forEach(
            (image) async {
              Reference imagesRef = storageRef.child('images/');
              imagesSelectedUrl.clear;
              File file = File(image.path);
              String filename = basename(file.path);
              Reference imageFileRef = imagesRef.child(filename);
              await imageFileRef.putFile(file);
              String imgUrl = await imageFileRef.getDownloadURL();
              imagesSelectedUrl.add(imgUrl);
              if (imagesSelectedUrl.length == imageSelected.length) {
                final item = <String, dynamic>{
                  'ownerId': currentUser!.uid,
                  "name": name,
                  "detail": detail,
                  "address": address,
                  "province": province,
                  "category": category,
                  "subCategory": subCategory,
                  "imagesUrl": imagesUrl,
                  "itemType": itemType,
                  "latitude": latitude,
                  "longitude": longitude,
                };
                DocumentReference doc = await db.collection('items').add(item);
                print('Document Created! ID : ${doc.id}');
              }
            },
          );
          await itemsData.initItemsData();
          Navigator.of(context).pop();
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
