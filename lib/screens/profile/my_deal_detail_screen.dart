import 'package:exshange/screens/profile/my_deal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MyDealDetailScreen extends StatefulWidget {
  const MyDealDetailScreen({Key? key}) : super(key: key);
  final routeName = '/mydealdetail';

  @override
  State<MyDealDetailScreen> createState() => _MyDealDetailScreenState();
}

class _MyDealDetailScreenState extends State<MyDealDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final offerArg = ModalRoute.of(context)!.settings.arguments as OfferArge;
    var offer = offerArg.offer;
    var tab = offerArg.offerTab;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('รายละเอียดข้อเสนอ'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 57, 57, 57),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(1, 3),
                    ),
                  ],
                ),
                height: 240,
                width: 240,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    tab == true
                        ? offer.secondOfferItem.imagesUrl[0]
                        : offer.firstOfferItem.imagesUrl[0],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Icon(
                  Icons.loop_sharp,
                  color: Colors.black,
                  size: 40,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 57, 57, 57),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(1, 3),
                    ),
                  ],
                ),
                height: 240,
                width: 240,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    tab == true
                        ? offer.firstOfferItem.imagesUrl[0]
                        : offer.secondOfferItem.imagesUrl[0],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    Container(
                      child: tab == true
                          ? Text(
                              offer.firstOfferItem.name,
                              style: Theme.of(context).textTheme.bodyText1,
                            )
                          : Text(
                              offer.secondOfferItem.name,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      constraints: const BoxConstraints(minHeight: 200),
                      alignment: Alignment.topLeft,
                      child: tab == true
                          ? Text(
                              offer.firstOfferItem.detail,
                              style: Theme.of(context).textTheme.bodyText1,
                            )
                          : Text(
                              offer.secondOfferItem.detail,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.location_on,
                          color: Theme.of(context).hintColor,
                        ),
                        Expanded(
                          child: tab == true
                              ? Text(
                                  offer.firstOfferItem.address,
                                  style: Theme.of(context).textTheme.caption,
                                )
                              : Text(
                                  offer.secondOfferItem.address,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(
                        height: 5,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
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
                                    offer.firstUser.profileImageUrl,
                                  ),
                                ),
                              ),
                              Text(
                                offer.firstUser.name,
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
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.red,
                  ),
                  height: 60,
                  child: Text(
                    'ปฏิเสธ',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                onTap: (() {
                  Navigator.of(context).pop();
                }),
              ),
            ),
            Expanded(
              child: GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  decoration:
                      offer.firstOfferItem.itemType == 'ให้' && tab == true
                          ? BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                            )
                          : BoxDecoration(
                              color: Theme.of(context).primaryColor,
                            ),
                  height: 60,
                  child: Text(
                    'ยอมรับ',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                onTap: (() async {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
