import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:spotzoo_app1/screens/main/templates.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spotzoo_app1/screens/reporting/mainform.dart';

class HomeUI extends StatefulWidget {
  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  GoogleMapController mapController;
  final LatLng _center = const LatLng(40.57153, -77.39464);
  bool _isMapLegendAsked = false;

  int docid;
  double lat = 10.1;
  double long = 10.1;
  String title;
  String date;
  int counter = 0;

  void getdocid() {
    FirebaseFirestore.instance
        .collection("Doc_ID_Data")
        .doc("Doc_ID_ID")
        .get()
        .then((value) async {
      docid = value.get("doc_id_counter");
      //print(documentId);
    });
  }

  void openMapLegend() {
    setState(() {
      _isMapLegendAsked = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getdocid();
  }

  TextStyle style = TextStyle(
      fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black54);

  Set<Marker> _markers = HashSet<Marker>();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    setState(() {});
  }

  Future<Set<Marker>> myMarkers() async {
    setState(() {
      getdocid();
    });
    for (int i = 0; i <= docid - 1; i++) {
      counter = i;
      // print(counter);
      FirebaseFirestore.instance
          .collection("Formdata")
          .doc("Response_" + counter.toString())
          .get()
          .then((value) {
        counter++;
        final marker = Marker(
            markerId: MarkerId(counter.toString()),
            position: LatLng(value.get("latitude_of_location"),
                value.get("longitude_of_location")),
            infoWindow: InfoWindow(
                title: value.get("animal")+" ("+value.get("numofanimals")+")", snippet: value.get("date") + ", ML Confid: "+ value.get("score")),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                (("bird"==(value.get("animal"))) | ("cat"==(value.get("animal"))) | ("butterfly"==(value.get("animal"))) | ("person"==(value.get("animal")))) ? BitmapDescriptor.hueGreen: (("elephant"==(value.get("animal"))) | ("zebra"==(value.get("animal"))) | ("giraffe"==(value.get("animal"))) | ("monkey"==(value.get("animal")))) ? BitmapDescriptor.hueYellow  : BitmapDescriptor.hueRed
                ), //Dont change format of this
            onTap: () {
              //what to do when marker is tapped
            });
        // print(marker.toString());
        (value.get("timestamp").toDate()).isAfter(DateTime(DateTime.now().year,DateTime.now().month-1, DateTime.now().day)) ? _markers.add(marker) : print(value.get("timestamp").toString());
        //print(_markers); ABOVE LINE RESTRICTS the markers to display now ones in the past month
      });
    }
    //print(_markers);
    return _markers;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double pixelThreeHeight = 737.4545454545455;

    final reportButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15.0),
      color: const Color(0xFFa1e2e7),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormScreen()),
          );
        },
        child: Text(
          "Report \n Sightings",
          textAlign: TextAlign.center,
          style: style,
        ),
      ),
    );

    final legendButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15.0),
      color: const Color(0xFFa1e2e7),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        onPressed: () {
          openMapLegend();
        },
        child: Text(
          "Open Map \n Legend",
          textAlign: TextAlign.center,
          style: style,
        ),
      ),
    );

    final loadMarkersButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15.0),
      color: const Color(0xFFa1e2e7),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        onPressed: () {
          setState(() {
            getdocid();
            //Firestore.instance.collection("Loads").add({"load": true});
            myMarkers();
          });
        },
        child: Text(
          "Load\nSightings",
          textAlign: TextAlign.center,
          style: style,
        ),
      ),
    );

    return Center(
        child: Container(
            width: screenWidth,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Stack(children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    width: screenWidth,
                    child: SearchMapPlaceWidget(
                      hasClearButton: true,
                      placeType: PlaceType.address,
                      placeholder: 'Search Address...',
                      apiKey: 'AIzaSyCx8c54DRESgvG8LyTGYc4ACQmukde1lo0',
                      onSelected: (Place place) async {
                        Geolocation geolocation = await place.geolocation;
                        mapController.animateCamera(
                            CameraUpdate.newLatLng(geolocation.coordinates));
                        mapController.animateCamera(
                            CameraUpdate.newLatLngBounds(
                                geolocation.bounds, 0));
                      },
                    ),
                  ),
                  SizedBox(
                      width: screenWidth,
                      height: screenHeight * 0.62,
                      child: FutureBuilder(
                        //from here
                        future: myMarkers(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return GoogleMap(
                            mapType: MapType.normal,
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: _center,
                              zoom: 6.0,
                            ),
                            markers: snapshot.data,
                          );
                        },
                      ), //to here
                      // GoogleMap( //Main Map on Home Screen
                      //    mapType: MapType.normal,
                      //    markers: _markers,
                      //    onMapCreated:_onMapCreated,
                      //    initialCameraPosition: CameraPosition(
                      //      target: _center,
                      //       zoom: 6.0,
                      //      ),
                      //  ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(top: 13*screenHeight/pixelThreeHeight),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(5.0, 0, 0.0, 0),
                              child: reportButton),
                        ),
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                              child: loadMarkersButton),
                        ),
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 5.0, 0.0),
                              child: legendButton),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (_isMapLegendAsked)
                Stack(
                  children: [
                    GestureDetector(
                      child: Container(
                        color: Colors.black45,
                        width: screenWidth,
                        height: screenHeight,
                      ),
                      onTap: () {
                        setState(() {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _isMapLegendAsked = false;
                        });
                      },
                    ),
                    Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          child: GestureDetector(
                            child: Container(
                              child: MapLegend(),
                              decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white),
                            ),
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ])));
  }
}