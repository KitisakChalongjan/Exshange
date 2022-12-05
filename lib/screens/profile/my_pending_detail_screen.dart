import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../models/offer.dart';
import '../../providers/authentication.dart';
import '../../providers/offers.dart';
import '../../providers/user_data.dart';

class MyPendingDetailScreen extends StatefulWidget {
  const MyPendingDetailScreen({super.key});

  final routeName = '/mypendingdetail';

  @override
  State<MyPendingDetailScreen> createState() => _MyPendingDetailScreenState();
}

class _MyPendingDetailScreenState extends State<MyPendingDetailScreen> {
  var isLoading = false;
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var offer = ModalRoute.of(context)!.settings.arguments as Offer;
    var user = context.read<Authentication>().currentUser!;
    var offers = context.read<Offers>();
    var userData = context.read<UserData>();
    var isFirstUser = offer.firstUser.userId == user.uid;
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
                          offer.secondUser.userId == user.uid
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
                      offer.secondUser.userId == user.uid
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
                      offer.secondUser.userId == user.uid
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
                          offer.secondUser.userId == user.uid
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
                            child: offer.secondUser.userId == user.uid
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
                            child: offer.secondUser.userId == user.uid
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
                                child: offer.secondUser.userId == user.uid
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
        child: offer.status == 'pending'
            ? isFirstUser && offer.firstUserAccepted == true ||
                    !isFirstUser && offer.secondUserAccepted == true
                ? GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                      ),
                      height: 60,
                      child: Text(
                        'ยืนยันรายการแล้ว',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                    onTap: (() {
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
                              'ยกเลิกรายการ',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                          onTap: (() async {
                            var updateOfferStatus = await db
                                .collection('offers')
                                .doc(offer.id)
                                .update({
                              'status': 'offer',
                            });

                            //change item status
                            await db
                                .collection('items')
                                .doc(offer.firstOfferItem.id)
                                .update({'status': 'on'});

                            //change item isDone
                            await db
                                .collection('items')
                                .doc(offer.firstOfferItem.id)
                                .update({'isDone': 'false'});
                            print(
                                'Item${offer.firstOfferItem.id} isDone => false');

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
                              'ยืนยันรายการ',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                          onTap: (() async {
                            setState(() {
                              isLoading = true;
                            });
                            print(offer.id);

                            print(isFirstUser);

                            isFirstUser
                                ? await db
                                    .collection('offers')
                                    .doc(offer.id)
                                    .update({'firstUserAccepted': true})
                                : await db
                                    .collection('offers')
                                    .doc(offer.id)
                                    .update({'secondUserAccepted': true});

                            //get this offer
                            var offerFromFirestore = await db
                                .collection('offers')
                                .doc(offer.id)
                                .get();
                            var offerDataFromFirestore =
                                offerFromFirestore.data()!;
                            if (offerDataFromFirestore['firstUserAccepted'] ==
                                    true &&
                                offerDataFromFirestore['secondUserAccepted'] ==
                                    true) {
                              print('All user accept this offer');

                              await db
                                  .collection('offers')
                                  .doc(offer.id)
                                  .update({
                                'status': 'pendingdone',
                              });
                              print(
                                  'Offer(${offer.id}) status => pendingdone!');

                              //update other offers status and items from this item
                              var otherOffer = await db
                                  .collection('offers')
                                  .where('firstOfferItemId',
                                      isEqualTo: offer.firstOfferItem.id)
                                  .where('secondOfferItemId',
                                      isNotEqualTo: offer.secondOfferItem.id)
                                  .get();
                              for (var iOffer in otherOffer.docs) {
                                //change all other rejected offer status
                                await db
                                    .collection('offers')
                                    .doc(iOffer.id)
                                    .update({'status': 'rejecteddone'});
                                print(
                                    'Offer(${iOffer.id}) status => rejecteddone!');
                              }

                              if (offer.firstOfferItem.itemType == 'แลก') {
                                //if trade offer
                                var fristUserDoc = await db
                                    .collection('users')
                                    .doc(offer.firstUser.userId)
                                    .get();
                                var fristUserData = fristUserDoc.data();
                                await db
                                    .collection('users')
                                    .doc(offer.firstUser.userId)
                                    .update({
                                  'tradeCount': fristUserData!['tradeCount'] + 1
                                });
                                print('Update first user traeCount');

                                var secondUserDoc = await db
                                    .collection('users')
                                    .doc(offer.secondUser.userId)
                                    .get();
                                var secondUserData = secondUserDoc.data();
                                await db
                                    .collection('users')
                                    .doc(offer.secondUser.userId)
                                    .update({
                                  'tradeCount':
                                      secondUserData!['tradeCount'] + 1
                                });
                                print('Update second user traeCount');
                              } else {
                                //if donate offer
                                var fristUserDoc = await db
                                    .collection('users')
                                    .doc(offer.firstUser.userId)
                                    .get();
                                var fristUserData = fristUserDoc.data();
                                await db
                                    .collection('users')
                                    .doc(offer.firstUser.userId)
                                    .update({
                                  'donateCount':
                                      fristUserData!['donateCount'] + 1
                                });
                                print('Update first user donateCount');
                              }
                            }
                            isLoading = false;
                            await offers.fetchMyOffersData();
                            await userData.fetchUserData(user.uid);
                            offers.notify();
                            if (!mounted) return;
                            Navigator.pop(context);
                            //change offer status
                            // var updateOfferStatus =
                            //     await db.collection('offers').doc(offer.id).update({
                            //   'status': 'pendingdone',
                            // });
                            // print('Offer(${offer.id}) status => pendingdone!');

                            // //update other offers status and items from this item
                            // var otherOffer = await db
                            //     .collection('offers')
                            //     .where('firstOfferItemId',
                            //         isEqualTo: offer.firstOfferItem.id)
                            //     .where('secondOfferItemId',
                            //         isNotEqualTo: offer.secondOfferItem.id)
                            //     .get();
                            // for (var iOffer in otherOffer.docs) {
                            //   await db
                            //       .collection('offers')
                            //       .doc(iOffer.id)
                            //       .update({'status': 'rejecteddone'});
                            //   print('Offer(${iOffer.id}) status => rejecteddone!');
                            // }

                            // //change item status
                            // // await db
                            // //     .collection('items')
                            // //     .doc(offer.firstOfferItem.id)
                            // //     .update({'status': 'off'});
                            // // print('Item${offer.firstOfferItem.id} status => off');

                            // //update user donate/trade count
                            // var responseOffer =
                            //     await db.collection('offers').doc(offer.id).get();
                            // var responseOfferData = responseOffer.data();
                            // if (responseOfferData!['status'] == 'pendingdone') {
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
                          }),
                        ),
                      ),
                    ],
                  )
            : null,
      ),
    );
  }
}
