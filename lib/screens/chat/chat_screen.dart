import 'package:exshange/screens/chat/chat_message_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Exshange'),
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: chatUsers.length,
        itemBuilder: ((context, index) {
          var chatUser = chatUsers[index];
          return Container(
            height: 80,
            alignment: Alignment.center,
            child: ListTile(
              hoverColor: Theme.of(context).primaryColor,
              onTap: (() {
                Navigator.pushNamed(
                  context,
                  ChatMessageScreen().routeName,
                  arguments: chatUser['name'],
                );
              }),
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
              ),
              title: Text(
                chatUser['name'],
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          );
        }),
      ),
    );
  }
}
