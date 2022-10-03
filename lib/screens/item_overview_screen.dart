import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:exshange/providers/user_data.dart';
import 'package:exshange/screens/filter_screen.dart';
import 'package:exshange/screens/item_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../providers/items.dart';

class ItemArgs {
  String itemId;
  int index;

  ItemArgs(
    this.itemId,
    this.index,
  );
}

class ItemOverviewScreen extends StatefulWidget {
  const ItemOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ItemOverviewScreen> createState() => _ItemOverviewScreenState();
}

class _ItemOverviewScreenState extends State<ItemOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    var itemsData = context.read<Items>();
    itemsData.initItemsData();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        toolbarHeight: 100,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    style: Theme.of(context).textTheme.bodyText1,
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
            child: Container(
              padding: EdgeInsets.all(5),
              child: Consumer<Items>(
                builder: (context, items, _) => itemsData.items.isEmpty
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : FutureBuilder(
                        future: itemsData.initItemsData(),
                        builder: ((context, snapshot) {
                          if (!snapshot.hasData) {
                            return GridView.builder(
                              itemCount: 6,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisExtent: 250,
                                crossAxisSpacing: 5,
                              ),
                              itemBuilder: (context, index) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return GridView.builder(
                              itemCount: items.items.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisExtent: 250,
                                crossAxisSpacing: 0,
                              ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      ItemDetailScreen().routeName,
                                      arguments: ItemArgs(
                                          itemsData.items[index].id, index),
                                    );
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: SizedBox(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            child: SizedBox(
                                              child: Hero(
                                                tag: 'heroItem${index}',
                                                child: SizedBox(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                      top: Radius.circular(15),
                                                    ),
                                                    child: Image.network(
                                                      items.items[index]
                                                          .imagesUrl[0],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  bottom: Radius.circular(15),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      items.items[index].name,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1,
                                                    ),
                                                    Text(
                                                      items.items[index].address
                                                                  .length >
                                                              16
                                                          ? '${items.items[index].address.substring(0, 16)}...'
                                                          : items.items[index]
                                                              .address,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        })),
              ),
            ),
          )
        ],
      ),
    );
  }
}
