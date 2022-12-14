import 'package:exshange/providers/authentication.dart';
import 'package:exshange/providers/user_data.dart';
import 'package:exshange/screens/profile/edit_profile_screen.dart';
import 'package:exshange/screens/profile/my_address_screen.dart';
import 'package:exshange/screens/profile/my_category.dart';
import 'package:exshange/screens/profile/my_deal_screen.dart';
import 'package:exshange/screens/profile/my_history_screen.dart';
import 'package:exshange/screens/profile/my_item_screen.dart';
import 'package:exshange/screens/profile/my_pending_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  final routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    var userData = context.watch<UserData>().userModel;
    if (userData == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    var userProfileUrl = userData.profileImageUrl;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text('โปรไฟล์'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150,
              color: Theme.of(context).primaryColorDark,
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: userProfileUrl == '' ||
                                userProfileUrl == null
                            ? NetworkImage(
                                'https://firebasestorage.googleapis.com/v0/b/exshange-project.appspot.com/o/images%2Fperson-icon.png?alt=media&token=b4f91dd9-770b-4383-9498-d55ef8903b8d')
                            : NetworkImage(userProfileUrl) as ImageProvider,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ชื่อ : ${userData.name}',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Text(
                            'อีเมล์ : ${userData.email}',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Text(
                            'เบอร์ : ${userData.phone}',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Wrap(
                                    spacing: 5,
                                    children: [
                                      Icon(
                                        Icons.loop_sharp,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        '${userData.tradeCount}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Wrap(
                                    spacing: 5,
                                    children: [
                                      Icon(
                                        Icons.handshake,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        '${userData.donateCount}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Wrap(
                                    spacing: 5,
                                    children: [
                                      Icon(
                                        Icons.star_purple500_outlined,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        '${userData.rating}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: (() {
                Navigator.of(context).pushNamed(MyItemsScreen().routeName);
              }),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(1, 3),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('รายการของฉัน',
                          style: Theme.of(context).textTheme.subtitle2),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (() {
                Navigator.of(context).pushNamed(MyDealScreen().routeName);
              }),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(1, 3),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ข้อเสนอ',
                          style: Theme.of(context).textTheme.subtitle2),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (() {
                Navigator.of(context).pushNamed(MyPendingScreen().routeName);
              }),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(1, 3),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ข้อเสนอที่ได้รับการยืนยัน',
                          style: Theme.of(context).textTheme.subtitle2),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (() {
                Navigator.of(context).pushNamed(MyHistoryScreen().routeName);
              }),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(1, 3),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ประวัติทำรายการ',
                          style: Theme.of(context).textTheme.subtitle2),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (() {
                Navigator.of(context).pushNamed(MyCategoriesScreen().routeName);
              }),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(1, 3),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('หมวดหมู่ที่สนใจ',
                          style: Theme.of(context).textTheme.subtitle2),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (() {
                Navigator.of(context).pushNamed(EditProfileScreen().routeName,
                    arguments: userData);
              }),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(1, 3),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('แก้ไขข้อมูลโปรไฟล์',
                          style: Theme.of(context).textTheme.subtitle2),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (() {
                Navigator.of(context).pushNamed(MyAddressScreen().routeName);
              }),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(1, 3),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ที่อยู่',
                          style: Theme.of(context).textTheme.subtitle2),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (() {
                context.read<Authentication>().signOut();
              }),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(1, 3),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ออกจากระบบ',
                        style: TextStyle(color: Colors.red[600], fontSize: 16),
                      ),
                      Icon(Icons.arrow_forward, color: Colors.red[600]),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
