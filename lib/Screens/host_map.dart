import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flats/Models/user_model.dart';
import 'package:flats/Screens/login_screen.dart';
import 'package:flats/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HostMap extends StatefulWidget {
  HostMap({Key? key, required String this.uid}) : super(key: key);

  String uid;

  @override
  _HostMapState createState() => _HostMapState();
}



class _HostMapState extends State<HostMap> {

  Set<Marker> markers = Set();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);




    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Users/" + widget.uid + "/Locations")
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              body: Container(
                child: const Text('Loading Data...Please wait'),
              ),
            );
          }

          print(snapshot.data.docs[0]['name']);

          GeoPoint location = snapshot.data.docs[0]['location'];
          final latLng = LatLng(location.latitude, location.longitude);
          markers.add(Marker(markerId: MarkerId("location"),
              position: latLng,
              infoWindow: InfoWindow(title: 'Cattolica', snippet: '350euro/mese')));

          location = snapshot.data.docs[1]['location'];
          final latLng2 = LatLng(location.latitude, location.longitude);
          markers.add(Marker(markerId: MarkerId("location"),
              position: latLng2,
              infoWindow: InfoWindow(title: 'polimi', snippet: '450€/mese')));


          if (location == null) {
            return Text("There was no location data");
          }


          return Scaffold(
            body: GoogleMap(
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(45.478436, 9.226619), zoom: 11.5,),
              markers: markers,
            ),
          );



        },
      ),
    );
  }
}
