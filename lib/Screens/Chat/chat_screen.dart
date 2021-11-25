import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flats/Services/database_service.dart';
import 'package:flats/Utils/get_chatroom_id_function.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';



class ChatScreen extends StatefulWidget {
  final String email;
  final String myEmail;
  ChatScreen(this.email, this.myEmail);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  String chatRoomId="";
  String messageId = "";
  Stream? messageStream;
  String? myName, myUserName;
  //String myProfilePic="https://firebasestorage.googleapis.com/v0/b/testappproject-329013.appspot.com/o/images%2Faccountpic.png?alt=media&token=94d81c05-78f6-46ff-a000-491cffdd6107";
  TextEditingController messageTextEditingController = TextEditingController();


  addMessage() {
    if (messageTextEditingController.text != "") {
      String message = messageTextEditingController.text;

      var lastMessageTs = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": widget.myEmail,
        "ts": lastMessageTs,
        //"imgUrl": myProfilePic
      };

      //messageId
      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }

      DatabaseService()
          .addMessage(chatRoomId, messageId, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": widget.myEmail
        };

        DatabaseService().updateLastMessageSend(chatRoomId, lastMessageInfoMap);


        // remove the text in the message input field
        messageTextEditingController.text = "";
        // make message id blank to get regenerated on next message send
        messageId = "";

      });
    }
  }

  Widget chatMessageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
      sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(24),
                  bottomRight:
                  sendByMe ? const Radius.circular(0) : Radius.circular(24),
                  topRight: const Radius.circular(24),
                  bottomLeft:
                  sendByMe ? const Radius.circular(24) : Radius.circular(0),
                ),
                color: sendByMe ? Colors.blue : Colors.grey,
              ),
              padding: const EdgeInsets.all(16),
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            padding: const EdgeInsets.only(bottom: 70, top: 16),
            itemCount: snapshot.data.docs.length,
            reverse: true,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              return chatMessageTile(
                  ds["message"], widget.myEmail == ds["sendBy"]);
            })
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  getAndSetMessages() async {
    messageStream = await DatabaseService().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  doThisOnLaunch() async {

    chatRoomId = getChatRoomIdByUsernames(widget.email, widget.myEmail);
    getAndSetMessages();
  }

  @override
  void initState() {
    doThisOnLaunch();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.email),
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black.withOpacity(0.8),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageTextEditingController,

                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "type a message",
                              hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.6))),
                        )),
                    GestureDetector(
                      onTap: () {
                        addMessage();
                      },
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}