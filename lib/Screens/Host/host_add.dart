import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flats/Screens/Host/host_adj_loc.dart';
import 'package:flats/Services/place_service.dart';
import 'package:uuid/uuid.dart';
import 'package:flats/Screens/Host/address_search.dart';

class property {
  String name = '';
  String description = '';
  int price = 0;
  LatLng coordinate;
  String hostMail;

  property(this.name,this.description, this.price, this.coordinate, this.hostMail);
}

class HostAdd extends StatefulWidget {
  HostAdd({Key? key, required this.uid, required this.hostMail}) : super(key: key);

  String uid;
  String hostMail;

  @override
  _HostAddstate createState() => _HostAddstate();
}

class _HostAddstate extends State<HostAdd> {
  final flatNameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();
  late LatLng coordinate = LatLng(45.478436, 9.226619);

  @override
  void dispose() {
    flatNameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 38,
        ),
        body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5, 0, 120, 0),
              child: Text(
                'Start listing \nyour property',
                style: TextStyle(fontSize: 40),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 30, 20, 5),
              child: TextFormField(
                controller: flatNameController,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: "flat's name",
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF000000),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF000000),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 5, 20, 5),
              child: TextFormField(
                controller: priceController,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: '€/month',
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF000000),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF000000),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 5, 20, 5),
              child: TextFormField(
                controller: descriptionController,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: "description ",
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF000000),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF000000),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 5, 20, 5),
              child: TextFormField(
                controller: addressController,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'address (e.g. via golgi, 60, Milano)',
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF000000),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF000000),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  final sessionToken = Uuid().v4();
                  final Suggestion? result = await showSearch(
                    context: context,
                    delegate: AddressSearch(sessionToken),
                  );

                  if (result != null) {
                    final placeDetails = await PlaceApiProvider(sessionToken)
                        .getPlaceDetailFromId(result.placeId);
                    setState(() {
                      addressController.text = result.description;
                      coordinate = LatLng(placeDetails.lat, placeDetails.long);
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(250, 100, 5, 0),
              child: ElevatedButton(
                onPressed: () {
                  property property_prov = property(flatNameController.text,descriptionController.text,
                      int.parse(priceController.text), coordinate, widget.hostMail);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            locationScreen(widget.uid, property_prov)),
                  ).then((value) => Navigator.pop(context));
                },
                child: const Text("Next"),
              ),
            ),
          ]),
        ));
  }
}
