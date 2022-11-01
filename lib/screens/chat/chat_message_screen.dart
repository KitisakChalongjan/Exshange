import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/models/message.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:exshange/providers/messages.dart';
import 'package:exshange/providers/user_data.dart';
import 'package:exshange/screens/home/item_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
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

  void sendMessage(
    BuildContext ctx,
    String myId,
    String userId,
    String profileUrl,
    String content,
  ) async {
    FocusScope.of(ctx).unfocus();
    await Messages.uploadMessage(myId, userId, profileUrl, content);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream:
                      Messages.getMessage(currentUser.uid, userChatArg.userId),
                  builder: ((context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text(
                        'ไม่มีรายการแชท',
                        style: Theme.of(context).textTheme.bodyText1,
                      );
                    } else {
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        reverse: true,
                        itemBuilder: ((context, index) {
                          var message = snapshot.data!.docs[index].data();
                          return ListTile(
                            hoverColor: Theme.of(context).primaryColor,
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey,
                            ),
                            title: Text(
                              message['content'],
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          );
                        }),
                      );
                    }
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
                    onTap: (() {
                      if (_messageController.text.trim().isEmpty) {
                        print('error');
                        return;
                      } else {
                        sendMessage(
                          context,
                          currentUser.uid,
                          userChatArg.userId,
                          myData.profileImageUrl,
                          _messageController.text,
                        );
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
        ),
      ),
    );
  }
}
