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

class _FilterScreenState extends State<FilterScreen> {
  Map<String, List<String>> allCategory = {
    'หมวดหมู่ทั้งหมด': ['หมวดหมู่รองทั้งหมด'],
    'เสื้อผ้า': ['เสื้อผ้าชาย', 'เสื้อผ้าหญิง'],
    'เครื่องใช้ไฟฟ้า': ['ขนาดใหญ่', 'ขนาดเล็ก'],
  };

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
          ],
        ),
      ),
    );
  }
}
