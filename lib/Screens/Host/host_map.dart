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
                onTap: () => _onMarkerPressed(document),
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
              initialCameraPosition: const CameraPosition(
                target: LatLng(45.478436, 9.226619), zoom: 11.5,),
              markers: markers,

            ),
          );

        },
      ),
    );
  }

  _onMarkerPressed(dynamic document) async {
    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("Location")
                            .doc(document.id)
                            .delete();
                        markers.removeWhere((element) => element.markerId.value == document.id);
                      },
                      color: Colors.red,
                      textColor: Colors.white,
                      child: const Text("Delete"),
                    ),
                  ],
                ),
              ),
              //TODO: add margin to these rows below
              Row(
                children: [Text("flat's name: " + document['name'] )],

              ),
              Row(children: [Text("euro/month: " + document['price'].toString() )],),
              Row(children: [Expanded(child: Text("description: " + document['description'] ))],),
            ],
          );
        });
    setState(() { });

  }

}
