// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:camera/camera.dart';
// import 'package:path/path.dart' show join;
// import 'package:path_provider/path_provider.dart';

// class TakePictureScreen extends StatefulWidget {
//   @override
//   TakePictureScreenState createState() => TakePictureScreenState();
// }

// class TakePictureScreenState extends State<TakePictureScreen> {
//   File _image;
//   final picker = ImagePicker();

//   Future getImage() async {
//     final pickedFile = await picker.getImage(source: ImageSource.camera);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }



//   @override
//   Widget build(BuildContext context) {

//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     return Stack(
//       children: <Widget>[
//         Material(
//       elevation: 5.0,
//       borderRadius: BorderRadius.circular(30.0),
//       color: Colors.grey,
//       child: MaterialButton(
//         padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
//         onPressed: getImage,
//         child: Row(
//           children: <Widget>[
//             Icon(Icons.add_a_photo),
//             Text("Take a Picture")
//           ],
//           )
//         ),
//       ),
//         Center(
//           child:
//               _image == null ? Text('No image selected.') : SizedBox(height: screenHeight * 0.28, width: screenWidth * 0.9, child: Image.file(_image)),
//         ),
//       ],
//     );
//   }
// }
