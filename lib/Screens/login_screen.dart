import 'package:flats/Screens/register_screen.dart';
import 'package:flats/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final formGlobalKey = GlobalKey<FormState>();

class EmailFieldValidator{
  static String? validate(String value){
    return (value.isEmpty || !RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value) ) ? 'Invalid Email' : null;
  }
}

class PasswordFieldValidator{
  static String? validate(String value){
    return (value.isEmpty || value.length <6) ? 'Password can\'t be empty or shorter than 6 characters' : null;
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formGlobalKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("you need to login!!!"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  
                  validator: (value)=>EmailFieldValidator.validate(value!),
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(

                  obscureText: true,
                  validator: (value)=> PasswordFieldValidator.validate(value!),
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: "Password"),
                ),
              ),
              ElevatedButton(
                  onPressed: (){
                    if (formGlobalKey.currentState!.validate()) {
                      authService.signInWithEmailAndPassword(emailController.text, passwordController.text);
                    }
              },
                  child: const Text("Login")),

              ElevatedButton(onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Register()));
              }, child: const Text("Register")),

            ],
          ),
        ),
      )

    );
  }
}
