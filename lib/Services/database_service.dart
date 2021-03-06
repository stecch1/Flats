import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  Future<Stream<QuerySnapshot>> getUserByEmail(String email) async {
    return FirebaseFirestore.instance
        .collection("User")
        .where("email", isGreaterThanOrEqualTo: email)
        .where("email", isLessThan: email + 'z')
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserDocumentByEmail(String email) async {

    return await FirebaseFirestore.instance.collection('User')
        .where('email', isEqualTo: email)
        .get();
  }

  createChatRoom(String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .get();

    if (snapShot.exists) {
      // chatroom already exists
      return true;
    } else {
      // chatroom does not exists
      return FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }


  Future<Stream<QuerySnapshot>> getChatRooms( String myEmail) async {

    return FirebaseFirestore.instance
        .collection("ChatRoom")
        //.orderBy("lastMessageSendTs", descending: true)
        .where("emails", arrayContains: myEmail)
        .snapshots();
  }
  Future addMessage(
      String chatRoomId, String messageId, Map<String, dynamic> messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }
  updateLastMessageSend(String chatRoomId, Map<String, dynamic> lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }




}




