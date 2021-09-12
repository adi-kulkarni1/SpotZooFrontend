import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:path_provider/path_provider.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:spotzoo_app1/screens/main/main_screen.dart';
import 'package:spotzoo_app1/utility/global.dart';
import 'package:spotzoo_app1/utility/notifiers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

//login template
class LoginTemplate extends StatefulWidget {
  LoginTemplate();

  @override
  State<LoginTemplate> createState() {
    return _LoginTemplateState();
  }
}

class _LoginTemplateState extends State<LoginTemplate> {
  //variables to change UI based on state

  final _loginFormKey = GlobalKey<FormState>();

  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  //String _tier = "";

  bool _desiresAutoLogin = false;
  bool _isLogginIn = false;

  _LoginTemplateState() {
    autoLogin();
  }

  //will auto fill the user's information in the controllers
  void autoLogin() async {
    final appDirectory =
        await getApplicationDocumentsDirectory(); //get app directory

    //check whether the file exists
    if (File(appDirectory.path + "/user.json").existsSync()) {
      Map userInfo = json.decode(File(appDirectory.path + "/user.json")
          .readAsStringSync()); //read data from file

      //alter UI with the autofill information
      setState(() {
        _desiresAutoLogin = userInfo['auto'];

        if (_desiresAutoLogin) {
          _email.text = userInfo['email'];
          _password.text = userInfo['password'];
        }
      });
    } else {
      Global.userDataFile = File(appDirectory.path + "/user.json");
    }
  }

