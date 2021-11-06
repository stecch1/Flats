
import 'package:flutter/material.dart';

Widget searchListUserTile({required String username, email}) {
  return GestureDetector(

    child: Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            //image here
          ),
          SizedBox(width: 12),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(username), Text(email)])
        ],
      ),
    ),
  );
}
