import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/models/item.dart';
import 'package:exshange/providers/items.dart';
import 'package:exshange/screens/profile/my_item_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class MyItemDetailScreen extends StatefulWidget {
  const MyItemDetailScreen({Key? key}) : super(key: key);
  final routeName = 'myitemdetail';

  @override
  State<MyItemDetailScreen> createState() => _MyItemDetailScreenState();
}

class _MyItemDetailScreenState extends State<MyItemDetailScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  var isLoadig = false;

  @override
  Widget build(BuildContext context) {
    MyItemArg itemArg = ModalRoute.of(context)!.settings.arguments as MyItemArg;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('รายการของฉัน'),
      ),
      body: isLoadig
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration:
                        BoxDecoration(color: Color.fromARGB(255, 57, 57, 57)),
                    height: 400,
                    width: double.infinity,
                    child: Hero(
                      tag: 'heromyitem${itemArg.index}',
                      child: Image.network(
                        itemArg.item.imagesUrl[0],
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
                              itemArg.item.name,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: itemArg.item.itemType == 'แลก'
                                  ? Theme.of(context).primaryColorLight
                                  : Color(0XFF68EDD2),
                              boxShadow: [],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              itemArg.item.itemType == 'แลก' ? 'แลก' : 'ให้',
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
                    height: 300,
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
                                  itemArg.item.detail,
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
                                          '${itemArg.item.address}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: GestureDetector(
        child: BottomAppBar(
          color: Theme.of(context).errorColor,
          child: Container(
            height: 40,
            child: Text(
              'ลบ',
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        onTap: (() async {
          setState(() {
            isLoadig = true;
          });
          itemArg.item.imagesUrl.forEach((imageUrl) async {
            print(imageUrl);
            await storage.refFromURL(imageUrl).delete();
            print('Delete Image : ${imageUrl}');
          });
          await db.collection('items').doc(itemArg.item.id).delete();
          print('Delete Item : ${itemArg.item.id}');
          var targetOffer = await db
              .collection('offers')
              .where('firstOfferItemId', isEqualTo: itemArg.item.id)
              .get();
          targetOffer.docs.forEach((offer) async {
            await offer.reference.delete();
            print('Delete Offer => ${offer.id}');
          });
          await context.read<Items>().initItemsData();
          isLoadig = false;
          Navigator.pop(context);
        }),
      ),
    );
  }
}
