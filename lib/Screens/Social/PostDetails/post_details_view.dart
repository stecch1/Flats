import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flats/Models/user_model.dart';
import 'package:flats/Screens/Chat/chat_screen.dart';
import 'package:flats/Screens/Social/flat_details.dart';
import 'package:flats/Services/database_service.dart';
import 'package:flats/Utils/get_chatroom_id_function.dart';
import 'package:flutter/material.dart';

class PostDetailsView extends StatelessWidget {
  Map<String, dynamic> data;
  User? user;
  final String docId;

  PostDetailsView({Key? key, required this.data,required this.docId, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Post Details"),
          backgroundColor: Colors.amber,
          actions: <Widget>[

            data['uid'] == user!.uid ?
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: (
                ) {
                  //delete post
                  FirebaseFirestore.instance
                      .collection("Post")
                      .doc(docId)
                      .delete();
                  Navigator.pop(context, true);
                },
                child: Icon(
                  Icons.delete,
                  size: 26.0,
                ),
              ),
            )
            :
            Container(),

          ],
        ),
        body: Card(
          elevation: 10.0,
          margin: EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              Column(
                children: [
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        child: CircleAvatar(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black),
                      ),
                      Flexible(
                        child: Text(data['title'],
                            style: TextStyle(
                              fontSize: 22.0,
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.fromLTRB(15, 0, 0, 30),
                      child: Text(
                        data['userMail'],
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                      )),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: Text(
                      data['content'],
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          flatDetails(data['flatId'])));
                            },
                            child: const Text("See Flat")),
                        ElevatedButton(
                          onPressed: () {
                            var chatRoomId = getChatRoomIdByUsernames(
                                user!.email!, data['userMail']);
                            Map<String, dynamic> chatRoomInfoMap = {
                              "emails": [user!.email!, data['userMail']],
                              "lastMessage": " ",
                            };
                            if (user!.email! != data['userMail']) {
                              DatabaseService()
                                  .createChatRoom(chatRoomId, chatRoomInfoMap);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                          data['userMail'], user!.email!)));
                            } else {
                              print("you cannot chat with yourself");
                            }
                          },
                          child: Icon(Icons.message),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
