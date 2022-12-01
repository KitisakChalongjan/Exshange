import 'package:exshange/models/offer.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:exshange/screens/profile/my_deal_detail_screen.dart';
import 'package:exshange/screens/profile/my_history_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../providers/offers.dart';

class MyHistoryScreen extends StatefulWidget {
  const MyHistoryScreen({Key? key}) : super(key: key);
  final routeName = '/myhistory';
  @override
  State<MyHistoryScreen> createState() => _MyHistoryScreenState();
}

class _MyHistoryScreenState extends State<MyHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    // var offer = context.read<Offers>().offers;
    var user = context.read<Authentication>().currentUser!;
    // var selectedOffer = offer
    //     .where((offer) => offer.status == 'accepted' || offer.status == 'done')
    //     .where((offer) =>
    //         offer.firstUser.userId == user.uid ||
    //         offer.secondUser.userId == user.uid)
    //     .toList();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text('ประวัติการทำรายการ'),
      ),
      body: FutureBuilder(
        future: context.read<Offers>().fetchMyOffersData(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            var offer = context.watch<Offers>().offers;
            var selectedOffer = offer
                .where(
                  (offer) =>
                      offer.status == 'pendingdone' ||
                      offer.status == 'rejecteddone',
                )
                .where(
                  (offer) =>
                      offer.firstUser.userId == user.uid ||
                      offer.secondUser.userId == user.uid,
                )
                .toList();
                selectedOffer.sort();
            return ListView.builder(
              itemCount: selectedOffer.length,
              itemBuilder: ((context, index) {
                return GestureDetector(
                  onTap: (() {
                    Navigator.of(context).pushNamed(
                        MyHistoryDetailScreen().routeName,
                        arguments: selectedOffer[index]);
                  }),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    height: 140,
                    child: Card(
                      color: selectedOffer[index].status == 'pendingdone'
                          ? Theme.of(context).disabledColor
                          : Theme.of(context).splashColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Text(
                                      selectedOffer[index].firstUser.userId ==
                                              user.uid
                                          ? selectedOffer[index].firstUser.name
                                          : selectedOffer[index]
                                              .secondUser
                                              .name,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.grey.withOpacity(0.25),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: Offset(1, 3),
                                          ),
                                        ]),
                                        width: double.infinity,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: selectedOffer[index]
                                                      .firstUser
                                                      .userId ==
                                                  user.uid
                                              ? Image.network(
                                                  selectedOffer[index]
                                                      .firstOfferItem
                                                      .imagesUrl[0],
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  selectedOffer[index]
                                                      .secondOfferItem
                                                      .imagesUrl[0],
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      selectedOffer[index].firstUser.userId ==
                                              user.uid
                                          ? selectedOffer[index]
                                              .firstOfferItem
                                              .name
                                          : selectedOffer[index]
                                              .secondOfferItem
                                              .name,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: Icon(
                                  Icons.loop_sharp,
                                  size: 40,
                                  color: Colors.grey[100],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Text(
                                      selectedOffer[index].firstUser.userId ==
                                              user.uid
                                          ? selectedOffer[index].secondUser.name
                                          : selectedOffer[index].firstUser.name,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.grey.withOpacity(0.25),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: Offset(1, 3),
                                          ),
                                        ]),
                                        width: double.infinity,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: selectedOffer[index]
                                                      .firstUser
                                                      .userId ==
                                                  user.uid
                                              ? Image.network(
                                                  selectedOffer[index]
                                                      .secondOfferItem
                                                      .imagesUrl[0],
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  selectedOffer[index]
                                                      .firstOfferItem
                                                      .imagesUrl[0],
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      selectedOffer[index].firstUser.userId ==
                                              user.uid
                                          ? selectedOffer[index]
                                              .secondOfferItem
                                              .name
                                          : selectedOffer[index]
                                              .firstOfferItem
                                              .name,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }
}
