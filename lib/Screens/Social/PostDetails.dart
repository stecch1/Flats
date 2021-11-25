import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flats/Screens/Chat/chat_home.dart';
import 'package:flats/Screens/Chat/chat_screen.dart';
import 'package:flats/Screens/Social/flat_details.dart';
import 'package:flats/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'package:flats/Models/user_model.dart';



class PostDetails extends StatefulWidget {
  Map<String, dynamic> data;
  PostDetails(this.data,{ Key? key }) : super(key: key);


  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
      stream: authService.user,
      builder:(_, AsyncSnapshot<User?> snapshot){
        if(snapshot.connectionState == ConnectionState.active){
          final User? user = snapshot.data;
    return new Scaffold(

      appBar: new AppBar(
        title: new Text("Post Details"),
        backgroundColor: Colors.amber
      ),
      
      body: new Card(
        elevation: 10.0,
        margin: EdgeInsets.all(10.0),
        child: new ListView(
          children:<Widget>[
            new Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [Row(
                children: <Widget>[

                  new CircleAvatar(
                     child: new Text(
                      widget.data['title'][0]),
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black
                  ),

                  new SizedBox(width: 10.0,),

                  new Text(widget.data['title'],
                    style: TextStyle(fontSize: 22.0, )
                  ),
                ]
                ),
                new SizedBox(height: 7.0,),

                new Container(
                    margin:EdgeInsets.all(1.0),
                    child: Text(widget.data['content'],
                      style: TextStyle(fontSize: 18.0, ),
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.ellipsis,
                      )
                  ),

                new Container(
                    margin:EdgeInsets.all(1.0),
                    child: Text(widget.data['userMail'],
                      style: TextStyle(fontSize: 9.0, ),
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.ellipsis,
                      )
                  ),
                ElevatedButton(onPressed: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => flatDetails(widget.data['flatId'])));
          }, child: Text("See Flats")),

          ElevatedButton(onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChatScreen(widget.data['userMail'], user!.email!)));

          },child: Text("write a message")),


                ],
              ),
            )
          ],
        ),
        
      ));
        }else{
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      }
      );
  }
}