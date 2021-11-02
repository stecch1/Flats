import 'package:cloud_firestore/cloud_firestore.dart';
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
        stream: FirebaseFirestore.instance.collection("Location").where('uid', isEqualTo: widget.uid).snapshots(),
        builder: (context, AsyncSnapshot snapshot) {

          if (!snapshot.hasData) {
            return Scaffold(
              body: Container(
                child: const Text('Loading Data...Please wait'),
              ),
            );
          }

          GeoPoint location;

          var document = snapshot.data.docs.forEach((document) {
            if (document.exists) {

              location = document['location'];
              var latLng = LatLng(location.latitude, location.longitude);
              markers.add(Marker(markerId: MarkerId(document.id),
                  position: latLng,
                  infoWindow: InfoWindow(title: document['name'],
                      snippet: document['price'].toString())));
            }
            else {
              print('document does not exist');
            }
          }

          );


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
