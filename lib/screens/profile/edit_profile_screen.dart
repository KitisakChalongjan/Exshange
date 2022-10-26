import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/models/user.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:exshange/providers/user_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as bs;
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);
  final routeName = '/editprofile';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final storageRef = FirebaseStorage.instance.ref();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _userPhoneController = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();
  ImageProvider? img;
  File? imgFile;

  var isLoading = false;

  @override
  void initState() {
    if (context.read<UserData>().userModel!.profileImageUrl == '') {
      img = AssetImage('assets/images/person-icon.png');
    } else {
      img = NetworkImage(context.read<UserData>().userModel!.profileImageUrl);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = context.read<Authentication>().currentUser!;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('แก้ไขข้อมูลโปรไฟล์'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    height: 200,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          child: CircleAvatar(
                            radius: 100,
                            backgroundImage: img,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 5,
                          ),
                          child: GestureDetector(
                            onTap: (() async {
                              XFile? images = await imagePicker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (images != null) {
                                setState(() {
                                  img = FileImage(
                                    File(images.path),
                                  );
                                });
                                imgFile = File(images.path);
                              }
                            }),
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              radius: 24,
                              child: Icon(
                                Icons.add_photo_alternate,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 20,
                      left: 20,
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
                        hintText: "ชื่อ",
                      ),
                      minLines: 1,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.subtitle2,
                      controller: _userNameController,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 20,
                      left: 20,
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
                        hintText: "เบอร์โทร",
                      ),
                      minLines: 1,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.subtitle2,
                      controller: _userPhoneController,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
      bottomNavigationBar: GestureDetector(
        onTap: (() async {
          setState(() {
            isLoading = true;
          });
          var imgUrl;
          if (imgFile != null) {
            Reference imagesRef = storageRef.child('images/');
            String filename = bs.basename(imgFile!.path);
            Reference imageFileRef = imagesRef.child(filename);
            await imageFileRef.putFile(imgFile!);
            imgUrl = await imageFileRef.getDownloadURL();
          }
          if (imgFile == null) {
            imgUrl =
                'https://firebasestorage.googleapis.com/v0/b/exshange-project.appspot.com/o/images%2Fperson-icon.png?alt=media&token=e32d807b-eeaa-42cb-89e1-291c0af9e852';
          }
          await db.collection('users').doc(currentUser.uid).update({
            'profileImageUrl': imgUrl,
          });
          if (_userNameController.text.trim() != '') {
            await db.collection('users').doc(currentUser.uid).update({
              'name': _userNameController.text.trim(),
            });
          }
          if (_userPhoneController.text.trim() != '') {
            await db.collection('users').doc(currentUser.uid).update({
              'phone': _userPhoneController.text.trim(),
            });
          }
          await context.read<UserData>().fetchUserData(currentUser.uid);
          isLoading = false;
          Navigator.pop(context);
        }),
        child: BottomAppBar(
          color: Theme.of(context).primaryColor,
          child: Container(
            height: 40,
            child: Text(
              "บันทึกการเปลื่ยนแปลง",
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
