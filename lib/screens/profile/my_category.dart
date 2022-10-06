import 'package:exshange/helpers/categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MyCategoriesScreen extends StatefulWidget {
  const MyCategoriesScreen({Key? key}) : super(key: key);
  final routeName = '/mycategory';

  @override
  State<MyCategoriesScreen> createState() => _MyCategoriesScreenState();
}

class _MyCategoriesScreenState extends State<MyCategoriesScreen> {
  List<String> categories = Categories().allCategory.keys.toList().sublist(1);
  List<String> selectedCategory = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      bottomNavigationBar: BottomAppBar(
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
    );
  }
}
