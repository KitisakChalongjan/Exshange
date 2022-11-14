import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/models/offer.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:exshange/providers/offers.dart';
import 'package:exshange/screens/chat/chat_message_screen.dart';
import 'package:exshange/screens/home/item_detail_screen.dart';
import 'package:exshange/screens/home_screen.dart';
import 'package:exshange/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';

class MyHistoryDetailScreen extends StatefulWidget {
  const MyHistoryDetailScreen({Key? key}) : super(key: key);
  final routeName = '/myhistorydetail';

  @override
  State<MyHistoryDetailScreen> createState() => _MyHistoryDetailScreenState();
}

class _MyHistoryDetailScreenState extends State<MyHistoryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    var offer = ModalRoute.of(context)!.settings.arguments as Offer;
    var user = context.read<Authentication>().currentUser!;
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('รายละเอียดการทำรายการ'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  offer.firstUser.userId == user.uid
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
                      offer.firstUser.userId == user.uid
                          ? offer.firstOfferItem.imagesUrl[0]
                          : offer.secondOfferItem.imagesUrl[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  offer.firstUser.userId == user.uid
                      ? offer.firstOfferItem.name
                      : offer.secondOfferItem.name,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Icon(
                    Icons.loop_sharp,
                    color: Theme.of(context).primaryColor,
                    size: 60,
                  ),
                ),
                Text(
                  offer.firstUser.userId == user.uid
                      ? offer.secondUser.name
                      : offer.firstUser.name,
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
                      offer.firstUser.userId == user.uid
                          ? offer.secondOfferItem.imagesUrl[0]
                          : offer.firstOfferItem.imagesUrl[0],
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
                        child: offer.firstUser.userId == user.uid
                            ? Text(
                                offer.secondOfferItem.name,
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            : Text(
                                offer.firstOfferItem.name,
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
                        child: offer.firstUser.userId == user.uid
                            ? Text(
                                offer.secondOfferItem.detail,
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            : Text(
                                offer.firstOfferItem.detail,
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
                            child: offer.firstUser.userId == user.uid
                                ? Text(
                                    offer.secondOfferItem.address,
                                    style: Theme.of(context).textTheme.caption,
                                  )
                                : Text(
                                    offer.firstOfferItem.address,
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
                                  backgroundImage: NetworkImage(
                                    offer.firstUser.userId == user.uid
                                        ? offer.secondUser.profileImageUrl
                                        : offer.firstUser.profileImageUrl,
                                  ),
                                ),
                                Text(
                                  offer.firstUser.userId == user.uid
                                      ? offer.secondUser.name
                                      : offer.firstUser.name,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: (() {
                                Navigator.pushNamed(
                                  context,
                                  ChatMessageScreen().routeName,
                                  arguments: offer.firstUser.userId == user.uid
                                      ? UserChatArg(
                                          userId: offer.secondUser.userId,
                                          userName: offer.secondUser.name,
                                          userImageUrl:
                                              offer.secondUser.profileImageUrl,
                                        )
                                      : UserChatArg(
                                          userId: offer.firstUser.userId,
                                          userName: offer.firstUser.name,
                                          userImageUrl:
                                              offer.firstUser.profileImageUrl,
                                        ),
                                );
                              }),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                padding: EdgeInsets.all(5),
                                child: Icon(
                                  size: 30,
                                  color: Theme.of(context).hintColor,
                                  Icons.chat_bubble,
                                ),
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
        bottomNavigationBar: offer.firstOfferItem.itemType == 'ให้' &&
                offer.firstUser.userId == user.uid
            ? null
            : BottomAppBar(
                child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: offer.status == 'accepted'
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).hintColor,
                    ),
                    height: 60,
                    child: Center(
                      child: Text(
                        offer.status == 'accepted'
                            ? 'ให้คะแนน'
                            : 'ให้คะแนนแล้ว',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ),
                  onTap: (() {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return Rating(offer: offer);
                      },
                    );
                  }),
                ),
              ));
  }
}

class Rating extends StatefulWidget {
  final Offer offer;
  const Rating({required this.offer, Key? key}) : super(key: key);

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  double _stars = 0.0;
  FirebaseFirestore db = FirebaseFirestore.instance;
  Widget _buildStar(double starCount) {
    return InkWell(
      child: Icon(
        Icons.star,
        size: 32.0,
        color: _stars >= starCount
            ? Color.fromARGB(255, 230, 186, 8)
            : Colors.grey,
      ),
      onTap: () {
        setState(() {
          _stars = starCount;
        });
        print('${_stars}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var offers = context.read<Offers>();
    var user = context.read<Authentication>().currentUser!;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 200,
        horizontal: 60,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).hintColor,
                  width: 1.0,
                ),
              ),
            ),
            child: Material(
              color: Colors.white,
              child: Center(
                child: Text(
                  'ให้คะแนน',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 200,
            child: widget.offer.firstUser.userId == user.uid
                ? Image.network(
                    widget.offer.secondOfferItem.imagesUrl[0],
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    widget.offer.firstOfferItem.imagesUrl[0],
                    fit: BoxFit.cover,
                  ),
          ),
          SizedBox(
            height: 10,
          ),
          Material(
            color: Colors.white,
            child: widget.offer.firstUser.userId == user.uid
                ? Text(
                    widget.offer.secondOfferItem.name,
                    style: Theme.of(context).textTheme.subtitle2,
                  )
                : Text(
                    widget.offer.firstOfferItem.name,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
          ),
          SizedBox(
            height: 4,
          ),
          Material(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  size: 20,
                ),
                widget.offer.firstUser.userId == user.uid
                    ? Text(
                        widget.offer.secondUser.name,
                        style: Theme.of(context).textTheme.subtitle2,
                      )
                    : Text(
                        widget.offer.firstUser.name,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Material(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStar(1),
                  _buildStar(2),
                  _buildStar(3),
                  _buildStar(4),
                  _buildStar(5),
                ],
              ),
            ),
          ),
          Expanded(child: SizedBox()),
          GestureDetector(
            child: Container(
              height: 40,
              width: double.infinity,
              child: Material(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
                color: Colors.white,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).hintColor,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'ให้คะแนน',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            onTap: (() async {
              DocumentSnapshot<Map<String, dynamic>> userDoc;
              String userIdRef;
              double newRating;
              if (widget.offer.firstUser.userId == user.uid) {
                userIdRef = widget.offer.secondUser.userId;
              } else {
                userIdRef = widget.offer.firstUser.userId;
              }
              userDoc = await db.collection('users').doc(userIdRef).get();
              var userDataMap = userDoc.data()!;
              var oldRating = userDataMap['rating'];
              if (oldRating == 0) {
                newRating = _stars;
              } else {
                newRating = (_stars + oldRating) / 2;
              }
              newRating = double.parse(newRating.toStringAsFixed(2));
              await db
                  .collection('users')
                  .doc(userIdRef)
                  .update({'rating': newRating});
              await db
                  .collection('offers')
                  .doc(widget.offer.id)
                  .update({'status': 'done'});
              print('Rating Updated!');
              offers.fetchMyOffersData();
              offers.notify();
              Navigator.of(context).pushNamedAndRemoveUntil(
                HomeScreen().routeName,
                (route) => false,
              );
            }),
          )
          // Column(
          //   children: [
          //     Text('data'),
          //     Text('data'),
          //     Text('data'),
          //   ],
          // )
        ],
      ),
    );
  }
}
