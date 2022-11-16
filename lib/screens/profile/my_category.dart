import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/providers/categories.dart';
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

  List<String> allCategory = [];
  List<dynamic> selectedCategory = [];
  @override
  void initState() {
    var favList =
        context.read<UserData>().userModel!.favoriteCategories as List<dynamic>;
    favList.forEach((fav) {
      selectedCategory.add(fav);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    allCategory = context
        .read<Categories>()
        .categories
        .keys.skip(1)
        .map((categoryKey) => categoryKey)
        .toList();
    var user = context.read<Authentication>().currentUser!;
    var userData = context.read<UserData>();
    print(selectedCategory);
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
            itemCount: allCategory.length,
            itemBuilder: ((context, index) {
              return ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                      selectedCategory.contains(allCategory[index])
                          ? Theme.of(context).primaryColor
                          : Colors.white),
                ),
                onPressed: (() {
                  setState(() {
                    if (selectedCategory.contains(allCategory[index])) {
                      selectedCategory.remove(allCategory[index]);
                      print('remove');
                    } else {
                      selectedCategory.add(allCategory[index]);
                      print('add');
                    }
                  });
                }),
                child: Container(
                  width: double.infinity,
                  height: 30,
                  child: Text(
                    allCategory[index],
                    style: selectedCategory.contains(allCategory[index])
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
