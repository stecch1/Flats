import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flats/Screens/Chat/chat_screen.dart';
import 'package:flats/Screens/Chat/chatroom_list_tile.dart';
import 'package:flats/Services/database_service.dart';
import 'package:flats/Utils/get_chatroom_id_function.dart';
import 'package:flutter/material.dart';


class ChatHomeScreen extends StatefulWidget {

  ChatHomeScreen(this.myEmail,{Key? key}) : super(key: key);

  String myEmail;

  @override
  _ChatHomeScreenState createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  bool isSearching = false;

  Stream? usersStream, chatRoomsStream;

  TextEditingController searchUsernameEditingController =
  TextEditingController();



  onSearchBtnClick() async {
    isSearching = true;
    setState(() {});
    usersStream = await DatabaseService()
        .getUserByEmail(searchUsernameEditingController.text);

    setState(() {});
  }

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, AsyncSnapshot snapshot) {
        return (snapshot.hasData && snapshot.connectionState == ConnectionState.active)
            ? ListView.builder(
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];

              return ChatRoomListTile(ds["lastMessage"], ds.id, widget.myEmail);
            })
            : Center(child: Container());
      },
    );
  }

  Widget searchListUserTile({email}) {
    return GestureDetector(
      onTap: () {
        var chatRoomId = getChatRoomIdByUsernames(widget.myEmail, email);
        Map<String, dynamic> chatRoomInfoMap = {
          "emails": [widget.myEmail, email],
          "lastMessage": " ",
        };
        DatabaseService().createChatRoom(chatRoomId, chatRoomInfoMap);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(email, widget.myEmail)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                "https://firebasestorage.googleapis.com/v0/b/testappproject-329013.appspot.com/o/images%2Faccountpic.png?alt=media&token=94d81c05-78f6-46ff-a000-491cffdd6107",
                height: 40,
                width: 40,
              ),
            ),
            const SizedBox(width: 12),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(email)])
          ],
        ),
      ),
    );
  }

  Widget searchUsersList() {
    return StreamBuilder(
      stream: usersStream,
      builder: (context, AsyncSnapshot snapshot) {
        return (snapshot.connectionState == ConnectionState.active && snapshot.hasData)
            ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return searchListUserTile(

                email: ds["email"],

            );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  getChatRooms() async {
    chatRoomsStream = await DatabaseService().getChatRooms(widget.myEmail);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getChatRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            Row(
              children: [
                isSearching
                    ? GestureDetector(
                  onTap: () {
                    isSearching = false;
                    searchUsernameEditingController.text = "";
                    setState(() {});
                  },
                  child: const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(Icons.arrow_back)),
                )
                    : Container(),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey,
                            width: 1,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                              controller: searchUsernameEditingController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none, hintText: "username"),
                            )),
                        GestureDetector(
                            onTap: () {
                              if (searchUsernameEditingController.text != "") {
                                onSearchBtnClick();
                              }
                            },
                            child: const Icon(Icons.search))
                      ],
                    ),
                  ),
                ),
              ],
            ),
            isSearching ? searchUsersList() : chatRoomsList()
          ],
        ),
      ),
    );
  }
}

