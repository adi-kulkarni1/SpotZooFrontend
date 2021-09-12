//import 'dart:html';
import 'package:flutter/material.dart';

class AlertNotif extends StatefulWidget {
  @override
  _AlertNotifState createState() => _AlertNotifState();
}

class _AlertNotifState extends State<AlertNotif> {
  @override
  void initState() {
    super.initState();
  }

  TextStyle style = TextStyle(
      fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black54);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double pixelTwoWidth = 411.42857142857144;
    double pixelTwoHeight = 683.4285714285714;

    return Center(
        child: Column(
      children: <Widget>[
        Container(
          padding: new EdgeInsets.fromLTRB(screenWidth / 20, screenHeight / 40,
              screenWidth / 20, screenHeight / 80),
          width: double.infinity,
          child: Text(
            "Current Alerts in Your Area",
            textAlign: TextAlign.center,
            style: new TextStyle(
                fontSize: 26 * screenWidth / pixelTwoWidth,
                fontFamily: 'Lato-Regular'),
          ),
        ),
        Container(
            height: screenHeight * 0.59,
            width: screenWidth * 0.95,
            child: ListView(
              children: <Widget>[
                Card(
                    child: ListTile(
                  leading: Icon(Icons.warning, color: Colors.red),
                  title: Text('Lion: High Risk',
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20 * screenWidth / pixelTwoWidth)),
                  subtitle: Text(
                    'Spotted 3 hours ago',
                    style:
                        TextStyle(fontSize: 16 * screenWidth / pixelTwoWidth),
                  ),
                  onTap: () => {},
                )),
                Card(
                    child: ListTile(
                  leading: Icon(Icons.warning, color: Colors.red),
                  title: Text('Crocodile: High Risk',
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20 * screenWidth / pixelTwoWidth)),
                  subtitle: Text(
                    'Spotted 4 hours ago',
                    style:
                        TextStyle(fontSize: 16 * screenWidth / pixelTwoWidth),
                  ),
                  onTap: () => {},
                )),
                Card(
                    child: ListTile(
                  leading: Icon(Icons.warning, color: Colors.yellow),
                  title: Text('Monkey: Medium Risk',
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20 * screenWidth / pixelTwoWidth)),
                  subtitle: Text(
                    'Spotted 5 hours ago',
                    style:
                        TextStyle(fontSize: 16 * screenWidth / pixelTwoWidth),
                  ),
                  onTap: () => {},
                )),
                Card(
                    child: ListTile(
                  leading: Icon(Icons.warning, color: Colors.green),
                  title: Text('Cat: Low Risk',
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20 * screenWidth / pixelTwoWidth)),
                  subtitle: Text(
                    'Spotted 2 hours ago',
                    style:
                        TextStyle(fontSize: 16 * screenWidth / pixelTwoWidth),
                  ),
                  onTap: () => {},
                )),
                Container(
                  padding: new EdgeInsets.fromLTRB(screenWidth / 20,
                      screenHeight / 40, screenWidth / 20, screenHeight / 80),
                  width: double.infinity,
                  child: Text(
                    "Past Alerts in Your Area",
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        fontSize: 26 * screenWidth / pixelTwoWidth,
                        fontFamily: 'Lato-Regular'),
                  ),
                ),
                Card(
                    child: ListTile(
                  leading: Icon(Icons.warning, color: Colors.green),
                  title: Text('Sheep: Low Risk',
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20 * screenWidth / pixelTwoWidth)),
                  subtitle: Text(
                    'Spotted 24 hours ago',
                    style:
                        TextStyle(fontSize: 16 * screenWidth / pixelTwoWidth),
                  ),
                  onTap: () => {},
                )),
              ],
            )),
      ],
    ));
  }
}
