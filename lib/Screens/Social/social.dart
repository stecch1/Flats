import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'post_details.dart';


class SocialScreen extends StatefulWidget {
  const SocialScreen({Key? key}) : super(key: key);

  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  
  final Stream<QuerySnapshot> _postStream = FirebaseFirestore.instance.collection('Post').snapshots();


  passData(Map<String, dynamic> data){
    Navigator.of(this.context).push(new MaterialPageRoute(builder: (context)=>PostDetails(data)));
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _postStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        
    return ListView(
      children: snapshot.data!.docs.map((DocumentSnapshot document) {
       Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return Card(
          shape: RoundedRectangleBorder(
           side: const BorderSide(color: Colors.black, width: 1),
           borderRadius: BorderRadius.circular(5),
          ),
          elevation: 0.0,
          margin: EdgeInsets.all(10.0),
          child: InkWell(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children:<Widget> [
                 Container(
                   margin: EdgeInsets.fromLTRB(5, 0, 10, 0),
                   child: const CircleAvatar(
                     backgroundColor: Colors.amber,
                     foregroundColor: Colors.black
               ),
                 ),
                 Flexible(

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:<Widget> [
                        Text(
                          data['title'],
                          style: const TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
                          ),
                          maxLines: 1,

                        ),
                        
                      
                      SizedBox(height: 5.0,),

                      Text(
                        data['content'],
                        style: TextStyle(fontSize: 14),
                        maxLines: 2,
                      )
                    ],
                  ),

                )
              ],
            ),
          ),
          onTap: (){
                          passData(data);
                        }
          )
        );

      }).toList(),
    );
      },
    );
  }
}


/*return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['full_name']),
              subtitle: Text(data['company']),
            );
          }).toList(),
        );
      },
    );
  }
}*/