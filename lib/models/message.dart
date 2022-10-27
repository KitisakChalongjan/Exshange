// ignore_for_file: public_member_api_docs, sort_constructors_first
class Message {
  String messageId;
  String chatId;
  String content;
  int messageTimeStamp;
  
  Message({
    required this.messageId,
    required this.chatId,
    required this.messageTimeStamp,
    required this.content,
  });
  
  get getMessageId => this.messageId;

 set setMessageId( messageId) => this.messageId = messageId;

  get getChatId => this.chatId;

 set setChatId( chatId) => this.chatId = chatId;

  get getMessageTimeStamp => this.messageTimeStamp;

 set setMessageTimeStamp( messageTimeStamp) => this.messageTimeStamp = messageTimeStamp;

  get getContent => this.content;

 set setContent( content) => this.content = content;

  @override
  String toString() {
    return 'Message(messageId: $messageId, chatId: $chatId, messageTimeStamp: $messageTimeStamp, content: $content)';
  }
}
