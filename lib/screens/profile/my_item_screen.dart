import 'package:exshange/helpers/datetimehelper.dart';
import 'package:exshange/models/item.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:exshange/providers/items.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class MyItemsScreen extends StatefulWidget {
  const MyItemsScreen({Key? key}) : super(key: key);
  final routeName = '/myitems';
  @override
  State<MyItemsScreen> createState() => _MyItemsScreenState();
}

class _MyItemsScreenState extends State<MyItemsScreen> {
  var datetimeHelper = DateTimeHelper();
  @override
  Widget build(BuildContext context) {
    User? user = context.read<Authentication>().currentUser;
    List<Item> myItems = context
        .read<Items>()
        .items
        .where(
          (item) => item.ownerid == user!.uid,
        )
        .where(
          (item) => item.status == 'on',
        )
        .toList();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text('รายการของฉัน'),
      ),
      body: ListView.builder(
        itemCount: myItems.length,
        itemBuilder: ((context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: 140,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(15),
                        ),
                        child: Image.network(
                          myItems[index].imagesUrl[0],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: ClipRRect(
                          borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(15),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        myItems[index].name.length > 16
                                            ? '${myItems[index].name.substring(0, 16)}...'
                                            : '${myItems[index].name}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          color: myItems[index].itemType ==
                                                  'ให้'
                                              ? Theme.of(context).accentColor
                                              : Theme.of(context).primaryColor,
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                          child: Text(
                                            '${myItems[index].itemType}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Text(
                                  '${datetimeHelper.timestampToDateTIme(myItems[index].timestamp)}',
                                  style: Theme.of(context).textTheme.caption,
                                )
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
