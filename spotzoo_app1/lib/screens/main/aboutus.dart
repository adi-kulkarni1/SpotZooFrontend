import 'dart:collection';
//import 'dart:html';

import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
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
            "About Me and Contact Information",
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
                  leading: Icon(Icons.person, color: Colors.blue),
                  title: Text('Adi Kulkarni',
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20 * screenWidth / pixelTwoWidth)),
                  subtitle: Text(
                    'Hi, I am a high schooler with a passion for solving Minnesota\'s problems with my computer science skills. ',
                    style:
                        TextStyle(fontSize: 16 * screenWidth / pixelTwoWidth),
                  ),
                  onTap: () => {},
                )),
                Card(
                    child: ListTile(
                  leading: Icon(Icons.report_problem_rounded, color: Colors.blue),
                  title: Text('The Problem',
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20 * screenWidth / pixelTwoWidth)),
                  subtitle: Text(
                    'Large amounts of snow have been left on roads for weeks without cleaning by snowplows',
                    style:
                        TextStyle(fontSize: 16 * screenWidth / pixelTwoWidth),
                  ),
                  onTap: () => {},
                )),
                Card(
                    child: ListTile(
                  leading: Icon(Icons.track_changes, color: Colors.blue),
                  title: Text('Project Goal',
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20 * screenWidth / pixelTwoWidth)),
                  subtitle: Text(
                    'The goal of this project was to develop an app for the public so they could report the amount of snow on their nearby roads if there has not yet been a snowplow to clear the snow. This information would then be used to notify MnDOT about roads covered with signficant snowfall and the amount of people affected. Then, Snowplows would be sent to address these roads.',
                    style:
                        TextStyle(fontSize: 16 * screenWidth / pixelTwoWidth),
                  ),
                  onTap: () => {},
                )),
                Card(
                    child: ListTile(
                  leading: Icon(Icons.contact_mail, color: Colors.blue),
                  title: Text('Contact',
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20 * screenWidth / pixelTwoWidth)),
                  subtitle: Text(
                    'Email: adikul117@gmail.com\nGitHub: adi-kulkarni1',
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
