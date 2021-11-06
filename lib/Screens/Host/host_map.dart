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
  TextEditingController controller1 = TextEditingController ();
  TextEditingController controller2 = TextEditingController ();


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
              markers.add(Marker(
                  markerId: MarkerId(document.id),
                position: latLng,
                infoWindow: InfoWindow(
                  title: document['name'],
                  snippet: document['price'].toString(),
                ),
                onTap: () => _onMarkerPressed(document.id),
              ));
            } else {
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
              onLongPress: _addMarkerDialog,
            ),
          );

        },
      ),
    );
  }

  _addMarkerDialog(LatLng pos) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Add a new flat"),
            content: Column(
              children: [
                Text("name"),
                TextField(
                  controller: controller1,
                ),
                Text("price"),
                TextField(
                  controller: controller2,
                )
              ],
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  _addMarker(pos, controller1.text,
                      int.tryParse(controller2.text) ?? 0);
                  controller1.clear();
                  controller2.clear();
                  Navigator.pop(context);
                },
                elevation: 5.0,
                child: Text("Submit"),
              ),
            ],
          );
        });
  }

  _addMarker(LatLng pos, String name, int price){
    setState(() {
      FirebaseFirestore.instance.collection('Location').add(
          {
            "uid": widget.uid,
            "location": GeoPoint(pos.latitude, pos.longitude),
            "name": name,
            "price":price,
          }
      );

    });

  }

  _onMarkerPressed(String documentID) async {
    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            children: [
              Container(
                margin: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("Location")
                            .doc(documentID)
                            .delete();
                        markers.removeWhere((element) => element.markerId.value == documentID);
                      },
                      color: Colors.red,
                      textColor: Colors.white,
                      child: Text("Delete"),
                    ),
                  ],
                ),
              )
            ],
          );
        });
    setState(() { });

  }

}
