import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/models/message.dart';
import 'package:exshange/providers/authentication.dart';

class Messages {
  static Future<void> uploadMessage(String myId, String otherUserId,
      String profileUrl, String content) async {
    var db = FirebaseFirestore.instance;
    String mychatId = '';
    await db
        .collection('chats')
        .where('member', arrayContains: myId)
        .get()
        .then((chats) async {
      chats.docs.forEach((chatQuery) async {
        var chatQueryData = chatQuery.data()['member'] as List;
        if (chatQueryData.contains(otherUserId)) {
          mychatId = chatQuery.id;
        } else {
          Map<String, dynamic> chat = {
            'member': [myId, otherUserId]
          };
          var a = await db.collection('chats').add(chat);
          var b = await a.get();
          mychatId = b.id;
        }
      });
    });

    var newMessage = Message(
      senderProfileUrl: profileUrl,
      chatId: mychatId,
      content: content,
      senderId: myId,
      messageTimeStamp: FieldValue.serverTimestamp(),
    );

    await db.collection('messages').add(newMessage.toMap());
    print('sendMessage(chatID = ${mychatId})');
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getMessage(
    String myId,
    String otherUserId,
  ) async {
    var db = FirebaseFirestore.instance;
    String chatId = '';
    print(myId);
    print(otherUserId);
    print('get chatId');
    try {
      await db
          .collection('chats')
          .where('member', arrayContains: myId)
          .get()
          .then((chats) {
        var chatResult = chats.docs.firstWhere((chatQuery) {
          var chat = chatQuery.data();
          var member = chat['member'] as List;
          return member.contains(otherUserId);
        });
        print(chatResult.id);
        chatId = chatResult.id;
      });
    } catch (e) {
      print(e);
    }
    print('get message');
    return db
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy('messageTimeStamp', descending: true)
        .get();
  }
}
