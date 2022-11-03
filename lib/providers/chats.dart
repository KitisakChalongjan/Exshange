import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Chats {
  static Future<List<Map<dynamic, dynamic>>> getChats(String myId) async {
    print('startGetChats1');
    var db = FirebaseFirestore.instance;
    var myChat =
        await db.collection('chats').where('member', arrayContains: myId).get();
    List<Map<dynamic, dynamic>> chatsMap = [];
    for (var chat in myChat.docs) {
      print('startGetChats2');
      List<dynamic> chatUserMember = chat.data()['member'];
      String chatUserId = chatUserMember.firstWhere((member) => member != myId);
      print('startGetChats3');
      var chatUserData = await db.collection('users').doc(chatUserId).get();
      var chatTemp = {
        'chatId': chat.id,
        'chatUserId' : chatUserId,
        'chatUserName': chatUserData.data()!['name'],
        'chatUserImageUrl': chatUserData.data()!['profileImageUrl'],
      };
      chatsMap.add(chatTemp);
      print('startGetChats4');
      print(chatsMap);
    }
    return chatsMap;
  }
}