  //try executing the actual login process
  void executeLogin() async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _email.text.trim(), password: _password.text.trim())
        .then((authResult) async /*sign in callback */ {
      String userId =
          authResult.user.uid; //used to query for the user data in firestore

      Global.uid = userId;

      DocumentSnapshot userDocument = await FirebaseFirestore.instance
          .collection("Users")
          .doc(userId)
          .get();
      var userData = userDocument.data();

      // // Sets tier
      // _tier = userData["tier"];
      // Global.tier = _tier;
      if (kIsWeb) {
          // Set web-specific directory here
    } else {
      final appDirectory = await getApplicationDocumentsDirectory();

      //write to json file
      final userStorageFile = File(appDirectory.path + "/user.json");

      //setting the state container file to the userStorageFile
      Global.userDataFile = userStorageFile;

      assert(Global.userDataFile != null);
    }
      Map jsonInformation = {
        'auto': _desiresAutoLogin,
        'email': _email.text,
        'password': _password.text,
        //'tier': _tier
      };
          if (kIsWeb) {
    // Set web-specific directory line as a replacement
    } else {
      await Global.userDataFile.writeAsString(
          json.encode(jsonInformation)); //update file information
    }
      //changes screen to profile screen
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => new HomeScreen()));
    }).catchError((error) {
      print(error);

      setState(() => _isLogginIn = false);
      //if credentials are invalid then throw the error
      if (error.toString().contains("INVALID") ||
          error.toString().contains("WRONG") ||
          error.toString().contains("NOT_FOUND")) {
        showDialog(
            context: context,
            builder: (context) {
              return SingleActionPopup(
                  "Invalid Credentials", "Error", Colors.black);
            });
      }

      //if network times out, throw error
      else if (error.toString().contains("NETWORK")) {
        showDialog(
            context: context,
            builder: (context) {
              return ErrorPopup(
                  "Network timed out, please check your wifi connection", () {
                Navigator.of(context).pop();
                setState(() {
                  _isLogginIn = true;
                });
                executeLogin();
              });
            });
      }
    });
  }

  void tryToLogin() async {
    setState(() {
      _isLogginIn = true;
    });
    executeLogin();
  }

  Widget build(BuildContext context) {
    //used to set relative sizing based on a pixel 2 phone
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double pixelTwoWidth = 411.42857142857144;
    double pixelTwoHeight = 683.4285714285714;

    return Stack(
      children: <Widget>[
        Container(
          width: screenWidth * 0.8,
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(top: 15 * screenHeight / pixelTwoHeight),
                child: Container(
                  child: Text(
                    "Login",
                    style: new TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 32 * screenWidth / pixelTwoWidth,
                    ),
                  ),
                ),
              ),
              Form(
                key: _loginFormKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: 15 * screenHeight / pixelTwoHeight),
                      child: Container(
                        width: screenWidth * 0.75,
                        //make this a TextField if using controller
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _email,
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 18 * screenWidth / pixelTwoWidth),
                          validator: (val) {
                            if (val != "") {
                              setState(() {
                                _email.text = val;
                              });
                            }

                            bool dotIsNotIn = _email.text.indexOf(".") == -1;
                            bool atIsNotIn = _email.text.indexOf("@") == -1;

                            //validate email locally

                            if (dotIsNotIn || atIsNotIn) {
                              return "Invalid Email Type";
                            }

                            return null;
                          },
                          textAlign: TextAlign.center,
                          decoration: new InputDecoration(
                            icon: Icon(Icons.mail),
                            labelText: "E-mail",
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: screenWidth * 0.75,
                      //make this a TextField if using controller
                      child: TextFormField(
                        controller: _password,
                        style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 18 * screenWidth / pixelTwoWidth),
                        validator: (val) /* check whether the form is valid */ {
                          if (val == "") {
                            return "Field is empty";
                          }

                          setState(() {
                            _password.text = val;
                          });

                          //validate password length
                          bool hasLengthLessThan8 = _password.text.length < 8;

                          if (hasLengthLessThan8) {
                            return "Password less than 8";
                          }

                          return null;
                        },
                        textAlign: TextAlign.center,
                        obscureText: true,
                        decoration: new InputDecoration(
                            icon: Icon(Icons.lock), labelText: "Password"),
                      ),
                    ),
                    Container(
                      child: FlatButton(
                        child: !_desiresAutoLogin
                            ? Text("Enable Auto-Login",
                                style: TextStyle(
                                    fontFamily: 'Lato',
                                    color: Colors.blue[600],
                                    fontSize: 18 * screenWidth / pixelTwoWidth))
                            : Text("Disable Auto-Login",
                                style: TextStyle(
                                    fontFamily: 'Lato',
                                    color: Colors.blue,
                                    fontSize:
                                        18 * screenWidth / pixelTwoWidth)),
                        onPressed: () => setState(
                            () => _desiresAutoLogin = !_desiresAutoLogin),
                      ),
                    ),
                    Padding(
                      padding: new EdgeInsets.all(
                          20.0 * screenHeight / pixelTwoHeight),
                      child: ButtonTheme(
                          minWidth: 150 * screenWidth / pixelTwoWidth,
                          height: screenHeight * 0.07,
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: Container(
                              child: Text(
                                "Login",
                                style: new TextStyle(
                                    fontSize: 20 * screenWidth / pixelTwoWidth,
                                    fontFamily: 'Lato'),
                              ),
                            ),
                            onPressed: () => tryToLogin(),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_isLogginIn)
          Container(
              width: screenWidth * 0.8,
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.23),
                child: CircularProgressIndicator(),
              )),
      ],
    );
  }
}

//Register Template Class
class RegisterTemplate extends StatefulWidget {
  @override
  State<RegisterTemplate> createState() {
    return _RegisterTemplateState();
  }
}

class _RegisterTemplateState extends State<RegisterTemplate> {
  TextEditingController _firstName = new TextEditingController();
  TextEditingController _lastName = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  //String _tier;
  bool _isTryingToRegister = false; //used to give progress bar animation
  bool isNameValid = false;

  final _registrationFormKey = GlobalKey<FormState>();

  Future<String> authenticateUser() async {
    String newUid;
    UserCredential authRes = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: _email.text.trim(), password: _password.text.trim());
    newUid = authRes.user.uid;
    //basic user information
    Map jsonInformation = {
      'auto': true,
      'email': _email.text,
      'password': _password.text,
      //'tier': _tier,
    } as Map;

