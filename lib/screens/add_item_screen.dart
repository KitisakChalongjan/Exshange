import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/providers/categories.dart';
import 'package:exshange/providers/items.dart';
import 'package:exshange/screens/add_address_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);
  final routeName = '/additem';
  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  List<XFile> imageSelected = [];
  List<String> imagesSelectedUrl = [];
  final ImagePicker imagePicker = ImagePicker();

  final storageRef = FirebaseStorage.instance.ref();

  final allCategory = Categories().allCategory;

  String? selectedCategory = 'หมวดหมู่ทั้งหมด';
  List<String> category2 = ['หมวดหมู่รองทั้งหมด'];
  String? selectedCategory2 = 'หมวดหมู่รองทั้งหมด';

  List<String> allType = Items().itemType;
  String? selectedType = 'ทั้งหมด';

  List<String> allAddress = ['address1', 'address2', 'เพิ่มที่อยู่ใหม่'];
  String? selectedAddress = 'address1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มสิ่งของ'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'เพิ่มรูปภาพ',
              style: Theme.of(context).textTheme.bodyText1,
            ),
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Image.file(
                                File(imageSelected[index].path),
                                fit: BoxFit.cover,
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
                      images.forEach((image) {
                        setState(() {
                          imageSelected.add(image);
                        });
                      });
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
                    XFile? image =
                        await imagePicker.pickImage(source: ImageSource.camera);
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
            Text(
              'รายละเอียดสิ่งของ',
              style: Theme.of(context).textTheme.bodyText1,
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
                  value: selectedAddress,
                  items: allAddress
                      .map(
                        (address) => DropdownMenuItem<String>(
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
                                  : SizedBox(
                                      width: 0,
                                      height: 0,
                                    ),
                            ],
                          ),
                          value: address,
                        ),
                      )
                      .toList(),
                  onChanged: (address) {
                    if (address != 'เพิ่มที่อยู่ใหม่') {
                      setState(() {
                        selectedAddress = address;
                        print('${selectedAddress}');
                      });
                    }
                    else{
                      Navigator.of(context).pushNamed(AddAdressScreen().routeName);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
