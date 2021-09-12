// ignore: avoid_web_libraries_in_flutter
//import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spotzoo_app1/screens/main/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotzoo_app1/screens/main/templates.dart';
import 'package:spotzoo_app1/utility/util_widgets.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isTryingToLoad = false;

//with popups auth
  final _loginFormKey = GlobalKey<FormState>();

  bool _isLoginButtonClicked = false;
  bool _isRegisterButtonClicked = false;

  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  bool _desiresAutoLogin = false;
  bool _isLogginIn = false;
  bool isAdmin = false;

  TextStyle style =
      TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black);

  void createNewLoginTemplate() {
    setState(() {
      _isLoginButtonClicked = true;
      _isRegisterButtonClicked = false;
    });
  }

  void createNewRegisterTemplate() {
    setState(() {
      _isRegisterButtonClicked = true;
      _isLoginButtonClicked = false;
    });
  }

  void loadingHome() async {
    setState(() {
      _isTryingToLoad = true;
    });
    UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
    setState(() {
      _isTryingToLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final guestLoginButton = Material(
        textStyle: style,
        elevation: 5.0,
        borderRadius: BorderRadius.circular(15.0),
        color: const Color(0xFFa1e2e7),
        child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
            child: Text(
              "Guest Sign In",
              textAlign: TextAlign.center,
              style: style,
            ),
            onPressed: () {
              setState(() {
                loadingHome();
              });
            }));

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15.0),
      color: const Color(0xFFa1e2e7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
        onPressed: createNewLoginTemplate,
        child: Text("Sign In",
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black),
            ),
      ),
    );

    final signupButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15.0),
      color: const Color(0xFFa1e2e7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
        onPressed: createNewRegisterTemplate,
        child: Text("Sign Up",
            textAlign: TextAlign.center,
            style: style,
      ),
    ));

    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/spotzoo_screen.png"), 
                fit: BoxFit.cover)),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Center(
                    child: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          flex: 3,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Spacer(flex: 1),
                                Spacer(flex: 1),
                                Spacer(flex: 1),
                                Spacer(flex: 1),
                                Spacer(flex: 1),
                                Spacer(flex: 1),
                                Spacer(flex: 1),
                                Spacer(flex: 1),
                                Spacer(flex: 1),
                                Spacer(flex: 1),
                                Spacer(flex: 1),
                                Spacer(flex: 1),
                                Spacer(flex: 1),
                                Text(
                                  "SpotZoo",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Spacer(flex: 1),
                                Spacer(flex: 1),
                                Spacer(flex: 1),
                                // Form(
                                //     key: _formKey,
                                //     child: Column(
                                //       children: <Widget>[
                                //         Padding(
                                //           padding: EdgeInsets.only(
                                //               top: 15.0,
                                //               right: 30.0,
                                //               left: 30.0),
                                //           child: SizedBox(child: emailField),
                                //         ),
                                //         Padding(
                                //           padding: EdgeInsets.only(
                                //               top: 15.0,
                                //               right: 30.0,
                                //               left: 30.0),
                                //           child: SizedBox(child: passwordField),
                                //         ),
                                //       ],
                                //     )),
                              ]),
                        ),
                        Flexible(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 15.0, right: 30.0, left: 30.0),
                                child: SizedBox(
                                  child: loginButton,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 15.0, right: 30.0, left: 30.0),
                                child: SizedBox(
                                  child: signupButton,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 15.0,
                                    right: 55.0,
                                    left: 55.0,
                                    bottom: 0.0),
                                child: SizedBox(
                                  child: guestLoginButton,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                )),
              ),
              if (_isLoginButtonClicked)
                CurvedPopup(
                    child: new LoginTemplate(),
                    removePopup: () => setState(() {
                          _isLoginButtonClicked = false;
                        })),
              if (_isRegisterButtonClicked)
                CurvedPopup(
                    child: new RegisterTemplate(),
                    removePopup: () => setState(() {
                          _isRegisterButtonClicked = false;
                        })),
              if (_isTryingToLoad) //to add the progress indicator
                Stack(
                  children: [
                    GestureDetector(
                        child: Container(
                      color: Colors.black45,
                      width: screenWidth,
                      height: screenHeight,
                    )),
                    Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          child: GestureDetector(
                            child: Stack(
                              children: [
                                Text(
                                  "Loading... Please Wait",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                LinearProgressIndicator(),
                              ],
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
        ));
  }
}
