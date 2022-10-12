import 'package:exshange/helpers/datetimehelper.dart';
import 'package:exshange/models/offer.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:exshange/providers/offers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class MyDealScreen extends StatefulWidget {
  const MyDealScreen({Key? key}) : super(key: key);
  final routeName = '/mydeal';
  @override
  State<MyDealScreen> createState() => _MyDealScreenState();
}

class _MyDealScreenState extends State<MyDealScreen> {
  var datetimeHelper = DateTimeHelper();

  bool offerTab = true;

  @override
  Widget build(BuildContext context) {
    var offers = context.read<Offers>();
    var user = context.read<Authentication>().currentUser;
    offers.fetchMyOffersData();
    var myOffers = offers.offers;
    List<Offer> selectedOffer;
    if (offerTab == true) {
      selectedOffer = myOffers
          .where((offer) => offer.secondUser.userId == user!.uid)
          .toList();
    } else {
      selectedOffer = myOffers
          .where((offer) => offer.firstUser.userId == user!.uid)
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('ข้อเสนอทั้งหมด'),
      ),
      body: FutureBuilder(
        future: offers.fetchMyOffersData(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.25),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(1, 3),
                      )
                    ],
                  ),
                  height: 40,
                  width: double.infinity,
                  child: Row(children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: (() {
                          if (offerTab == true) {
                            return;
                          }
                          setState(() {
                            offerTab = true;
                          });
                          print('mySendOffer');
                        }),
                        child: Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: offerTab == true
                                ? Colors.white
                                : Theme.of(context).primaryColorLight,
                          ),
                          child: Center(
                            child: Text(
                              'ข้อเสนอของฉัน',
                              style: offerTab == true
                                  ? Theme.of(context).textTheme.bodyText1
                                  : Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: (() {
                          if (offerTab == false) {
                            return;
                          }
                          setState(() {
                            offerTab = false;
                          });
                          print('myReceiveOffer');
                        }),
                        child: Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: offerTab == true
                                ? Theme.of(context).primaryColorLight
                                : Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              'ข้อเสนอที่ได้รับ',
                              style: offerTab == true
                                  ? Theme.of(context).textTheme.bodyText2
                                  : Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: selectedOffer.length,
                    itemBuilder: ((context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
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
                                      offerTab == true
                                          ? selectedOffer[index]
                                              .firstOfferItem
                                              .imagesUrl[0]
                                          : selectedOffer[index]
                                              .secondOfferItem
                                              .imagesUrl[0],
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    offerTab == true
                                                        ? '${selectedOffer[index].firstOfferItem.name}'
                                                        : '${selectedOffer[index].secondOfferItem.name}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                      color: myOffers[index]
                                                                  .firstOfferItem
                                                                  .itemType ==
                                                              'ให้'
                                                          ? Theme.of(context)
                                                              .accentColor
                                                          : Theme.of(context)
                                                              .primaryColor,
                                                    ),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                      ),
                                                      child: Text(
                                                        '${selectedOffer[index].firstOfferItem.itemType}',
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
                                              '${datetimeHelper.timestampToDateTIme(selectedOffer[index].firstOfferItem.timestamp)}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
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
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}
