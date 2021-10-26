import 'package:flats/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 38,
          automaticallyImplyLeading: false,
          leading: IconButton (
            icon: Icon(Icons.logout, semanticLabel: "sign out",),
            onPressed: () {
              authService.signOut();
            },
          ),
        ),
        body: const Center(
          child: Text(
            'MENU PAGE',
            style: TextStyle(fontSize: 24),
          ),
        ),
      );

  }
}
