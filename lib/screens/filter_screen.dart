import 'package:exshange/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);
  final routeName = '/filter';

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

enum ItemType { all, give, trade }

class _FilterScreenState extends State<FilterScreen> {
  Map<String, List<String>> allCategory = {
    'หมวดหมู่ทั้งหมด': ['หมวดหมู่รองทั้งหมด'],
    'เสื้อผ้าชาย': [
      'เสื้อ',
      'กางเกง',
      'ส่วมใส่เท้า',
      'เข็มขัด',
      'เครื่องประดับ'
    ],
    'เสื้อผ้าหญิง': [
      'เสื้อ',
      'กระโปรง',
      'ส่วมใส่เท้า',
      'กางเกง',
      'เครื่องประดับ',
      'เข็มขัด'
    ],
    'เครื่องใช้ไฟฟ้าภายในบ้าน': [
      'ห้องครัว',
      'ห้องน้ำ',
      'ห้องนั้งเล่น',
      'ห้องนอน'
    ],
    'เครื่องใช้ภายในบ้าน': ['ห้องครัว', 'ห้องน้ำ', 'ห้องนั้งเล่น', 'ห้องนอน'],
    'อุปกรณ์กีฬาและกิจกรรมกลางแจ้ง': [
      'อุปกรณ์กีฬา',
      'เครื่องออกกำลังกาย',
      'อุปกรณ์ปิกนิกและเดินป่า'
    ],
    'สื่อการเรียนรู้และงานอดิเรก': ['หนังสือ', 'สารคดี', 'เครื่องดนตรี'],
  };

  double distance = 5;

  ItemType itemType = ItemType.all;

  String? selectedCategory = 'หมวดหมู่ทั้งหมด';

  List<String> category2 = ['หมวดหมู่รองทั้งหมด'];
  String? selectedCategory2 = 'หมวดหมู่รองทั้งหมด';

  @override
  Widget build(BuildContext context) {
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
                  // decoration: InputDecoration(
                  //   fillColor: Colors.white,
                  //   filled: true,
                  //   // enabledBorder: OutlineInputBorder(
                  //   //   borderRadius: BorderRadius.circular(10),
                  //   //   borderSide: BorderSide.none,
                  //   // ),
                  // ),
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
                  // decoration: InputDecoration(
                  //   fillColor: Colors.white,
                  //   filled: true,
                  //   // enabledBorder: OutlineInputBorder(
                  //   //   borderRadius: BorderRadius.circular(10),
                  //   //   borderSide: BorderSide.none,
                  //   // ),
                  // ),
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
            SizedBox(
              height: 30,
            ),
            Text(
              'กรองตามระยะทาง',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Slider(
              min: 5.0,
              max: 1000.0,
              value: distance,
              onChanged: ((value) {
                setState(() {
                  distance = value;
                  print(distance);
                });
              }),
            ),
            Text(
              '${distance.toInt()}',
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
                      itemType != ItemType.all
                          ? Colors.white
                          : Theme.of(context).primaryColor)),
              onPressed: (() {
                setState(() {
                  itemType = ItemType.all;
                });
              }),
              child: Container(
                width: 100,
                height: 30,
                child: Text(
                  "ทั้งหมด",
                  style: itemType == ItemType.all
                      ? Theme.of(context).textTheme.bodyText2
                      : Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      itemType != ItemType.trade
                          ? Colors.white
                          : Theme.of(context).primaryColor)),
              onPressed: (() {
                setState(() {
                  itemType = ItemType.trade;
                });
              }),
              child: Container(
                width: 100,
                height: 30,
                child: Text(
                  "แลกเปลี่ยน",
                  style: itemType == ItemType.trade
                      ? Theme.of(context).textTheme.bodyText2
                      : Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      itemType != ItemType.give
                          ? Colors.white
                          : Theme.of(context).primaryColor)),
              onPressed: (() {
                setState(() {
                  itemType = ItemType.give;
                });
              }),
              child: Container(
                width: 100,
                height: 30,
                child: Text(
                  "บริจาค",
                  style: itemType == ItemType.give
                      ? Theme.of(context).textTheme.bodyText2
                      : Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
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
