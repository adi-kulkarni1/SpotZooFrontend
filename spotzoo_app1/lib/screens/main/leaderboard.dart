//import 'dart:html';
import 'package:flutter/material.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {

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
            "Current Leaderboard Standings",
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
                  leading: Icon(Icons.leaderboard, color: Colors.blue),
                  title: Text('Coming Soon...',
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20 * screenWidth / pixelTwoWidth)),
                  subtitle: Text(
                    'Development in progress',
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
