import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/models/message.dart';
import 'package:exshange/models/user.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:exshange/providers/messages.dart';
import 'package:exshange/providers/user_data.dart';
import 'package:exshange/screens/chat/chat_user_info.dart';
import 'package:exshange/screens/home/item_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatMessageScreen extends StatefulWidget {
  const ChatMessageScreen({Key? key}) : super(key: key);
  final routeName = '/chatmessage';

  @override
  State<ChatMessageScreen> createState() => _ChatMessageScreenState();
}

class _ChatMessageScreenState extends State<ChatMessageScreen> {
  var _messageController = TextEditingController();
  var message;

  // Future<void> sendMessage(
  //   BuildContext ctx,
  //   String myId,
  //   String userId,
  //   String profileUrl,
  //   String content,
  // ) async {
  //   FocusScope.of(ctx).unfocus();
  //   await Messages.uploadMessage(myId, userId, profileUrl, content);
  //   _messageController.clear();
  // }

  @override
  Widget build(BuildContext context) {
    print('buildChatMessage');
    UserChatArg userChatArg =
        ModalRoute.of(context)!.settings.arguments as UserChatArg;
    var currentUser = context.read<Authentication>().currentUser!;
    var myData = context.read<UserData>().userModel!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          userChatArg.userName,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundImage: NetworkImage(userChatArg.userImageUrl),
              radius: 42,
            ),
            onPressed: () {
              print('User Info');
              Navigator.pushNamed(context, ChatUserInfo().routeName,
                  arguments: userChatArg);
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
          future: context
              .read<Messages>()
              .fetchMessage(currentUser.uid, userChatArg.userId),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return MessageBodyWidget(
                currentUser: currentUser,
                userChatArg: userChatArg,
                messageController: _messageController,
                myData: myData,
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          })),
    );
  }
}

class MessageBodyWidget extends StatelessWidget {
  const MessageBodyWidget({
    Key? key,
    required this.currentUser,
    required this.userChatArg,
    required TextEditingController messageController,
    required this.myData,
  })  : _messageController = messageController,
        super(key: key);

  final User currentUser;
  final UserChatArg userChatArg;
  final TextEditingController _messageController;
  final UserModel myData;

  @override
  Widget build(BuildContext context) {
    //var messages = context.watch<Messages>().messages;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: context
          .read<Messages>()
          .getMessage(currentUser.uid, userChatArg.userId),
      builder: ((context, snapshot) {
        var messagesMap;
        var messagesList;

        messagesMap = snapshot.data;
        if (messagesMap == null) {
          messagesList = context.read<Messages>().messages;
        } else {
          messagesList = messagesMap.docs
              .map(
                (message) => Message.fromMap(
                  message.data(),
                ),
              )
              .toList();
        }
        return Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: messagesList.length,
                  reverse: true,
                  itemBuilder: ((context, index) {
                    print('build message');
                    var message = messagesList[index];
                    print(message);
                    var isMe = message.senderId == currentUser.uid;
                    var timestamp = message.messageTimeStamp as Timestamp;
                    var datetime = timestamp.toDate();
                    var dt = DateFormat('d MMM, HH:mm').format(datetime);
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: isMe
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            isMe
                                ? SizedBox()
                                : CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                      message.senderProfileUrl,
                                    ),
                                  ),
                            isMe
                                ? SizedBox(
                                    width: 0,
                                  )
                                : SizedBox(
                                    width: 10,
                                  ),
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorLight,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                  bottomLeft: Radius.circular(isMe ? 16 : 0),
                                  bottomRight: Radius.circular(isMe ? 0 : 16),
                                ),
                              ),
                              padding: EdgeInsets.all(8),
                              child: Text(
                                message.content,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            isMe
                                ? SizedBox(
                                    width: 10,
                                  )
                                : SizedBox(
                                    width: 0,
                                  ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: isMe
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Text(
                              dt,
                              style: Theme.of(context).textTheme.caption,
                            ),
                            SizedBox(
                              width: isMe ? 10 : 50,
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            Container(
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: Theme.of(context).textTheme.subtitle2,
                      textCapitalization: TextCapitalization.sentences,
                      autocorrect: true,
                      enableSuggestions: true,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'ข้อความของคุณ...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 0),
                          gapPadding: 10,
                        ),
                      ),
                      // onChanged: (value) => setState(() {
                      //   message = value;
                      // }),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: (() async {
                      if (_messageController.text.trim().isEmpty) {
                        print('no content');
                        return;
                      } else {
                        FocusScope.of(context).unfocus();
                        await context.read<Messages>().uploadMessage(
                              currentUser.uid,
                              userChatArg.userId,
                              myData.profileImageUrl,
                              _messageController.text,
                            );
                        _messageController.clear();
                      }
                    }),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.send,
                        size: 24,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
