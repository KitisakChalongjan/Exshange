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

  final ImagePicker imagePicker = ImagePicker();
  ImageProvider? img;
  File? imgFile;

  @override
  void initState() {
    if (context.read<UserData>().userModel!.profileImgUrl == '') {
      img = AssetImage('assets/images/person-icon.png');
    } else {
      img = NetworkImage(context.read<UserData>().userModel!.profileImgUrl);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = context.read<Authentication>().currentUser;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('แก้ไขข้อมูลโปรไฟล์'),
      ),
      body: Column(
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
                  margin: EdgeInsets.only(bottom: 10),
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
                      backgroundColor: Theme.of(context).accentColor,
                      radius: 30,
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
          Container(),
        ],
      ),
      bottomNavigationBar: GestureDetector(
        onTap: (() async {
          var imgUrl;
          if (imgFile != null) {
            Reference imagesRef = storageRef.child('images/');
            String filename = bs.basename(imgFile!.path);
            Reference imageFileRef = imagesRef.child(filename);
            await imageFileRef.putFile(imgFile!);
            imgUrl = await imageFileRef.getDownloadURL();
          }
          await db
              .collection('users')
              .doc(currentUser!.uid)
              .update({'profileImgUrl': imgUrl});
          context.read<UserData>().fetchUserData();
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
