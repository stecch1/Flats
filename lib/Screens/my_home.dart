import 'package:firebase_core/firebase_core.dart';
import 'package:flats/Screens/home_view.dart';
import 'package:flats/Screens/menu.dart';
import 'package:flats/Theme/theme.dart';
import 'package:flutter/material.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}


class _MyHomeState extends State<MyHome> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static final List<Widget> _widgetOptions = <Widget>[
    FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Ugh oh! Something went wrong");
        }

        if (!snapshot.hasData) return const Text("Got no data :(");

        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return HomeView();
        }

        return const Text("Loading please...");
      },
    ),
    const Text(
      ' Social ',
      style: optionStyle,
    ),
    const Text(
      ' Chat ',
      style: optionStyle,
    ),
    const Text(
      ' Host',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 38,

        ),
        drawer: Drawer(
          child: Menu(),
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              backgroundColor: Colors.black,
              label: 'House',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              backgroundColor: Colors.black,
              label: 'Social',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.send),
              backgroundColor: Colors.black,
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.perm_identity),
              backgroundColor: Colors.black,
              label: 'Host',
            ),
          ],
          currentIndex: _selectedIndex,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),

    );
  }
}