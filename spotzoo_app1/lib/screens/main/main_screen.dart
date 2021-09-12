//import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:spotzoo_app1/screens/authentication/authentication_screen.dart';
import 'package:spotzoo_app1/screens/main/aboutus.dart';
import 'package:spotzoo_app1/screens/main/alertnotif.dart';
import 'package:spotzoo_app1/screens/main/homeui.dart';
import 'package:spotzoo_app1/screens/main/leaderboard.dart';
import 'package:spotzoo_app1/screens/main/templates.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isSettingsButtonClicked = false;
  int docid;

  void openSettingsTemplate() {
    setState(() {
      _isSettingsButtonClicked = true;
    });
  }

  void indexHome() {
    setState(() {
      _selectedIndex = 0;
    });
  }

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

  Widget changeUI(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return HomeUI();
      case 1:
        return AlertNotif();
        break;
      case 2:
        return Leaderboard();
    }
  }

  @override
  void initState() {
    super.initState();
    getdocid();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset:
          false, //important for overlapping, could be reason for future error tho..
      //resizeToAvoidBottomPadding: REMOVED FOR WEB DEV
      //    false, //important for overlapping, could be reason for future error tho..
      appBar: new AppBar(
        centerTitle: true,
        title: Text((_selectedIndex == 0)
            ? "Map of All Animal Sightings"
            : (_selectedIndex == 1)
                ? "Alerts"
                : (_selectedIndex == 2)
                    ? "Leaderboard"
                    : "About"),
        leading: (_selectedIndex == 0)
            ? IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  openSettingsTemplate();
                })
            : (_selectedIndex == 1)
                ? IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      indexHome();
                    })
                : IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      indexHome();
                    }),
        actions: <Widget>[
          (_selectedIndex == 0)
              ? PopupMenuButton(
                  color: Colors.blue,
                  itemBuilder: (context) => [
                        // PopupMenuItem(
                        //     child: Container(
                        //         alignment: Alignment.center,
                        //         child: IconButton(
                        //           icon: Icon(Icons.help),
                        //           onPressed: () {
                        //             Navigator.pop(context);
                        //             //add help popup button
                        //           },
                        //         ))),
                        PopupMenuItem(
                            child: Container(
                                alignment: Alignment.center,
                                child: IconButton(
                                  icon: Icon(Icons.logout),
                                  onPressed: () async {
                                    final User user =
                                        FirebaseAuth.instance.currentUser;
                                    // if (user == null) {
                                    //   Scaffold.of(context)
                                    //       .showSnackBar(const SnackBar(
                                    //     content: Text('No one has signed in.'),
                                    //   ));
                                    //   return;
                                    // }
                                    await FirebaseAuth.instance.signOut();
                                    final String uid = user.uid;
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(uid +
                                          ' has successfully signed out.'),
                                    ));
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new AuthScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  //Navigator.pop(context);
                                  //fix to make it work better
                                ))),
                      ],
                  offset: Offset(0, 0))
              : (_selectedIndex == 1)
                  ? IconButton(
                icon: Icon(FlutterIcons.alert_circle_mco),
                onPressed: () {
                  openSettingsTemplate();
                })
                  : Container()
        ],
      ),
      body: Stack(
        children: <Widget>[
          changeUI(_selectedIndex),
          if (_isSettingsButtonClicked)
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
                      _isSettingsButtonClicked = false;
                    });
                  },
                ),
                Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: GestureDetector(
                        child: Container(
                          child: SettingsTemplate(),
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
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        backgroundColor: Colors.white,
        animationDuration: Duration(milliseconds: 500),
        color: Colors.black,
        buttonBackgroundColor: Colors.red,
        height: 50,
        items: <Widget>[
          Icon(Icons.map,
              size: 30), //add map legend and settings buttons to the top
          Icon(FlutterIcons.alert_triangle_fea,
              size: 30), //top left/right to change alert radius
          Icon(Icons.group, size: 30), //leaderboard
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
