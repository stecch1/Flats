import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flats/Screens/Host/change_propic.dart';
import 'package:flats/Services/database_service.dart';
import 'package:flutter/material.dart';

class ProfilePic extends StatefulWidget {

  ProfilePic({Key? key, required this.email, required this.uid}) : super(key: key);

  String email, uid;
  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {


  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: DatabaseService().getUserDocumentByEmail(widget.email),
      builder: (BuildContext context,AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }else{
            return Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                    snapshot.data.docs[0]["pic_url"],
                    height: 100,
                    width: 100,
                  )
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: GestureDetector(
                    child: Text("change profile pic", style: TextStyle(color: Colors.lightBlue),),
                    onTap: () async {
                      await Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ChangeProPic(uid: widget.uid)));
                      setState((){});
                    },
                  ),
                ),
              ],
            );
          }
        }else if (snapshot.hasError){
          Text('no data');
        }
        return CircularProgressIndicator();
      },
    );
  }
}
