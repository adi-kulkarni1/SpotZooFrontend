import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CurvedPopup extends StatefulWidget {
  @override
  Widget child; // child widget within popup
  Function removePopup; // function that is called when popup is unfocused

  CurvedPopup({Key key, this.child, this.removePopup}) : super(key: key);

  _CurvedPopupState createState() => _CurvedPopupState();
}

class _CurvedPopupState extends State<CurvedPopup> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(children: [
      GestureDetector(
        child: Container(
          color: Colors.black45,
          width: screenWidth,
          height: screenHeight,
        ),
        onTap: () {
          setState(() {
            FocusScope.of(context).requestFocus(FocusNode());
            widget.removePopup();
          });
        },
      ),
      Container(
        child: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: GestureDetector(
              child: Container(
                child: widget.child,
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
    ]);
  }
}
