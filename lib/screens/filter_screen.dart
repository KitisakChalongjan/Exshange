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
  List<String> category = [
    'item1',
    'item2',
  ];
  String? selectedCategory = 'item1';
  List<String> category2 = [
    'Goods1',
    'Goods2',
  ];
  String? selectedCategory2 = 'Goods1';
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
            SizedBox(
              width: 360,
              height: 60,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                value: selectedCategory,
                items: category
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
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),
            ),
            SizedBox(
              width: 360,
              height: 60,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                value: selectedCategory2,
                items: category2
                    .map(
                      (item) => DropdownMenuItem<String>(
                        child: Text(
                          item,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        value: item,
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory2 = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
