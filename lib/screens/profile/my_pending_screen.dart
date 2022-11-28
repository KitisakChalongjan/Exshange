import 'package:exshange/providers/authentication.dart';
import 'package:exshange/screens/profile/my_pending_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../providers/offers.dart';

class MyPendingScreen extends StatefulWidget {
  const MyPendingScreen({super.key});
  final routeName = '/mypending';

  @override
  State<MyPendingScreen> createState() => _MyPendingScreenState();
}

class _MyPendingScreenState extends State<MyPendingScreen> {
  @override
  Widget build(BuildContext context) {
    var user = context.read<Authentication>().currentUser!;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text('ข้อเสนอที่ได้รับการยืนยัน'),
      ),
      body: FutureBuilder(
        future: context.read<Offers>().fetchMyOffersData(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            var offer = context.watch<Offers>().offers;
            var selectedOffer = offer
                .where((offer) =>
                    offer.status == 'pending' || offer.status == 'rejected')
                .where((offer) =>
                    offer.firstUser.userId == user.uid ||
                    offer.secondUser.userId == user.uid)
                .toList();
            return ListView.builder(
              itemCount: selectedOffer.length,
              itemBuilder: ((context, index) {
                return GestureDetector(
                  onTap: (() {
                    Navigator.of(context).pushNamed(
                        MyPendingDetailScreen().routeName,
                        arguments: selectedOffer[index]);
                  }),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    height: 140,
                    child: Card(
                      color: selectedOffer[index].status == 'pending'
                          ? Theme.of(context).canvasColor
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
                                      'คุณ',
                                      // selectedOffer[index].firstUser.userId ==
                                      //         user.uid
                                      //     ? selectedOffer[index].firstUser.name
                                      //     : selectedOffer[index]
                                      //         .secondUser
                                      //         .name,
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
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Icon(
                                      Icons.loop_sharp,
                                      size: 40,
                                      color: Colors.grey[100],
                                    ),
                                  ),
                                  selectedOffer[index].status == 'pending'
                                      ? Text(
                                          'ยอมรับ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        )
                                      : Text(
                                          'ปฏิเสธ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        )
                                ],
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
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
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
