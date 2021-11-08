import 'package:flutter/cupertino.dart';

class ImageView extends StatelessWidget {
  ImageView({Key? key, required this.map}) : super(key: key);
  Map<String, dynamic> map;
  @override
  Widget build(BuildContext context) {
     return map["urls"].length == 0 ? Container()
         : Image.network(map["urls"][0],
            width: 400,
            height: 140,) ;
  }
  //TODO: SUPPORT MORE THAN 1 pic VIEW
}