    //cache results
      if (kIsWeb) {
    // Set web-specific directory
    } else {
    //write to json file
    final appDirectory = await getApplicationDocumentsDirectory();
    final userStorageFile = File(appDirectory.path + "/user.json");
    userStorageFile.writeAsStringSync(
        json.encode(jsonInformation)); //write to fie syncronolys

    //persist useful references like File Pointers
    Global.userDataFile = userStorageFile;
    Global.uid = newUid;
    }
    //create new document with data

    Map<String, dynamic> updatedUserData = {
      "first_name": _firstName.text.trim(),
      "email": _email.text.trim(),
      "last_name": _lastName.text.trim(),
      "num": 0,
      //"tier": _tier.trim(),
      "uid": newUid,
    };

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(newUid)
        .set(updatedUserData, SetOptions(merge: true));
    // //usersMap[fullName] = newUid;

    // await Firestore.instance
    //     .collection("Aggregators")
    //     .document("User")
    //     .updateData({"users": usersMap as Map});

    return "Finished";
  }

  //executes the actual registration
  void executeRegistration() async {
    // //I CAN USE THIS LATER
    // final gsheets = GSheets(gsheetsConfig);
    // final ss = await gsheets.spreadsheet(sheetId);
    // // get worksheet by its title
    // var sheet = ss.worksheetByTitle('Member Sheet');
    // var firstNames = await sheet.values.column(1);
    // var lastNames = await sheet.values.column(2);
    // var tierValues = await sheet.values.column(3);

    // var fIndex = firstNames.indexOf(_firstName.trim());
    // //whether first name exists
    // if (fIndex != -1) {
    //   //checks whether last name given matches last name in database
    //   if (_lastName.trim() == lastNames.elementAt(fIndex)) {
    //     isNameValid = true;
    //     //check whether user may be an admin tier
    //     if (tierValues.elementAt(fIndex).contains("Admin")) {
    //       _tier = tierValues.elementAt(fIndex);
    //       Global.tier = _tier;
    //     }
    //truly authenticate the user to firebase
    await authenticateUser()
        .then((_) /* call back for creating a users document*/ {
      setState(() => _isTryingToRegister = false);

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomeScreen())); //go to profile screen

      //catching invalid email error
    }).catchError((error) {
      setState(() => _isTryingToRegister = false);

      //if email already exists throw an error popup
      if (error.toString().contains("ALREADY")) {
        showDialog(
            context: context,
            builder: (context) {
              return SingleActionPopup(
                  "Email is already in use", "ERROR!", Colors.blue);
            });
      }

      //catch a network timed out error
      if (error.toString().contains("NETWORK")) {
        showDialog(
            context: context,
            builder: (context) {
              return ErrorPopup(
                  "Network timed out, please check your wifi connection", () {
                Navigator.of(context).pop();
                setState(() {
                  _isTryingToRegister = true;
                });
                executeRegistration();
              });
            });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              print(error);
              return ErrorPopup(
                  "Oof. Something went wrong during registration.", () {
                Navigator.of(context).pop();
                setState(() {
                  _isTryingToRegister = true;
                });
                executeRegistration();
              });
            });
      }
    });
    //} old if
    // } else { (SECOND HALF OF THE IF STATEMENT)
    //   showDialog(
    //       context: context,
    //       builder: (context) {
    //         return SingleActionPopup(
    //             "Enter your first and last name correctly.",
    //             "User not Matched",
    //             Colors.blue);
    //       });
    //   setState(() => _isTryingToRegister = false);
    // }
  }

  //handles registration of user
  void tryToRegister() async {
    //checking to make sure multiple attempts at registering doesn't occur
    if (!_isTryingToRegister) {
      setState(() => _isTryingToRegister = true);

      if (_registrationFormKey.currentState
          .validate()) /*check whether form is valid */ {
        executeRegistration();
      } else {
        setState(() => _isTryingToRegister = false);
      }
    }
  }

  Widget build(BuildContext context) {
    double pixelTwoWidth = 411.42857142857144;
    double pixelTwoHeight = 683.4285714285714;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Container(
          width: screenWidth * 0.8,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: screenHeight / 45),
                child: Container(
                    child: Text("Register",
                        style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 32 * screenWidth / pixelTwoWidth))),
              ),
              new Form(
                  key: _registrationFormKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight / 60),
                        child: Container(
                          width: screenWidth * 0.75,
                          child: TextFormField(
                            controller: _firstName,
                            style: new TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 18 * screenWidth / pixelTwoWidth),
                            textAlign: TextAlign.center,
                            decoration:
                                InputDecoration(labelText: "First Name"),
                            validator: (val) {
                              if (val == "") {
                                return "Field is empty";
                              }

                              setState(() => _firstName.text = val);

                              return null;
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth * 0.75,
                        child: TextFormField(
                          controller: _lastName,
                          style: new TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 18 * screenWidth / pixelTwoWidth),
                          textAlign: TextAlign.center,
                          decoration: new InputDecoration(
                            labelText: 'Last Name',
                          ),
                          validator: (val) {
                            if (val == "") {
                              return "Field is empty";
                            }

                            setState(() => _lastName.text = val);
                            return null;
                          },
                        ),
                      ),
                      Container(
                        width: screenWidth * 0.75,
                        child: TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          style: new TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 18 * screenWidth / pixelTwoWidth),
                          validator: (val) {
                            if (val == "") {
                              return "Field is empty";
                            }
                            setState(() {
                              _email.text = val;
                            });

                            //validate email
                            bool dotIsNotIn = _email.text.indexOf(".") == -1;
                            bool atIsNotIn = _email.text.indexOf("@") == -1;

                            if (dotIsNotIn || atIsNotIn) {
                              return "Invalid Email Type";
                            }
                            return null;
                          },
                          textAlign: TextAlign.center,
                          decoration: new InputDecoration(
                            icon: Icon(Icons.mail),
                            labelText: "E-mail",
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth * 0.75,
                        child: TextFormField(
                          controller: _password,
                          style: new TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 18 * screenWidth / pixelTwoWidth),
                          validator: (val) {
                            //validate password
                            if (val == "") {
                              return "Field is empty";
                            }

                            setState(() {
                              _password.text = val;
                            });

                            bool hasLengthLessThan8 = _password.text.length < 8;

                            if (hasLengthLessThan8) {
                              return "Password less than 8";
                            }

                            return null;
                          },
                          textAlign: TextAlign.center,
                          obscureText: true,
                          decoration: new InputDecoration(
                              icon: Icon(Icons.lock), labelText: "Password"),
                        ),
                      ),
                      Padding(
                        padding: new EdgeInsets.all(screenHeight / 45),
                        child: ButtonTheme(
                            minWidth: 150.0,
                            height: screenHeight * 0.07,
                            child: RaisedButton(
                              textColor: Colors.white,
                              color: Colors.blue[600],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Container(
                                child: Text(
                                  "Register",
                                  style: new TextStyle(
                                      fontSize:
                                          20 * screenWidth / pixelTwoWidth,
                                      fontFamily: 'Lato'),
                                ),
                              ),
                              onPressed: () => tryToRegister(),
                            )),
                      )
                    ],
                  )),
            ],
          ),
        ),
        if (_isTryingToRegister) //to add the progress indicator
          Container(
              width: screenWidth * 0.8,
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.27),
                child: CircularProgressIndicator(),
              ))
      ],
    );
  }
}

