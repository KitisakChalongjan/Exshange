import 'package:exshange/models/item.dart';
import 'package:exshange/helpers/categories.dart';
import 'package:exshange/providers/filter.dart';
import 'package:exshange/providers/items.dart';
import 'package:exshange/screens/home/item_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);
  final routeName = '/filter';

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final allCategory = Categories().allCategory;

  String itemType = 'ทั้งหมด';

  late List<String> category2;

  @override
  Widget build(BuildContext context) {
    var filter = context.watch<Filter>();
    if (filter.filterCategory != 'หมวดหมู่ทั้งหมด') {
      category2 = allCategory['${filter.filterCategory}']!.toList();
      category2.insert(0, 'หมวดหมู่รองทั้งหมด');
    }
    if (filter.filterCategory == 'หมวดหมู่ทั้งหมด') {
      category2 = ['หมวดหมู่รองทั้งหมด'];
    }
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'ตัวกรอง',
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'กรองตามหมวดหมู่',
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
                  value: filter.filterCategory,
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
                      filter.filterCategory = category!;
                      allCategory.forEach((key, subCategory) {
                        if (key == category) {
                          category2.clear();
                          if (key != 'หมวดหมู่ทั้งหมด') {
                            category2 = ['หมวดหมู่รองทั้งหมด'];
                          }
                          category2.addAll(subCategory);
                          filter.filterSubCategory = 'หมวดหมู่รองทั้งหมด';
                        }
                      });
                      print(
                          '${filter.filterCategory} => ${filter.filterSubCategory}');
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
                  value: filter.filterSubCategory,
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
                      filter.filterSubCategory = subCategory!;
                      print(
                          '${filter.filterCategory} => ${filter.filterSubCategory}');
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'กรองตามระยะทาง',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Container(
              child: Slider(
                min: 1.0,
                max: 500.0,
                value: filter.filterDistance,
                onChanged: ((value) {
                  setState(() {
                    filter.filterDistance = value;
                    print(filter.filterDistance);
                  });
                }),
              ),
            ),
            Text(
              filter.filterDistance.toInt() != 1
                  ? '${filter.filterDistance.toInt()} กม'
                  : 'ไม่กำหนด',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'กรองรูปแบบสิ่งของ',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      filter.itemType != 'ทั้งหมด'
                          ? Colors.white
                          : Theme.of(context).primaryColor)),
              onPressed: (() {
                setState(() {
                  filter.itemType = 'ทั้งหมด';
                  print('ทั้งหมด');
                });
              }),
              child: Container(
                width: 100,
                height: 30,
                child: Text(
                  "ทั้งหมด",
                  style: filter.itemType == 'ทั้งหมด'
                      ? Theme.of(context).textTheme.bodyText2
                      : Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      filter.itemType != 'แลก'
                          ? Colors.white
                          : Theme.of(context).primaryColor)),
              onPressed: (() {
                setState(() {
                  filter.itemType = 'แลก';
                  print('แลก');
                });
              }),
              child: Container(
                width: 100,
                height: 30,
                child: Text(
                  "แลก",
                  style: filter.itemType == 'แลก'
                      ? Theme.of(context).textTheme.bodyText2
                      : Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      filter.itemType != 'ให้'
                          ? Colors.white
                          : Theme.of(context).primaryColor)),
              onPressed: (() {
                setState(() {
                  filter.itemType = 'ให้';
                  print('ให้');
                });
              }),
              child: Container(
                width: 100,
                height: 30,
                child: Text(
                  "ให้",
                  style: filter.itemType == 'ให้'
                      ? Theme.of(context).textTheme.bodyText2
                      : Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
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
        onTap: () {
          filter.noti();
          Navigator.pop(context);
        },
      ),
    );
  }
}
