import 'dart:ui';

import 'package:exshange/screens/filter_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../providers/items.dart';

class ItemOverviewScreen extends StatefulWidget {
  const ItemOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ItemOverviewScreen> createState() => _ItemOverviewScreenState();
}

class _ItemOverviewScreenState extends State<ItemOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Text(
                      "Logo",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                  child: TextField(
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      filled: true,
                      fillColor: Theme.of(context).backgroundColor,
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: Icon(Icons.search),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(FilterScreen().routeName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark,
              ),
              width: double.infinity,
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ตัวกรอง',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Icon(Icons.filter_list, color: Colors.white),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Consumer<Items>(
              builder: (context, items, _) => GridView.builder(
                itemCount: items.items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Image.network(items.items[index].imageUrl),
                            Text(items.items[index].title),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
