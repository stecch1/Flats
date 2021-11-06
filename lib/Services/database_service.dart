import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  Future<Stream<QuerySnapshot>> getUserByUserName(String username) async {
    return FirebaseFirestore.instance
        .collection("User")
        .where("username", isGreaterThanOrEqualTo: username)
        .where("username", isLessThan: username + 'z')
        .snapshots();
  }



}