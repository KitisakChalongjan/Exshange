import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:exshange/providers/offers.dart';
import 'package:exshange/providers/user_data.dart';
import 'package:exshange/screens/profile/my_deal_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class MyDealDetailScreen extends StatefulWidget {
  const MyDealDetailScreen({Key? key}) : super(key: key);
  final routeName = '/mydealdetail';

  @override
  State<MyDealDetailScreen> createState() => _MyDealDetailScreenState();
}

class _MyDealDetailScreenState extends State<MyDealDetailScreen> {
  var isLoading = false;

  FirebaseFirestore db = FirebaseFirestore.instance;
  Reference storage = FirebaseStorage.instance.ref();

  @override
  Widget build(BuildContext context) {
    var user = context.read<Authentication>().currentUser!;
    var userData = context.read<UserData>();
    var offers = context.read<Offers>();
    final offerArg = ModalRoute.of(context)!.settings.arguments as OfferArge;
    var offer = offerArg.offer;
    var tab = offerArg.offerTab;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('รายละเอียดข้อเสนอ'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'คุณ',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    SizedBox(
                      height: 10,
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
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      tab == true
                          ? offer.secondOfferItem.name
                          : offer.firstOfferItem.name,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Icon(
                        Icons.loop_sharp,
                        color: offer.firstOfferItem.itemType == 'แลก'
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).accentColor,
                        size: 60,
                      ),
                    ),
                    Text(
                      tab == true
                          ? offer.firstUser.name
                          : offer.secondUser.name,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    SizedBox(
                      height: 10,
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
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          Container(
                            child: tab == true
                                ? Text(
                                    offer.firstOfferItem.name,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  )
                                : Text(
                                    offer.secondOfferItem.name,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
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
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  )
                                : Text(
                                    offer.secondOfferItem.detail,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
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
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      )
                                    : Text(
                                        offer.secondOfferItem.address,
                                        style:
                                            Theme.of(context).textTheme.caption,
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
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Container(
                                        width: 60,
                                        child: Image.network(
                                          offer.firstUser.profileImageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      offer.firstUser.name,
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
        child: tab == true
            ? GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.red,
                  ),
                  height: 60,
                  child: Text(
                    'ยกเลิกข้อเสนอ',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                onTap: (() async {
                  setState(() {
                    isLoading = true;
                  });
                  await db.collection('offers').doc(offer.id).delete();
                  print('Delete Offer:(${offer.id}) Successful!');
                  await db
                      .collection('items')
                      .doc(offer.secondOfferItem.id)
                      .delete();
                  print(
                      'Delete Item:(${offer.secondOfferItem.id}) Successful!');
                  offer.secondOfferItem.imagesUrl.forEach((element) async {
                    if (element ==
                        'https://firebasestorage.googleapis.com/v0/b/exshange-project.appspot.com/o/images%2F72-724263_donate-icon-investment-thenounproject-hd-png-download.png?alt=media&token=cfeb6f6a-69c4-4089-8eef-797ad439bc1e') {
                      return;
                    }
                    await storage.child('images').child(element).delete();
                    print('Delete Image:(${element}) Successful!');
                  });

                  await offers.fetchMyOffersData();
                  offers.notify();
                  isLoading = false;
                  Navigator.of(context).pop();
                }),
              )
            : Row(
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
                        decoration: offer.firstOfferItem.itemType == 'ให้'
                            ? BoxDecoration(
                                color: Theme.of(context).focusColor,
                              )
                            : BoxDecoration(
                                color: Theme.of(context).primaryColorLight,
                              ),
                        height: 60,
                        child: Text(
                          'ยอมรับ',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      onTap: (() async {
                        setState(() {
                          isLoading = true;
                        });
                        print(offer.id);
                        //change offer status
                        var updateOfferStatus =
                            await db.collection('offers').doc(offer.id).update({
                          'status': 'pending',
                        });
                        print('Offer(${offer.id}) status => pending!');

                        //update other offers status and items from this item
                        var otherOffer = await db
                            .collection('offers')
                            .where('firstOfferItemId',
                                isEqualTo: offer.firstOfferItem.id)
                            .where('secondOfferItemId',
                                isNotEqualTo: offer.secondOfferItem.id)
                            .get();
                        for (var iOffer in otherOffer.docs) {
                          await db
                              .collection('offers')
                              .doc(iOffer.id)
                              .update({'status': 'rejected'});
                              print('Offer(${iOffer.id}) status => rejected!');
                        }

                        //change item status
                        await db
                            .collection('items')
                            .doc(offer.firstOfferItem.id)
                            .update({'status': 'off'});
                        print('Item${offer.firstOfferItem.id} status => off');

                        //update user donate/trade count
                        // var responseOffer =
                        //     await db.collection('offers').doc(offer.id).get();
                        // var responseOfferData = responseOffer.data();
                        // if (responseOfferData!['status'] == 'accepted') {
                        //   var newCount;
                        //   var otherUserId;

                        //   if (offer.firstUser.userId == user.uid) {
                        //     otherUserId = offer.secondUser.userId;
                        //   } else {
                        //     otherUserId = offer.firstUser.userId;
                        //   }
                        //   var otherUser = await db
                        //       .collection('users')
                        //       .doc(otherUserId)
                        //       .get();
                        //   var otherUserData = otherUser.data();
                        //   if (offer.firstOfferItem.itemType == 'ให้') {
                        //     if (offer.firstUser.userId == user.uid) {
                        //       newCount = userData.userModel!.donateCount + 1;
                        //       await db
                        //           .collection('users')
                        //           .doc(offer.firstUser.userId)
                        //           .update({'donateCount': newCount});
                        //     }
                        //   } else {
                        //     var firstUserNewCount;
                        //     var secondUserNewCount;
                        //     if (offer.firstUser.userId == user.uid) {
                        //       firstUserNewCount =
                        //           userData.userModel!.tradeCount + 1;
                        //       secondUserNewCount =
                        //           otherUserData!['tradeCount'] + 1;
                        //     } else {
                        //       firstUserNewCount =
                        //           otherUserData!['tradeCount'] + 1;
                        //       secondUserNewCount =
                        //           userData.userModel!.tradeCount + 1;
                        //     }
                        //     await db
                        //         .collection('users')
                        //         .doc(offer.firstUser.userId)
                        //         .update(
                        //       {'tradeCount': firstUserNewCount},
                        //     );
                        //     await db
                        //         .collection('users')
                        //         .doc(offer.secondUser.userId)
                        //         .update(
                        //       {'tradeCount': secondUserNewCount},
                        //     );
                        //   }
                        //   //success
                        //   print('Offer Id : ${responseOffer.id} Updated!');
                        //   print(
                        //       'Status From : \'offer\' ==> ${responseOfferData['status']}');
                        //   await offers.fetchMyOffersData();
                        //   await userData.fetchUserData(user.uid);
                        // } else {
                        //   print('Update Offer Status Failed :');
                        // }
                        isLoading = false;
                        if (!mounted) return;
                        offers.notify();
                        Navigator.pop(context);
                      }),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