//settings template
class SettingsTemplate extends StatefulWidget {
  SettingsTemplate({Key key}) : super(key: key);

  @override
  _SettingsTemplateState createState() => _SettingsTemplateState();
}

class _SettingsTemplateState extends State<SettingsTemplate> {
  bool _wantsToChange = false;
  String _firstName = "Guest";
  String _lastName = "Account";
  int _numberOfContributions = 0;
  String _emailAddress = 'guest@gmail.com';

  final TextEditingController _emailController = TextEditingController();

  void getdata() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(Global.uid == null
            ? "Guest Account"
            : FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      setState(() {
        _firstName = value.get("first_name");
        _lastName = value.get("last_name");
        _emailAddress = value.get("email");
        _numberOfContributions = value.get("num");
      });
      //_numberOfContributions = value.get("counter");
    });
  }

  @override
  void initState() {
    super.initState();
    getdata();
    _emailController.addListener(_updateTaskValue);
  }

  void _updateTaskValue() {}

  void updateSettings() {
    setState(() {
      _wantsToChange = true;
    });
  }

  void applySettings() {
    setState(() async {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
      //print(_emailController.text);
      _wantsToChange = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Check your email for a link to reset your password"),
      ));
    });
  }

  Widget build(BuildContext context) {
    //used to set relative sizing based on a pixel 2 phone
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double pixelTwoWidth = 411.42857142857144;
    double pixelTwoHeight = 683.4285714285714;

    final updateButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.blue,
        child: MaterialButton(
          //minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
          onPressed: () {
            updateSettings();
          },
          child: Text(
            "Reset Password",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Lato', fontSize: 20, color: Colors.white),
          ),
        ));

    final applyButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.blue,
        child: MaterialButton(
          //minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
          onPressed: () {
            applySettings();
          },
          child: Text(
            "Submit Request",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Lato', fontSize: 20, color: Colors.white),
          ),
        ));

    return Stack(children: <Widget>[
      Container(
        width: screenWidth * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15 * screenHeight / pixelTwoHeight),
              child: Container(
                child: Text(
                  "Settings",
                  style: new TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 32 * screenWidth / pixelTwoWidth,
                  ),
                ),
              ),
            ),
            SettingsCard(label: "Name: " + _firstName + " " + _lastName + "  "),
            SettingsCard(label: _emailAddress + "  "),
            (_wantsToChange == false)
                ? SettingsCard(
                    label: "Contributions: " +
                        _numberOfContributions.toString() +
                        "  ")
                : Container(),
            (_wantsToChange)
                ? SettingsField(
                    label: "  Enter Email Address of Account",
                    controller: _emailController,
                  )
                : Container(),
            Padding(
              padding: new EdgeInsets.all(15),
              child: (_wantsToChange) ? applyButton : updateButton,
            ),
          ],
        ),
      ),
    ]);
  }
}

