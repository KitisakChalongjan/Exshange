import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Message {
  String senderProfileUrl;
  String chatId;
  String content;
  String senderId;
  Timestamp messageTimeStamp;

  Message({
    required this.senderProfileUrl,
    required this.chatId,
    required this.content,
    required this.senderId,
    required this.messageTimeStamp,
  });

  Message copyWith({
    String? senderProfileUrl,
    String? chatId,
    String? content,
    String? senderId,
    Timestamp? messageTimeStamp,
  }) {
    return Message(
      senderProfileUrl: senderProfileUrl ?? this.senderProfileUrl,
      chatId: chatId ?? this.chatId,
      content: content ?? this.content,
      senderId: senderId ?? this.senderId,
      messageTimeStamp: messageTimeStamp ?? this.messageTimeStamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderProfileUrl': senderProfileUrl,
      'chatId': chatId,
      'content': content,
      'senderId': senderId,
      'messageTimeStamp': Timestamp.now(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderProfileUrl: map['senderProfileUrl'] as String,
      chatId: map['chatId'] as String,
      content: map['content'] as String,
      senderId: map['senderId'] as String,
      messageTimeStamp: map['messageTimeStamp'] as Timestamp ,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Message(senderProfileUrl: $senderProfileUrl, chatId: $chatId, content: $content, senderId: $senderId, messageTimeStamp: $messageTimeStamp)';
  }

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;

    return other.senderProfileUrl == senderProfileUrl &&
        other.chatId == chatId &&
        other.content == content &&
        other.senderId == senderId &&
        other.messageTimeStamp == messageTimeStamp;
  }

  @override
  int get hashCode {
    return senderProfileUrl.hashCode ^
        chatId.hashCode ^
        content.hashCode ^
        senderId.hashCode ^
        messageTimeStamp.hashCode;
  }
}
