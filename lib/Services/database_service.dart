import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  Future<Stream<QuerySnapshot>> getUserByEmail(String email) async {
    return FirebaseFirestore.instance
        .collection("User")
        .where("email", isGreaterThanOrEqualTo: email)
        .where("email", isLessThan: email + 'z')
        .snapshots();
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

}




