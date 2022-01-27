import 'package:flats/Screens/Social/PostDetails/post_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path/path.dart';

class PostCard extends StatefulWidget {
  Map<String, dynamic> data;
  String docId;
  PostCard({Key? key, required this.data, required this.docId}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  passData(Map<String, dynamic> data){
    Navigator.of(this.context).push(new MaterialPageRoute(builder: (context)=>PostDetails(data,widget.docId)));
  }

  @override
  Widget build(BuildContext context) {
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
                  key:ValueKey("container_key"),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.orange,
                  ),
                  width: double.infinity,
                  height: 60,
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),

                  child: Text(
                    widget.data['title'],
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
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 7.0,
                            ),
                            Text(
                              widget.data['content'],
                              style: TextStyle(fontSize: 18),
                              maxLines: 2,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
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
              passData(widget.data);
            }
        )
    );
  }
}
