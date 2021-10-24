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
          GeoPoint location = snapshot.data.docs[0]['location'];
          final latLng = LatLng(location.latitude, location.longitude);
          markers.add(Marker(markerId: MarkerId("location"),
              position: latLng,
              infoWindow: InfoWindow(title: 'Statale', snippet: '500€/mese')));
          location = snapshot.data.docs[1]['location'];
          final latLng2 = LatLng(location.latitude, location.longitude);
          markers.add(Marker(markerId: MarkerId("location"),
              position: latLng2,
              infoWindow: InfoWindow(title: 'Bicocca', snippet: '450€/mese')));
          location = snapshot.data.docs[2]['location'];
          final latLng3 = LatLng(location.latitude, location.longitude);
          markers.add(Marker(markerId: MarkerId("location"),
              position: latLng3,
              infoWindow: InfoWindow(title: 'Polimi', snippet: '650€/mese')));
          location = snapshot.data.docs[3]['location'];
          final latLng4 = LatLng(location.latitude, location.longitude);
          markers.add(Marker(markerId: MarkerId("location"),
              position: latLng4,
              infoWindow: InfoWindow(title: 'Bocconi', snippet: '800€/mese')));
          if (location == null) {
            return Text("There was no location data");
          }


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