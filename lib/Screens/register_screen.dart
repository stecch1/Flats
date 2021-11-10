import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flats/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(child:Text("Insert email and password")),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password"),
              ),
            ),
            ElevatedButton(
            onPressed: () async {
              authService
                  .createUserWithEmailAndPassword(
                      emailController.text, passwordController.text)
                  .then((usr) => {
                        FirebaseFirestore.instance.collection('User').add({
                          "username": usr!.email!.substring(0,usr.email!.indexOf('@')),
                          "email": usr.email,
                          "pic_url": "https://firebasestorage.googleapis.com/v0/b/testappproject-329013.appspot.com/o/images%2Faccountpic.png?alt=media&token=94d81c05-78f6-46ff-a000-491cffdd6107",
                        })
                      });

              Navigator.pop(context);
                  },
                child: Text("Register")),



          ],
        )

    );
  }
}