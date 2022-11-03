import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:exshange/providers/chats.dart';
import 'package:exshange/screens/chat/chat_message_screen.dart';
import 'package:exshange/screens/home/item_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> chatUsers = [
    {
      'name': 'kitisak',
    },
    {
      'name': 'teerapat',
    },
    {
      'name': 'kasempan',
    },
  ];
  @override
  Widget build(BuildContext context) {
    var currentUser = context.read<Authentication>().currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Exshange'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<dynamic, dynamic>>>(
        future: Chats.getChats(currentUser.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          else
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: ((context, index) {
                var chatUser = snapshot.data![index];
                return Container(
                  height: 80,
                  alignment: Alignment.center,
                  child: ListTile(
                    hoverColor: Theme.of(context).primaryColor,
                    onTap: (() {
                      Navigator.pushNamed(
                        context,
                        ChatMessageScreen().routeName,
                        arguments: UserChatArg(
                          userId: chatUser['chatUserId'],
                          userName: chatUser['chatUserName'],
                          userImageUrl: chatUser['chatUserImageUrl'],
                        ),
                      );
                    }),
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          NetworkImage(chatUser['chatUserImageUrl']),
                    ),
                    title: Text(
                      chatUser['chatUserName'],
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                );
              }),
            );
        },
      ),
    );
  }
}
