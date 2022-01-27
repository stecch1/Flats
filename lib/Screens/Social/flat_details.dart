import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class flatDetails extends StatefulWidget {
  final String flatId;

  const flatDetails(this.flatId, {Key? key}) : super(key: key);

  @override
  _flatDetailsState createState() => _flatDetailsState();
}

class _flatDetailsState extends State<flatDetails> {
  int _currentIndex = 0;
  Set<Marker> markers = Set();
  late BitmapDescriptor customIcon;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  void initState() {
    getIcons();
    super.initState();
  }

  getIcons() async {
    var icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 3.0), "assets/images/marker.png");
    setState(() {
      this.customIcon = icon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Location")
                .doc(widget.flatId)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Scaffold(
                  body: Container(
                    child: const Text('Loading Data...Please wait'),
                  ),
                );
              }
              final urlImages = snapshot.data['urls'];
              GeoPoint location;
              location = snapshot.data['location'];
              var latLng = LatLng(location.latitude, location.longitude);
              markers.add(Marker(
                markerId: MarkerId(widget.flatId),
                position: latLng,
                icon: customIcon,
              ));
              return Scaffold(
                appBar: AppBar(
                    title: Text("Flat Details"), backgroundColor: Colors.amber),
                body: ListView(
                  shrinkWrap: true,
                  /*mainAxisSize: MainAxisSize.max,*/
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          snapshot.data['name'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 40,
                          ),
                        )
                      ],
                    ),
                    Divider(
                      thickness: 5,
                    ),
                    CarouselSlider.builder(
                        itemCount: urlImages.length,
                        itemBuilder: (BuildContext context, index, int) {
                          final urlImage = urlImages[index];
                          return buildImage(urlImage, index);
                        },
                        options: CarouselOptions(
                          height: 200,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: map<Widget>(urlImages, (index, url) {
                        return Container(
                          width: 10.0,
                          height: 10.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentIndex == index
                                ? Colors.blueAccent
                                : Colors.grey,
                          ),
                        );
                      }),
                    ),
                    Divider(
                      thickness: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          snapshot.data['price'].toString() + '€/month',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 25,
                          ),
                        )
                      ],
                    ),
                    Divider(
                      thickness: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 350,
                            child: Text(
                              snapshot.data['description'],
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                              ),
                            ))
                      ],
                    ),
                    Divider(
                      thickness: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 250,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Color(0xFFEEEEEE),
                              borderRadius: BorderRadius.circular(5),
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: Color(0xFF0B0B0B),
                                width: 2,
                              ),
                            ),
                            child: GoogleMap(
                              initialCameraPosition:
                                  CameraPosition(target: latLng, zoom: 15),
                              markers: markers,
                            ))
                      ],
                    )
                  ],
                ),
              );
            }));
  }

  Widget buildImage(String urlImage, int index) => Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        color: Colors.grey,
        child: Image.network(
          urlImage,
          fit: BoxFit.cover,
        ),
      );
}