class SettingsField extends StatefulWidget {
  String label; // label text for textfield
  TextEditingController controller;
  SettingsField({Key key, this.label, this.controller}) : super(key: key);

  _SettingsFieldState createState() => _SettingsFieldState();
}

class _SettingsFieldState extends State<SettingsField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 15, left: 10.0, right: 10.0),
        child: TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: TextStyle(fontFamily: 'Lato', fontSize: 18),
          ),
        ));
  }
}

class SettingsCard extends StatefulWidget {
  @override
  String label; // label text for textfield

  SettingsCard({Key key, this.label}) : super(key: key);

  _SettingsCardState createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15, left: 10.0, right: 10.0),
      child: Card(
          child: ListTile(
        leading: Icon(Icons.circle, color: Colors.blueAccent),
        title: Text(
          widget.label,
          textAlign: TextAlign.left,
          style: new TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
        ),
      )),
    );
  }
}

//map legend
class MapLegend extends StatefulWidget {
  MapLegend();

  @override
  State<MapLegend> createState() {
    return _MapLegendState();
  }
}

class _MapLegendState extends State<MapLegend> {
  Widget build(BuildContext context) {
    //used to set relative sizing based on a pixel 2 phone
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double pixelTwoWidth = 411.42857142857144;
    double pixelTwoHeight = 683.4285714285714;

    return Stack(children: <Widget>[
      SizedBox(
        width: screenWidth * 0.75,
        height: screenHeight * 0.4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                "Map Legend",
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  fontSize: 25 * screenWidth / pixelTwoWidth,
                ),
              ),
            ),
            //Spacer(flex: 1),
            Padding(
              padding: EdgeInsets.only(top: 15 * screenHeight / pixelTwoHeight),
              child: Container(
                  height: screenHeight * 0.30,
                  //width: screenWidth * 0.95,
                  child: ListView(
                    children: <Widget>[
                      Card(
                          child: ListTile(
                        leading: Icon(Icons.pin_drop, color: Colors.green),
                        title: Text('Green Marker: Passive Animals (Herbivores)',
                            textAlign: TextAlign.left,
                            style: new TextStyle(
                                fontFamily: "Montserrat",
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 20 * screenWidth / pixelTwoWidth)),
                      )),
                      Card(
                          child: ListTile(
                        leading:
                            Icon(Icons.pin_drop, color: Colors.yellow[700]),
                        title: Text('Yellow Marker: Medium (Omnivores)',
                            textAlign: TextAlign.left,
                            style: new TextStyle(
                                fontFamily: "Montserrat",
                                color: Colors.yellow[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 20 * screenWidth / pixelTwoWidth)),
                      )),
                      Card(
                          child: ListTile(
                        leading: Icon(Icons.pin_drop, color: Colors.red),
                        title: Text('Red Marker: Harmful Animals (Carnivores)',
                            textAlign: TextAlign.left,
                            style: new TextStyle(
                                fontFamily: "Montserrat",
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 20 * screenWidth / pixelTwoWidth)),
                      )),
                    ],
                  )),
            ),
            //Spacer(flex: 1),
          ],
        ),
      ),
    ]);
  }
}

