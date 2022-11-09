import 'package:exshange/models/item.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:exshange/providers/items.dart';
import 'package:exshange/providers/user_data.dart';
import 'package:exshange/screens/home/item_detail_screen.dart';
import 'package:exshange/screens/home/item_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class RecommendScreen extends StatefulWidget {
  const RecommendScreen({Key? key}) : super(key: key);

  @override
  State<RecommendScreen> createState() => _RecommendScreenState();
}

class _RecommendScreenState extends State<RecommendScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    var currentUser = context.read<Authentication>().currentUser;
    var userData = context.watch<UserData>().userModel!;
    var favCate = userData.favoriteCategories as List<dynamic>;
    List<Item> itemsData = context
        .watch<Items>()
        .items
        .where((item) => item.ownerid != currentUser!.uid)
        .where((item) => item.status != 'off')
        .where((item) => favCate.contains(item.category))
        .toList();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text('แนะนำสำหรับคุณ'),
      ),
      body: Center(
        child: SizedBox( // card height
          child: itemsData.isEmpty
              ? Center(
                  child: Text(
                    'ไม่มีรายกรแนะนำ',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                )
              : PageView.builder(
                  itemCount: itemsData.length,
                  controller: PageController(viewportFraction: 0.75),
                  onPageChanged: (int index) => setState(() => _index = index),
                  itemBuilder: (_, i) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 120),
                      child: Transform.scale(
                        scale: i == _index ? 1 : 0.85,
                        child: GestureDetector(
                          onTap: (() {
                            Navigator.of(context).pushNamed(
                              ItemDetailScreen().routeName,
                              arguments: ItemArgs(
                                itemId: itemsData[i].id,
                                index: i,
                                from: 'recommend',
                              ),
                            );
                          }),
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: Hero(
                                      tag: 'heroItemRec${i}',
                                      child: SizedBox(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(15),
                                          ),
                                          child: Image.network(
                                            itemsData[i].imagesUrl[0],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(15),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  itemsData[i].name.length > 8
                                                      ? itemsData[i]
                                                          .name
                                                          .substring(0, 8)
                                                      : itemsData[i].name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        itemsData[i].itemType ==
                                                                'ให้'
                                                            ? Theme.of(context)
                                                                .accentColor
                                                            : Theme.of(context)
                                                                .primaryColor,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(5),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    itemsData[i].itemType,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              itemsData[i].province,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
