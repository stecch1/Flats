import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flats/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as pt;
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
  File? img;


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
                onTap: () => {_onMarkerPressed(document)},
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
    Map<String, dynamic> map = document.data();
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {

          return StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate){
              String src = "";

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
                  children: [Text("flat's name: " + document['name'])],
                ),
                Row(
                  children: [Text("euro/month: " + document['price'].toString())],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text("description: " + document['description']))
                  ],
                ),
                map.containsKey("urls") == true ? Image.network(document["urls"][0],
                width: 400,
                height: 140,) : Container(),

                Column(
                  children: [
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              _pickImage().then((value) => mystate(() {}));
                            },
                            child: const Text("+ add photo")),

                        ElevatedButton(
                            onPressed: () {
                              _uploadImage(document).then((value) => {
                                    setState(() {
                                      mystate(() {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      });
                                    })
                                  });
                            },
                            child: const Text("Upload photo")),
                      ],
                    ),
                    Text(img != null ? img.toString() : ""),
                  ],
                ),


              ],
            );
          });
        }).whenComplete(() => img = null);
    setState(() {});
  }

  Future _pickImage() async{
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if(image == null) return;
      final imagePath =  File(image.path);

      this.img = imagePath;


    } on PlatformException catch (e) {
      print("Failed to pick image $e");
    }

  }

  Future _uploadImage(dynamic document) async{
    if (img == null) return;
    String id = document.id.toString();
    String name = pt.basename(img!.path);
    final destination = 'images/'+id+"/"+name;
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    try {
      await storage
          .ref(destination)
          .putFile(img!).whenComplete(() => storage.ref(destination).getDownloadURL().then((value) =>
          FirebaseFirestore.instance.collection('Location').doc(document.id).update(
              {
                "urls" : FieldValue.arrayUnion([value]),
              }
          )

      ));

    } on firebase_storage.FirebaseException catch (e) {
      print(e);
    }




  }


}
