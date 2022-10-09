import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/models/user.dart';
import 'package:exshange/providers/items.dart';
import 'package:exshange/screens/home/item_overview_screen.dart';
import 'package:exshange/screens/home/offer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({super.key});
  final routeName = '/itemdetail';

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getItemOwnerData(String id) async {
    var docItemOwner = await db.collection('users').doc('${id}').get();
    var dataItemOwner = docItemOwner.data();
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
                tag: 'heroItem${args.index}',
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
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: item.itemType == 'แลก'
                            ? Theme.of(context).primaryColorLight
                            : Color(0XFF68EDD2),
                        boxShadow: [],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        item.itemType == 'แลก' ? 'แลก' : 'ให้',
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
                                    child: ClipOval(
                                      child: Image.network(
                                        snapshot.data!['profileImageUrl'],
                                      ),
                                    ),
                                  ),
                                  Text(
                                    snapshot.data!['name'],
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
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
                      }
                      snapshot.data;
                      return SizedBox();
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
            OfferScreen().routeName,
            arguments: ItemArgs(
              args.itemId,
              args.index,
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
