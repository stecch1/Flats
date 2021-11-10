import 'package:flats/Models/user_model.dart';
import 'package:flats/Screens/Host/host_map.dart';
import 'package:flats/Screens/Host/profile_pic.dart';
import 'package:flats/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'host_add.dart';


class HostScreen extends StatefulWidget {
  const HostScreen({Key? key}) : super(key: key);

  @override
  _HostScreenState createState() => _HostScreenState();
}



class _HostScreenState extends State<HostScreen> {


  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
      stream: authService.user,
      builder:(_, AsyncSnapshot<User?> snapshot){
        if(snapshot.connectionState == ConnectionState.active){
          final User? user = snapshot.data;
          return Scaffold(

            body: Container(
              margin: EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ProfilePic(email: snapshot.data!.email!,),
                  Container(child:Text("User email: "+ snapshot.data!.email!),),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HostMap(uid: snapshot.data!.uid)));
                    },
                    child: const Text("my flats"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HostAdd(uid: snapshot.data!.uid, hostMail: snapshot.data!.email!,)));
                    },
                    child: const Text("add new flat"),
                  ),
                ],


              ),
            ),
          );
        }else{
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },

    );

  }
}
