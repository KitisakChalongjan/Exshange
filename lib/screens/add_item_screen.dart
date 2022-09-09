import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final ImagePicker imagePicker = ImagePicker();
  final storageRef = FirebaseStorage.instance.ref();

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
                : Flexible(
                    child: Container(
                      width: double.infinity,
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: imageSelected.length,
                        itemBuilder: (context, index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
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
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    List<XFile>? image = await imagePicker.pickMultiImage();
                    if (image == null) {
                      return;
                    } else {
                      setState(() {
                        imageSelected = image;
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
            ElevatedButton(
              onPressed: () {
                var imagesRef = storageRef.child('images/');
                try {
                  imageSelected.forEach((image) async {
                    var file = File(image.path);
                    String filename = basename(file.path);
                      var imageFileRef = imagesRef.child(filename);
                    await imageFileRef.putFile(file);
                  });
                } on FirebaseException catch (e) {
                  print('Error : ${e}');
                }
              },
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
