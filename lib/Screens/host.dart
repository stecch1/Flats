import 'package:flats/Models/user_model.dart';
import 'package:flats/Screens/login_screen.dart';
import 'package:flats/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HostScreen extends StatefulWidget {
  const HostScreen({Key? key}) : super(key: key);

  @override
  _HostScreenState createState() => _HostScreenState();
}


class _HostScreenState extends State<HostScreen> {
  String? _email = "";

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    authService.user!.listen(
          (data) =>   {
            if(data != null && data.email != null){
            _email = data.email}
            else{print("user stream is null")}},
    );
    return Container(
      child: FlatButton(
        child: Text("print email on console"),
        onPressed: () {print(_email);},
      ),
    );
  }
}
