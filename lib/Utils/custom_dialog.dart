import 'dart:ui';
import 'package:flats/Screens/Social/create_post.dart';
import 'package:flats/Utils/image_view.dart';
import 'package:flats/Utils/wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class CustomDialogBox extends StatefulWidget {

  final dynamic document;
  final Map<String, dynamic> map;

  CustomDialogBox({ Key? key,
    required this.document,
    required this.map,
  })
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.topLeft,
      child: Dialog(
        insetPadding: EdgeInsets.fromLTRB(0,0,
            MediaQuery.of(context).size.width < 1100 ?
            500 :
            800,
            MediaQuery.of(context).size.width < 1100 ?
            700 :
            500),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(Constants.padding),
        ),


        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                margin: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Wrapper(widget: CreatePost(widget.document))));
                      },
                      color: Colors.amber,
                      textColor: Colors.white,
                      child: const Text("Create Post"),
                    ),
                  ],
                ),
              ),
              //TODO: add margin to these rows below

              Row(
                children: [
                  const Text(
                    "flat's name: ",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.document['name'],
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  const Text(
                    "euro/month: ",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.document['price'].toString(),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "description: ",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.document['description'],
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              widget.map.containsKey("urls") == true
                  ? ImageView(
                map: widget.map,
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

}


