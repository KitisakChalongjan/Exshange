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
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                  child: TextFormField(
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
      body: Consumer<Items>(
        builder: (context, items, _) => GridView.builder(
          itemCount: items.items.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return Card(
              child: Column(
                children: [
                  Text(items.items[index].title),
                  Text(items.items[index].detail),
                  Text(items.items[index].address),
                  Text(items.items[index].category),
                  Text(items.items[index].subcategory),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
