import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 38,
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
