import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flats/Screens/Host/host_adj_loc.dart';
import 'package:flats/Services/place_service.dart';
import 'package:uuid/uuid.dart';
import 'package:flats/Screens/Host/address_serach.dart';



class property{
  String name='';
  int price= 0;
  LatLng coordinate;
  property(this.name, this.price, this.coordinate);
}


class Hostfirstpage extends StatefulWidget {
  const Hostfirstpage({Key? key}) : super(key: key);

  @override
  _Hostfirststate createState() => _Hostfirststate();
}

class _Hostfirststate extends State<Hostfirstpage>{
  final AdNameController = TextEditingController();
  final PriceController = TextEditingController();
  final AddressController = TextEditingController();
  late LatLng coordinate = LatLng(45.478436, 9.226619);
  

  
 @override
  void dispose() {
    AdNameController.dispose();
    PriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 38,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsetsDirectional.fromSTEB(5, 0, 120, 0),
            child: const Text(
                'Start listing \nyour property',
                style: TextStyle(fontSize: 40),
                ),
          ),
            Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 50, 20, 5),
                child: TextFormField(
                  controller: AdNameController,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: 'ad\'s name',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
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
                  controller: PriceController,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: 'price €',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(padding: EdgeInsetsDirectional.fromSTEB(20, 5, 20, 5) ,
                child:   
                TextFormField(
                  controller: AddressController,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: 'address (e.g. via golgi, 60, Milano)',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
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
                      AddressController.text = result.description;
                      coordinate = LatLng(placeDetails.lat, placeDetails.long);
                      
                    });
                  }
                  
                  },
                ),
              ),
            Padding(padding: EdgeInsetsDirectional.fromSTEB(250, 100, 5, 0) ,
            child: ElevatedButton(
                onPressed:() {
                  property property_prov= property(AdNameController.text,int.parse(PriceController.text),coordinate);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
    	                builder: (context) => locationScreen(property_prov)),
                  );
                },
                child: Text("Next"),
              ),
            ),
        ]
      )
    );
  }
}