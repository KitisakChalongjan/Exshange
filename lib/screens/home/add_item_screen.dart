import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/helpers/geolocator.dart';
import 'package:exshange/helpers/provinces.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:exshange/helpers/categories.dart';
import 'package:exshange/providers/items.dart';
import 'package:exshange/providers/user_data.dart';
import 'package:exshange/screens/home/add_address_screen.dart';
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
  User? user;

  TextEditingController _itemNameController = TextEditingController();
  TextEditingController _itemDetailController = TextEditingController();

  List<XFile> imageSelected = [];
  List<String> imagesSelectedUrl = [];
  final ImagePicker imagePicker = ImagePicker();

  FirebaseFirestore db = FirebaseFirestore.instance;

  var isAddItemLoading = false;

  final storageRef = FirebaseStorage.instance.ref();

  final allCategory = Categories().allCategory;

  String _selectedCategory = 'หมวดหมู่ทั้งหมด';
  List<String> category2 = ['หมวดหมู่รองทั้งหมด'];
  String _selectedSubCategory = 'หมวดหมู่รองทั้งหมด';

  List<String> allType = Items().itemType;
  String? selectedType = 'ทั้งหมด';

  String _selectedAddress = 'เลือกที่อยู่';
  List<String> allAddress = [];

  String address = '';
  String province = '';
  String category = '';
  String subCategory = '';
  double? latitude;
  double? longitude;

  Widget headText(String text, BuildContext ctx) {
    return Text(
      text,
      style: Theme.of(ctx).textTheme.bodyText1,
    );
  }

  @override
  Widget build(BuildContext context) {
    user = FirebaseAuth.instance.currentUser;
    var itemsData = context.read<Items>();
    var userModel = context.watch<UserData>().userModel;
    List<Map<String, dynamic>> addresses = userModel!.addresses;
    allAddress = ['เลือกที่อยู่', 'เพิ่มที่อยู่ใหม่'];
    for (var addressSnapshot in addresses) {
      allAddress.insert(1, addressSnapshot['address']);
    }
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('เพิ่มสิ่งของ'),
        centerTitle: true,
      ),
      body: isAddItemLoading == false
          ? SingleChildScrollView(
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
                            List<XFile>? images =
                                await imagePicker.pickMultiImage();
                            if (images == null) {
                              return;
                            } else {
                              for (var image in images) {
                                imageSelected.add(image);
                              }
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
                              print(imageSelected);
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
                          value: _selectedCategory,
                          items: allCategory.keys
                              .toList()
                              .map(
                                (item) => DropdownMenuItem<String>(
                                  child: Text(
                                    item,
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
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
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
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
                          value: selectedType,
                          items: allType
                              .map(
                                (type) => DropdownMenuItem<String>(
                                  child: Text(
                                    type,
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
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
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: isAddItemLoading == true
          ? SizedBox(width: 0, height: 0)
          : GestureDetector(
              onTap: () async {
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
                await itemsData.addItemToFireStore(
                  user!.uid,
                  _itemNameController.text,
                  _itemDetailController.text,
                  _selectedAddress,
                  province,
                  _selectedCategory,
                  _selectedSubCategory,
                  imagesSelectedUrl,
                  selectedType!,
                  latitude!,
                  longitude!,
                  'on'
                );

                setState(() {
                  isAddItemLoading = false;
                });

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

  // Future<void> addImageToStorage() async {
  //   for (var image in imageSelected) {
  //     Reference imagesRef = storageRef.child('images/');
  //     imagesSelectedUrl.clear;
  //     File file = File(image.path);
  //     String filename = basename(file.path);
  //     Reference imageFileRef = imagesRef.child(filename);
  //     await imageFileRef.putFile(file);
  //     String imgUrl = await imageFileRef.getDownloadURL();
  //     imagesSelectedUrl.add(imgUrl);
  //     if (imagesSelectedUrl.length == imageSelected.length) {
  //       final item = <String, dynamic>{
  //         'ownerId': currentUser!.uid,
  //         "name": _itemNameController.text,
  //         "detail": _itemDetailController.text,
  //         "address": _selectedAddress,
  //         "province": province,
  //         "category": _selectedCategory,
  //         "subCategory": _selectedCategory2,
  //         "imagesUrl": imagesSelectedUrl,
  //         "itemType": selectedType,
  //         "latitude": latitude,
  //         "longitude": longitude,
  //       };
  //       DocumentReference doc = await db.collection('items').add(item);
  //       print('Document Created! ID : ${doc.id}');
  //     }
  //   }
  // }
}
