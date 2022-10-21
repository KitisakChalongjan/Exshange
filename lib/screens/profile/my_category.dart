import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/helpers/categories.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:exshange/providers/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class MyCategoriesScreen extends StatefulWidget {
  const MyCategoriesScreen({Key? key}) : super(key: key);
  final routeName = '/mycategory';

  @override
  State<MyCategoriesScreen> createState() => _MyCategoriesScreenState();
}

class _MyCategoriesScreenState extends State<MyCategoriesScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<String> categories = Categories().allCategory.keys.toList().sublist(1);
  List<dynamic> selectedCategory = [];

  
  @override
  Widget build(BuildContext context) {
    var user = context.read<Authentication>().currentUser!;
    var userData = context.read<UserData>();
    selectedCategory = userData.userModel!.favoriteCategories;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text('หมวดหมู่ที่สนใจ'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 70, vertical: 30),
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: ((context, index) {
              return ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                      selectedCategory.contains(categories[index])
                          ? Theme.of(context).primaryColor
                          : Colors.white),
                ),
                onPressed: (() {
                  setState(() {
                    if (selectedCategory.contains(categories[index])) {
                      selectedCategory.remove(categories[index]);
                      print('remove');
                    } else {
                      selectedCategory.add(categories[index]);
                      print('add');
                    }
                  });
                }),
                child: Container(
                  width: double.infinity,
                  height: 30,
                  child: Text(
                    categories[index],
                    style: selectedCategory.contains(categories[index])
                        ? Theme.of(context).textTheme.bodyText2
                        : Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () async {
          await db
              .collection('users')
              .doc(user.uid)
              .update({'favoriteCategories': selectedCategory});
          print(selectedCategory);
          await userData.fetchUserData(user.uid);
          Navigator.pop(context);
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