//location google map
class LocatorMap extends StatefulWidget {
  int docid;
  LatLng center;

  LocatorMap({Key key, this.center, this.docid}) : super(key: key);

  @override
  _LocatorMapState createState() => _LocatorMapState();
}

class _LocatorMapState extends State<LocatorMap> {
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('0'),
          position: widget.center,
          infoWindow: InfoWindow(title: 'Current Location'),
          //icon: _markerIcon,
        ),
      );
    });
  }

  Set<Marker> _markers = HashSet<Marker>();

  void _setMarkers(LatLng point) {
    setState(() {
      print(
          'Marker | Latitude: ${point.latitude}  Longitude: ${point.longitude}');
      _markers.add(
        Marker(
          markerId: MarkerId("location_Of_Problem"),
          position: point,
          draggable: false,
          infoWindow: InfoWindow(title: 'Location'),
        ),
      );
    });
    FirebaseFirestore.instance
        .collection("Formdata")
        .doc("Response_" + widget.docid.toString())
        .set({'latitude_of_location': point.latitude}, SetOptions(merge: true));
    FirebaseFirestore.instance
        .collection("Formdata")
        .doc("Response_" + widget.docid.toString())
        .set({'longitude_of_location': point.longitude},
            SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        SearchMapPlaceWidget(
          hasClearButton: true,
          placeType: PlaceType.address,
          placeholder: 'Search Address...',
          apiKey: 'AIzaSyCx8c54DRESgvG8LyTGYc4ACQmukde1lo0',
          onSelected: (Place place) async {
            Geolocation geolocation = await place.geolocation;
            mapController
                .animateCamera(CameraUpdate.newLatLng(geolocation.coordinates));
            setState(() {
              _markers.clear();
              _setMarkers(geolocation.coordinates);
              widget.center = geolocation.coordinates;
            });
            mapController.animateCamera(
                CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
          },
        ),
        Container(
          width: screenWidth * 0.95,
          decoration: BoxDecoration(
            color: Colors.lightBlue,
          ),
          child: Text(
            " Latitude: " +
                widget.center.latitude.toStringAsFixed(3) +
                " , Longitude: " +
                widget.center.longitude.toStringAsFixed(3),
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Container(
          height: screenHeight * 0.38,
          child: GoogleMap(
            mapType: MapType.hybrid,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: widget.center,
              zoom: 16.0,
            ),
            markers: _markers,
            onTap: (point) {
              setState(() {
                _markers.clear();
                _setMarkers(point);
                widget.center = point;
              });
            },
          ),
        ),
      ],
    );
  }
}
