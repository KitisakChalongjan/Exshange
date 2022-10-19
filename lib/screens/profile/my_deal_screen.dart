import 'package:exshange/helpers/datetimehelper.dart';
import 'package:exshange/models/offer.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:exshange/providers/offers.dart';
import 'package:exshange/providers/user_data.dart';
import 'package:exshange/screens/profile/my_deal_detail_screen.dart';
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
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text('ข้อเสนอทั้งหมด'),
      ),
      body: Column(
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
          OfferListWidget(offerTab: offerTab, datetimeHelper: datetimeHelper),
        ],
      ),
    );
  }
}

class OfferArge {
  Offer offer;
  bool offerTab;

  OfferArge({required this.offer, required this.offerTab});
}

class OfferListWidget extends StatefulWidget {
  const OfferListWidget({
    Key? key,
    required this.offerTab,
    required this.datetimeHelper,
  }) : super(key: key);
  final bool offerTab;
  final DateTimeHelper datetimeHelper;

  @override
  State<OfferListWidget> createState() => _OfferListWidgetState();
}

class _OfferListWidgetState extends State<OfferListWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.watch<Offers>().fetchMyOffersData(),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          print('circle');
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          var offers = context.read<Offers>();
          var user = context.read<Authentication>().currentUser;
          var myOffers = offers.offers;
          List<Offer> selectedOffer;
          var onOfferOffers =
              myOffers.where((offer) => offer.status == 'offer').toList();
          if (widget.offerTab == true) {
            selectedOffer = onOfferOffers
                .where((offer) => offer.secondUser.userId == user!.uid)
                .where((offer) => offer.status == 'offer')
                .toList();
          } else {
            selectedOffer = onOfferOffers
                .where((offer) => offer.firstUser.userId == user!.uid)
                .where((offer) => offer.status == 'offer')
                .toList();
          }
          print('done');
          return Expanded(
            child: ListView.builder(
              itemCount: selectedOffer.length,
              itemBuilder: ((context, index) {
                return GestureDetector(
                  onTap: (() {
                    Navigator.of(context).pushNamed(
                      const MyDealDetailScreen().routeName,
                      arguments: OfferArge(
                        offer: selectedOffer[index],
                        offerTab: widget.offerTab,
                      ),
                    );
                  }),
                  child: Container(
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
                              flex: 2,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Text(
                                      widget.offerTab == true
                                          ? selectedOffer[index]
                                              .secondOfferItem
                                              .name
                                          : selectedOffer[index]
                                              .firstOfferItem
                                              .name,
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
                                          child: widget.offerTab == true
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
                                      widget.offerTab == true
                                          ? selectedOffer[index].secondUser.name
                                          : selectedOffer[index].firstUser.name,
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
                                child: Icon(Icons.loop_sharp,
                                    size: 40,
                                    color: selectedOffer[index]
                                                .firstOfferItem
                                                .itemType ==
                                            'ให้'
                                        ? Theme.of(context).accentColor
                                        : Theme.of(context).primaryColor),
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
                                      widget.offerTab == true
                                          ? selectedOffer[index]
                                              .firstOfferItem
                                              .name
                                          : selectedOffer[index]
                                              .secondOfferItem
                                              .name,
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
                                          child: widget.offerTab == true
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
                                      widget.offerTab == true
                                          ? selectedOffer[index].firstUser.name
                                          : selectedOffer[index]
                                              .secondUser
                                              .name,
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
            ),
          );
        }
      }),
    );
  }
}
