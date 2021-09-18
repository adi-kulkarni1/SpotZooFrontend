import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotzoo_app1/screens/main/templates.dart';
import 'package:spotzoo_app1/screens/main/main_screen.dart';
//import 'package:snowplow_app/screens/features/cameraclass.dart';
//import 'package:camera/camera.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spotzoo_app1/screens/features/dateandtime.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotzoo_app1/utility/global.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class FormScreen extends StatefulWidget {
  FormScreen({Key key}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  int documentId = 0;
  int _numberOfContributions = 0;

  void getdata() {
    FirebaseFirestore.instance
        .collection("Doc_ID_Data")
        .doc("Doc_ID_ID")
        .get()
        .then((value) {
      documentId = value.get("doc_id_counter");
    });
    FirebaseFirestore.instance
        .collection("Users")
        .doc(Global.uid == null
            ? "Guest Account"
            : FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      setState(() {
        _numberOfContributions = value.get("num");
      });
    });
  }

  TextStyle style = TextStyle(
      fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black54);

  bool _openMap = false;
  GoogleMapController mapController;
  Position _currentPosition;
  LatLng loc;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getdata();
    _commentController.addListener(_updateTaskValue);
  }

  void _updateTaskValue() {}

  void mapPut() {
    setState(() {
      _openMap = true;
    });
  }

  _getCurrentLocation() async {
    Geolocator.getCurrentPosition().then((Position position) {
      setState(() {
        _currentPosition = position;
        loc = LatLng(_currentPosition.latitude, _currentPosition.longitude);
        FirebaseFirestore.instance
            .collection("Formdata")
            .doc("Response_" + documentId.toString())
            .set({'latitude_of_location': position.latitude},
                SetOptions(merge: true));
        FirebaseFirestore.instance
            .collection("Formdata")
            .doc("Response_" + documentId.toString())
            .set({'longitude_of_location': position.longitude},
                SetOptions(merge: true));
      });
    });
  }

  void mapRev() {
    setState(() {
      _openMap = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final openMapButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.white,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        onPressed: () {
          _getCurrentLocation();
          mapPut();
        },
        child: Text(
          "Set Current Location",
          textAlign: TextAlign.center,
          style: style,
        ),
      ),
    );

    final submitButton = Material(
      textStyle: style,
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.white,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
        onPressed: () {
          FirebaseFirestore.instance
              .collection("Formdata")
              .doc("Response_" + documentId.toString())
              .set({'comments': _commentController.text},
                  SetOptions(merge: true));
          FirebaseFirestore.instance
              .collection("Doc_ID_Data")
              .doc("Doc_ID_ID")
              .set({'doc_id_counter': documentId + 1}, SetOptions(merge: true));
          //final User user = FirebaseAuth.instance.currentUser;
          //final String uid = user.uid;
          FirebaseFirestore.instance
              .collection("Users")
              .doc(Global.uid == null ? "Guest Account" : Global.uid)
              .set(
                  {'num': _numberOfContributions + 1}, SetOptions(merge: true));
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        },
        child: Text(
          "Submit Form",
          textAlign: TextAlign.center,
          style: style,
        ),
      ),
    );

    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      // resizeToAvoidBottomInset: false, //Removed for web
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Animal Reporting Form",
          textAlign: TextAlign.center,
          //style: TextStyle(
          //    fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFFa1e2e7),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottom),
          child: Stack(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 100.0,
                          width: 100.0,
                          child: Image.asset('assets/images/main_hip.png')
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                          child: Text(
                            "Time animal was spotted?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        new DateTimeForm(
                          docid: documentId,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                                  child: Text(
                                    "Number of Animals",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                                    child: new DropdownWidget(
                                      docid: documentId,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 15.0, right: 30.0, left: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Add location of observation",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                            child: openMapButton),
                        if (_openMap)
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                            child: SizedBox(
                                width: screenWidth * 0.9,
                                height: screenHeight * 0.5,
                                child: new LocatorMap(
                                  center: loc,
                                  docid: documentId,
                                )),
                          ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 15.0, right: 30.0, left: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Upload Media Below",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        MyImagePicker(title: 'Upload image'),
                        // Align(
                        //   alignment: Alignment.center,
                        //   child: Padding(
                        //     padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        //     child: SizedBox(
                        //         //height:// ff,
                        //         //width: //ff,
                        //         child: new TakePictureScreen()),
                        //   ),
                        // ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 15.0, right: 30.0, left: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Any additional comments?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                          child: Container(
                              child: new TextFormField(
                                controller: _commentController,
                                decoration: InputDecoration(
                                    labelText: '  Enter a comment...'),
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: Colors.white,
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, right: 30.0, left: 30.0, bottom: 20.0),
                          child: Align(
                              alignment: Alignment.center, child: submitButton),
                        ),
                      ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DropdownWidget extends StatefulWidget {
  int docid;

  DropdownWidget({Key key, this.docid}) : super(key: key);

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _DropdownWidgetState extends State<DropdownWidget> {
  String dropdownValue = 'Select Here';
  int documentid = 50;

  void getdocid() {
    FirebaseFirestore.instance
        .collection("Doc_ID_Data")
        .doc("Doc_ID_ID")
        .get()
        .then((value) {
      documentid = value.get("doc_id_counter");
      print(documentid);
    });
  }

  @override
  void initState() {
    super.initState();
    getdocid();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      underline: Container(
        height: 2,
        color: Colors.white,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
          FirebaseFirestore.instance
              .collection("Formdata")
              .doc("Response_" + documentid.toString())
              // .doc("Test")
              .set({'numofanimals': dropdownValue}, SetOptions(merge: true));
        });
      },
      items: <String>['Select Here', '1', '2', '3', '4+']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class MyImagePicker extends StatefulWidget {
  MyImagePicker({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyImagePickerState createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  PickedFile _imageFile;
  final String uploadUrl = 'http://041d-163-120-35-224.ngrok.io/image';
  final ImagePicker _picker = ImagePicker();

  Future<String> uploadImage(filepath, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('image', filepath));
    var res = await request.send();
    return res.reasonPhrase;
  }

  Future<void> retriveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      print('Retrieve error ' + response.exception.code);
    }
  }

  Widget _previewImage() {
    if (_imageFile != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Image.file(File(_imageFile.path)),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: () async {
                var res = await uploadImage(_imageFile.path, uploadUrl);
                print(res);
              },
              child: const Text('Upload'),
            )
          ],
        ),
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  void _pickImage() async {
    try {
      final pickedFile = await _picker.getImage(source: ImageSource.gallery);
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      print("Image picker error " + e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
    children: <Widget>[
    Center(
          child: FutureBuilder<void>(
        future: retriveLostData(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Text('Picked an image');
            case ConnectionState.done:
              return _previewImage();
            default:
              return const Text('Picked an image');
          }
        // },
        })),
    MaterialButton(
      onPressed: _pickImage,
      child: Icon(Icons.photo_library),
    )
    ]);

    //   )),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: _pickImage,
    //     tooltip: 'Pick Image from gallery',
    //     child: Icon(Icons.photo_library),
    //   ), // This trailing comma makes auto-formatting nicer for build methods.
    // );
  }
}