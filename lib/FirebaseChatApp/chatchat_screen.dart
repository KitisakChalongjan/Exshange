import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class ChatChatScreen extends StatelessWidget {
  const ChatChatScreen({Key? key}) : super(key: key);
  final routeName = '/chatchat';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => Container(
          padding: EdgeInsets.all(8),
          child: Text('It is work!!'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/K6EEzdLCmkLJl6dRt4Xb/messages')
              .snapshots()
              .listen(
                (data) {
                  data.docs.forEach((msgElement) { 
                    print(msgElement['text']);
                  });
                },
              );
        },
      ),
    );
  }
}
