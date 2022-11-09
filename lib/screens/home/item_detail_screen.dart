// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import 'package:exshange/models/user.dart';
import 'package:exshange/providers/items.dart';
import 'package:exshange/screens/chat/chat_message_screen.dart';
import 'package:exshange/screens/home/donate_screen.dart';
import 'package:exshange/screens/home/item_overview_screen.dart';
import 'package:exshange/screens/home/offer_screen.dart';

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({super.key});
  final routeName = '/itemdetail';

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class UserChatArg {
  String userId;
  String userName;
  String userImageUrl;

  UserChatArg({
    required this.userId,
    required this.userName,
    required this.userImageUrl,
  });
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getItemOwnerData(String id) async {
    var docItemOwner = await db.collection('users').doc('${id}').get();
    var dataItemOwner = docItemOwner.data();
    dataItemOwner!.addAll({'id': '${docItemOwner.id}'});
    await Future.delayed(const Duration(seconds: 1));
    return dataItemOwner;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ItemArgs;
    final items = context.read<Items>().items;
    final item = items.firstWhere((element) => element.id == args.itemId);
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียด'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Color.fromARGB(255, 57, 57, 57)),
              height: 400,
              width: double.infinity,
              child: Hero(
                tag: args.from == 'overview'
                    ? 'heroItem${args.index}'
                    : 'heroItemRec${args.index}',
                child: Image.network(
                  item.imagesUrl[0],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 45,
              child: Row(
                children: [
                  Flexible(
                    flex: 8,
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        boxShadow: [],
                      ),
                      child: Text(
                        item.name,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: item.itemType == 'แลก'
                            ? Theme.of(context).primaryColorLight
                            : Color(0XFF68EDD2),
                        boxShadow: [],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        item.itemType == 'แลก' ? 'แลกเปลี่ยน' : 'บริจาค',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              height: 360,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.detail,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          SizedBox(
                            height: 60,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Theme.of(context).hintColor,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    '${item.address}',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Divider(
                      height: 5,
                      color: Colors.grey,
                    ),
                  ),
                  FutureBuilder(
                    future: getItemOwnerData(item.ownerid),
                    builder: ((
                      context,
                      AsyncSnapshot<Map<String, dynamic>?> snapshot,
                    ) {
                      if (snapshot.hasData) {
                        var itemOwnerData = snapshot.data!;
                        return SizedBox(
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Container(
                                      width: 60,
                                      child: Image.network(
                                        itemOwnerData['profileImageUrl'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    itemOwnerData['name'],
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
                              ),
                              GestureDetector(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  padding: EdgeInsets.all(5),
                                  child: Icon(
                                    size: 30,
                                    color: Theme.of(context).hintColor,
                                    Icons.chat_bubble,
                                  ),
                                ),
                                onTap: (() {
                                  Navigator.pushNamed(
                                    context,
                                    ChatMessageScreen().routeName,
                                    arguments: UserChatArg(
                                      userId: itemOwnerData['id'],
                                      userName: itemOwnerData['name'],
                                      userImageUrl:
                                          itemOwnerData['profileImageUrl'],
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        );
                      }
                      return SizedBox(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  child: CircleAvatar(child: null),
                                ),
                                Text(
                                  'loading',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              padding: EdgeInsets.all(5),
                              child: Icon(
                                size: 30,
                                color: Theme.of(context).hintColor,
                                Icons.chat_bubble,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: (() {
          Navigator.of(context).pushNamed(
            item.itemType == 'แลก'
                ? OfferScreen().routeName
                : DonateScreen().routeName,
            arguments: ItemArgs(
              itemId: args.itemId,
              index: args.index,
              from: args.from,
            ),
          );
        }),
        child: BottomAppBar(
          color: item.itemType == "แลก"
              ? Theme.of(context).primaryColor
              : Color(0XFF68EDD2),
          child: Container(
            height: 40,
            child: Text(
              item.itemType == "แลก" ? 'เสนอ' : 'ขอ',
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
