import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exshange/models/message.dart';
import 'package:exshange/providers/authentication.dart';
import 'package:flutter/material.dart';

class Messages with ChangeNotifier {
  List<Message> _messages = [];
  List<Message> get messages => _messages;

  Future<void> uploadMessage(
    String myId,
    String otherUserId,
    String profileUrl,
    String content,
  ) async {
    var db = FirebaseFirestore.instance;
    String mychatId = '';
    try {
      await db
          .collection('chats')
          .where('member', arrayContains: myId)
          .get()
          .then((chats) async {
        if (chats.docs.isNotEmpty) {
          chats.docs.forEach((chatQuery) async {
            var chatQueryData = chatQuery.data()['member'] as List;
            if (chatQueryData.contains(otherUserId)) {
              mychatId = chatQuery.id;
            }
          });
        } else {
          Map<String, dynamic> chat = {
            'member': [myId, otherUserId]
          };
          var a = await db.collection('chats').add(chat);
          var b = await a.get();
          mychatId = b.id;
        }
      });
    } catch (e) {
      print(e);
    }

    var newMessage = Message(
      senderProfileUrl: profileUrl,
      chatId: mychatId,
      content: content,
      senderId: myId,
      messageTimeStamp: Timestamp.now(),
    );

    await db.collection('messages').add(newMessage.toMap()).then((value) {
      print('sendMessage(chatID = ${mychatId})');
      _messages.insert(0, newMessage);
    });
  }

  Future<void> fetchMessage(
    String myId,
    String otherUserId,
  ) async {
    var db = FirebaseFirestore.instance;
    String chatId = '';
    _messages = [];
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
    print('fetch message');
    var messagesLoad = await db
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy('messageTimeStamp', descending: true)
        .get();
    try {
      messagesLoad.docs.forEach((message) {
        print(message.data()['content']);
        var newMessage = Message.fromMap(message.data());
        print(newMessage);
        _messages.add(newMessage);
      });
    } catch (e) {
      print(e);
    }
    // return db
    //     .collection('messages')
    //     .where('chatId', isEqualTo: chatId)
    //     .orderBy('messageTimeStamp', descending: true)
    //     .get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessage(
    String myId,
    String otherUserId,
  ) async* {
    var db = FirebaseFirestore.instance;
    String chatId = '';
    _messages = [];
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
    
    yield* db
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy('messageTimeStamp', descending: true)
        .snapshots();
  }
}
