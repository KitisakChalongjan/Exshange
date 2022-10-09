import 'package:exshange/helpers/datetimehelper.dart';
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
  @override
  Widget build(BuildContext context) {
    var offers = context.read<Offers>();
    offers.fetchMyOffersData();
    var myOffers = offers.offers;

    var firstUserId;
    var secondUserId;
    var firstOfferItem;
    var secondOfferItem;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('ข้อเสนอทั้งหมด'),
      ),
      body: ListView.builder(
        itemCount: myOffers.length,
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
                          myOffers[index].firstOfferItem.imagesUrl[0],
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
                                        '${myOffers[index].firstUser.name}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          color: myOffers[index]
                                                      .firstOfferItem
                                                      .itemType ==
                                                  'ให้'
                                              ? Theme.of(context).accentColor
                                              : Theme.of(context).primaryColor,
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                          child: Text(
                                            '${myOffers[index].firstOfferItem.itemType}',
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
                                  '${datetimeHelper.timestampToDateTIme(myOffers[index].firstOfferItem.timestamp)}',
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
