import 'package:flats/Screens/Social/PostDetails/post_details_view.dart';
import 'package:flats/Services/auth_service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flats/Models/user_model.dart';

class PostDetails extends StatefulWidget {
  Map<String, dynamic> data;
  String docId;

  PostDetails(this.data,this.docId, {Key? key}) : super(key: key);

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
        stream: authService.user,
        builder: (_, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            return PostDetailsView(data: widget.data,docId : widget.docId,user: user!);
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
