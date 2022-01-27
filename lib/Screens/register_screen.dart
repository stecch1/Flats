import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flats/Screens/login_screen.dart';
import 'package:flats/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final formGlobalKey = GlobalKey<FormState>();

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthService? authService = null;
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      authService = Provider.of<AuthService>(context);
    }
    return Scaffold(
        body: Form(
          key: formGlobalKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(child:Text("Insert email and password")),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value)=> EmailFieldValidator.validate(value!),
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Email"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value)=> PasswordFieldValidator.validate(value!),
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(labelText: "Password"),
                ),
              ),
              ElevatedButton(
              onPressed: () async {
                if (formGlobalKey.currentState!.validate()) {
                  authService!
                      .createUserWithEmailAndPassword(
                          emailController.text, passwordController.text)
                      .then((usr) => {
                            FirebaseFirestore.instance.collection('User').add({
                              "username": usr!.email!
                                  .substring(0, usr.email!.indexOf('@')),
                              "email": usr.email,
                              "pic_url":
                                  "https://firebasestorage.googleapis.com/v0/b/testappproject-329013.appspot.com/o/images%2Faccountpic.png?alt=media&token=94d81c05-78f6-46ff-a000-491cffdd6107",
                            })
                          });

                  Navigator.pop(context);
                }
              },
                  child: Text("Register")),



            ],
          ),
        )

    );
  }
}