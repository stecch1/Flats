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

  int gridCells = 2;
  
  final Stream<QuerySnapshot> _postStream = FirebaseFirestore.instance.collection('Post').snapshots();


  passData(Map<String, dynamic> data){
    Navigator.of(this.context).push(new MaterialPageRoute(builder: (context)=>PostDetails(data)));
  }


  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).size.width < 500 ? gridCells = 2 : gridCells = 3;
    return StreamBuilder<QuerySnapshot>(
      stream: _postStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        
    return GridView.count(

      crossAxisCount: gridCells,
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
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 60,
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          color: Colors.orange,
                          child: Text(
                            data['title'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.0),
                                child:
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 7.0,
                                        ),
                                        Text(
                                          data['content'],
                                          style: TextStyle(fontSize: 18),
                                          maxLines: 2,
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                      ],
                                    ),
                                  ),

                              ),
                            Container(
                              alignment: Alignment.bottomRight,
                              margin: EdgeInsets.fromLTRB(5, 0, 10, 0),
                              child: const CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.amber,
                                  foregroundColor: Colors.black),
                            ),
                          ],
                        ),

                      ],
                    ),
                    onTap: () {
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