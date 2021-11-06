import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flats/Screens/Chat/search_list_usr_tile.dart';
import 'package:flats/Services/database_service.dart';
import 'package:flutter/material.dart';

class ChatHome extends StatefulWidget {
  const ChatHome({Key? key}) : super(key: key);

  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {

  bool isSearching = false;
  TextEditingController searchUsernameEditingController =
  TextEditingController();
  late Stream usersStream;

  onSearchBtnClick() async {
    isSearching = true;
    setState(() {});
    usersStream = await DatabaseService()
        .getUserByUserName(searchUsernameEditingController.text);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
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
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                  border: InputBorder.none,
                                  hintText: "username"),
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
            isSearching ? searchUsersList() : Container()
          ],
        ),
      ),
    );
  }
  Widget searchUsersList() {
    return StreamBuilder(
      stream: usersStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
                  return searchListUserTile(
                      email: ds["email"], username: ds["username"]);
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
