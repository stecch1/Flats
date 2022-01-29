import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flats/Utils/custom_dialog.dart';
import 'package:flats/Utils/image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flats/Screens/Social/create_post.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Set<Marker> markers = Set();
  late BitmapDescriptor customIcon;
  var user_location = Location();
  LocationData? currentLocation;
  late var initial_location;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  bool ok = true;
 

  @override
  void initState(){
    getIcons();
    super.initState();
    _check_permission();
    if(ok){
      user_location.onLocationChanged.listen((value) {
        setState(() {
          currentLocation = value;
        });
      });
    }
  }


getIcons() async{
  var icon = await BitmapDescriptor.fromAssetImage(
    ImageConfiguration(devicePixelRatio: 3.0),
    "assets/images/marker.png"    
  );
  setState(() {
    this.customIcon= icon;
  });
}

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
                infoWindow: InfoWindow(
                    title: document['name'],
                    snippet: document['price'].toString() + ' €/month'),
                onTap: () =>
                    MediaQuery.of(context).size.width < 800
                        ? _showBottomSheet(document)
                        : showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              Map<String, dynamic> map = document.data();
                              return CustomDialogBox(
                                map: map,
                                document: document,
                              );
                            }),
                icon: customIcon,
              ));
            }
            else {
              print('document does not exist');
            }
          });
          currentLocation==null
            ? initial_location = LatLng(45.478436, 9.226619)
            : initial_location = LatLng(currentLocation!.latitude!,currentLocation!.longitude!);
          return GoogleMap(
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: initial_location, zoom: 11.5,),
              markers: markers,
            );
        },
      ),
    );
  }

  _showBottomSheet(dynamic document) async {
    Map<String, dynamic> map = document.data();
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {

          return Container(

            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: ListView(

              shrinkWrap: true,
              children: [

                  Container(
                    margin: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreatePost(document)));
                          },
                          color: Colors.amber,
                          textColor: Colors.white,
                          child: const Text("Create Post"),
                        ),
                      ],
                    ),
                  ),

                //TODO: add margin to these rows below

                Row(
                  children: [
                    const Text(
                      "flat's name: ",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      document['name'],
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    const Text(
                      "euro/month: ",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      document['price'].toString(),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "description: ",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        document['description'],
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),

                map.containsKey("urls") == true
                    ? Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ImageView(
                          map: map,
                        ),
                    )
                    : Container(),
              ],
            ),
          );
        });
  }

  _check_permission()async {
    _serviceEnabled = await user_location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await user_location.requestService();
      if (!_serviceEnabled) {
        ok = false;
        return;
      }
    }

    _permissionGranted = await user_location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await user_location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        ok = false;
        return;
      }
    }
    return;
  }


}
