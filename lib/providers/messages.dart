import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/models/message.dart';
import 'package:exshange/providers/authentication.dart';

class Messages {
  static Future<void> uploadMessage(
      String myId, String userId, String profileUrl, String content) async {
    var db = FirebaseFirestore.instance;
    String mychatId = '';
    await db
        .collection('chats')
        .where('member', arrayContainsAny: [myId, userId])
        .get()
        .then((chats) async {
          if (chats.docs.isEmpty) {
            Map<String, dynamic> chat = {
              'member': [myId, userId]
            };
            var a = await db.collection('chats').add(chat);
            var b = await a.get();
            mychatId = b.id;
          } else {
            mychatId = chats.docs.first.id;
          }
        });

    var newMessage = Message(
      senderProfileUrl: profileUrl,
      chatId: mychatId,
      content: content,
      messageTimeStamp: DateTime.now().millisecondsSinceEpoch,
    );

    await db.collection('messages').add(newMessage.toMap());
    print('sendMessage(chatID = ${mychatId})');
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessage(
    String myId,
    String otherUserId,
  ) async* {
    var db = FirebaseFirestore.instance;
    String chatId = '';
    await db
        .collection('chats')
        .where('member', arrayContainsAny: [myId, otherUserId])
        .get()
        .then((chats) {
          if (chats.docs.first.exists) {
            chatId = chats.docs.first.id;
          }
        });
    print(chatId);
    yield* db
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .snapshots();
  }
}
