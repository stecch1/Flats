import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeView extends StatelessWidget {
  Set<Marker> markers = Set();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Location").snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Text('Loading Data...Please wait');
          }
          GeoPoint location;

          var document = snapshot.data.docs.forEach((document){

            if(document.exists){

              location = document['location'];
              var latLng = LatLng(location.latitude, location.longitude);
              markers.add(Marker(markerId: MarkerId(document.id),
                  position: latLng,
                  infoWindow: InfoWindow(title: document['name'], snippet: document['price'].toString())));

            }
            else {
              print('document does not exist');
            }
          });


          return GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(45.478436, 9.226619), zoom: 11.5,),
            markers: markers,
          );
        },
      ),
    );
  }
}