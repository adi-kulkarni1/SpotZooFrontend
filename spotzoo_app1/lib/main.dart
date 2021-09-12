import 'package:flutter/material.dart';
import 'package:spotzoo_app1/screens/authentication/authentication_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //removes the red debug banner
      title: 'SpotZoo',
      home: AnimatedSplashScreen(
        duration: 2000,
        splash: FlutterIcons.magnifying_glass_ent,
        nextScreen: AuthScreen(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.lightGreen[700],
      ),
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        accentColor: Colors.black38,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Montserrat',
      ),
    );
  }
}
