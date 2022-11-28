import 'package:exshange/models/user.dart';
import 'package:exshange/providers/user_data.dart';
import 'package:exshange/screens/home/item_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatUserInfo extends StatefulWidget {
  const ChatUserInfo({super.key});
  final routeName = '/chatuserinfo';

  @override
  State<ChatUserInfo> createState() => _ChatUserInfoState();
}

class _ChatUserInfoState extends State<ChatUserInfo> {
  @override
  Widget build(BuildContext context) {
    UserChatArg userChatArg =
        ModalRoute.of(context)!.settings.arguments as UserChatArg;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('ข้อมูลผู้ใช้'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: context.read<UserData>().getUserFromId(userChatArg.userId),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            print('getUserData failed!');
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var userData = snapshot.data as UserModel;
            return Container(
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(20),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).backgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.75),
                          blurRadius: 5,
                          offset: Offset(3, 3),
                        )
                      ]),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          userData.profileImageUrl,
                        ),
                        radius: 100,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                userData.name,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.phone),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                userData.phone,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.loop_sharp,
                                    size: 26,
                                  ),
                                  Text(
                                    userData.tradeCount.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 24,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.handshake,
                                    size: 26,
                                  ),
                                  Text(
                                    userData.donateCount.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 24,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 26,
                                  ),
                                  Text(
                                    userData.rating.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
