
import 'package:flats/Screens/host_map.dart';
import 'package:flats/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';


class HostScreen extends StatefulWidget {
  const HostScreen({Key? key}) : super(key: key);

  @override
  _HostScreenState createState() => _HostScreenState();
}



class _HostScreenState extends State<HostScreen> {
  String? email = "";
  String? uid = "";


  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);

    authService.user!.listen(
          (data) =>   {
        if(data != null && data.uid != null){
          uid = data.uid,
        print(uid)}
        else{print("user stream is null")}},
    );

    return Scaffold(
      body: Container(
        child: FlatButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HostMap(uid: uid!)));
          },
          child: Text("Map"),
        ),
      ),
    ); //: new Container(child: Text("Container"));
  }
}
