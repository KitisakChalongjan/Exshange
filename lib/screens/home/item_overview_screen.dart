import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/helpers/geolocator.dart';
import 'package:exshange/models/item.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:exshange/providers/filter.dart';
import 'package:exshange/providers/items.dart';
import 'package:exshange/providers/user_data.dart';
import 'package:exshange/screens/home/filter_screen.dart';
import 'package:exshange/screens/home/item_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class ItemArgs {
  String itemId;
  int index;

  ItemArgs({
    required this.itemId,
    required this.index,
  });
}

class ItemOverviewScreen extends StatefulWidget {
  const ItemOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ItemOverviewScreen> createState() => _ItemOverviewScreenState();
}

class _ItemOverviewScreenState extends State<ItemOverviewScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  late Position userPos;

  @override
  Widget build(BuildContext context) {
    var filter = context.watch<Filter>();
    List<Item> itemsData = context
        .watch<Items>()
        .items
        .where((item) => item.ownerid != user!.uid)
        .where((item) => item.status != 'off')
        .toList();
    List<Item> filteredItems = itemsData;

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
              child: filteredItems.isEmpty
                  ? Center(
                      child: Text('ไม่พบสิ่งของที่ต้องการ',
                          style: Theme.of(context).textTheme.subtitle2),
                    )
                  : FutureBuilder(
                      future: GeolocatorHelper().determinePosition(),
                      builder: ((context, snapshot) {
                        if (!snapshot.hasData) {
                          print('loading position');
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          print('success');
                          return Consumer<Filter>(
                            builder: ((context, value, child) {
                              Position currentPos = snapshot.data as Position;
                              print(
                                  '${currentPos.latitude} - ${currentPos.longitude}');

                              if (filter.filterCategory != 'หมวดหมู่ทั้งหมด') {
                                filteredItems = filteredItems
                                    .where((item) =>
                                        item.category == value.filterCategory)
                                    .toList();
                              }
                              if (filter.filterSubCategory !=
                                  'หมวดหมู่รองทั้งหมด') {
                                filteredItems = filteredItems
                                    .where((item) =>
                                        item.subCategory ==
                                        value.filterSubCategory)
                                    .toList();
                              }
                              filteredItems = filteredItems
                                  .where((item) =>
                                      GeolocatorHelper().getDistanceBetween(
                                          currentPos.latitude,
                                          currentPos.longitude,
                                          item.latitude,
                                          item.longitude) <
                                      filter.filterDistance * 1000)
                                  .toList();
                              if (filter.itemType != 'ทั้งหมด') {
                                filteredItems = filteredItems
                                    .where((item) =>
                                        item.itemType == filter.itemType)
                                    .toList();
                              }

                              return GridView.builder(
                                itemCount: filteredItems.length,
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
                                          itemId: filteredItems[index].id,
                                          index: index,
                                        ),
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
                                                        top:
                                                            Radius.circular(15),
                                                      ),
                                                      child: Image.network(
                                                        filteredItems[index]
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            filteredItems[index]
                                                                        .name
                                                                        .length >
                                                                    8
                                                                ? filteredItems[
                                                                        index]
                                                                    .name
                                                                    .substring(
                                                                        0, 8)
                                                                : filteredItems[
                                                                        index]
                                                                    .name,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1,
                                                          ),
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: filteredItems[
                                                                              index]
                                                                          .itemType ==
                                                                      'ให้'
                                                                  ? Theme.of(
                                                                          context)
                                                                      .accentColor
                                                                  : Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    5),
                                                              ),
                                                            ),
                                                            child: Text(
                                                              filteredItems[
                                                                      index]
                                                                  .itemType,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .subtitle1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        filteredItems[index]
                                                                    .address
                                                                    .length >
                                                                16
                                                            ? '${filteredItems[index].address.substring(0, 16)}...'
                                                            : filteredItems[
                                                                    index]
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
                            }),
                          );
                        }
                      }),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
