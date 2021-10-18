import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';

//test commit ale

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHome()
    );
  }
}


class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}


class _MyHomeState extends State<MyHome> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static  List<Widget> _widgetOptions = <Widget>[
    FutureBuilder(
            future: Firebase.initializeApp(),
            builder: (context, snapshot) {
                if (snapshot.hasError) return const Text("Ugh oh! Something went wrong");

                if (!snapshot.hasData) return const Text("Got no data :(");

                if (snapshot.hasData &&
                   snapshot.connectionState == ConnectionState.done) {
                  return HomeView();
                }

                return const Text("Loading please...");
            },
          ),
    Text(
      ' Social ',
      style: optionStyle,
    ),
    Text(
      ' Chat ',
      style: optionStyle,
    ),
    Text(
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
      title: 
      'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: Stack(
            children: <Widget>[
               Text(
                'TestApp',
                style: TextStyle(
                  fontSize: 30,
                  foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 5
                  ..color = Colors.pink,
                ),
              ),
              Text(
                'TestApp',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.grey[300],
                ),
              )
            ],
          ),
          actions: <Widget>[
            IconButton(
               icon: const Icon(Icons.menu),
               onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return MaterialApp(
                  home: Scaffold(
                    appBar: AppBar(
                      title: Stack(
            children: <Widget>[
               Text(
                'TestApp',
                style: TextStyle(
                  fontSize: 30,
                  foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 5
                  ..color = Colors.pink,
                ),
              ),
              Text(
                'TestApp',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.grey[300],
                ),
              )
            ],
          ),
                    flexibleSpace: Container(
            decoration:const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Colors.white,
                Colors.pink,
              ])          
            ),        
        ),   
        ),
                    body: const Center(
                      child: Text(
                        'MENU PAGE',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  );
                },
              ));
              }
            ),
          ], 
          flexibleSpace: Container(
            decoration:const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Colors.white,
                Colors.pink,
              ])          
            ),        
        ),   
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
          currentIndex:  _selectedIndex,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
          ),
      ),
    );
  }
}


class HomeView extends StatelessWidget {
  Set<Marker> markers = Set();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Location").snapshots(),
          builder: (context,AsyncSnapshot snapshot){
          if(!snapshot.hasData){
            return Text('Loading Data...Please wait');
          }
            GeoPoint location = snapshot.data.docs[0]['location'];
            final latLng = LatLng(location.latitude, location.longitude);
            markers.add(Marker(markerId: MarkerId("location"), position: latLng, infoWindow: InfoWindow(title: 'Statale', snippet: '500€/mese') ));
            location = snapshot.data.docs[1]['location'];
            final latLng2 = LatLng(location.latitude, location.longitude);
            markers.add(Marker(markerId: MarkerId("location"), position: latLng2, infoWindow: InfoWindow(title: 'Bicocca', snippet: '450€/mese')));
            location = snapshot.data.docs[2]['location'];
            final latLng3 = LatLng(location.latitude, location.longitude);
            markers.add(Marker(markerId: MarkerId("location"), position: latLng3, infoWindow: InfoWindow(title: 'Polimi', snippet: '650€/mese')));
            location = snapshot.data.docs[3]['location'];
            final latLng4 = LatLng(location.latitude, location.longitude);
            markers.add(Marker(markerId: MarkerId("location"), position: latLng4, infoWindow: InfoWindow(title: 'Bocconi', snippet: '800€/mese')));
            if(location==null){
              return Text("There was no location data");
            }
          
          
         

                return GoogleMap(
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(target:  LatLng(45.478436, 9.226619), zoom: 11.5,),
                  markers: markers,
                );
              },
          ),
    );
  }
} 