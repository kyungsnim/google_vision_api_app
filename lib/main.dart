import 'package:flutter/material.dart';

import 'HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

// import 'dart:io';
// import 'dart:ui' as ui;
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// //import 'faceDetection.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: FaceDetect(),
//       theme: ThemeData.dark(),
//     );
//   }
// }
//
// class FaceDetect extends StatefulWidget {
//   @override
//   _FaceDetectState createState() => _FaceDetectState();
// }
//
// class _FaceDetectState extends State<FaceDetect> {
//   ui.Image image;
//   List<Rect> rectArr = new List();
//
//   Future getImage() async {
//     File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
//     print("image file type ${imageFile.runtimeType}");
//     FirebaseVisionImage fbVisionImage = FirebaseVisionImage.fromFile(imageFile);
//     FaceDetector faceDetector = FirebaseVision.instance.faceDetector();
//     List<Face> listOfFaces = await faceDetector.processImage(fbVisionImage);
//     rectArr.clear();
//     for (Face face in listOfFaces) {
//       rectArr.add(face.boundingBox);
//     }
//     var bytesFromImageFile = imageFile.readAsBytesSync();
//     decodeImageFromList(bytesFromImageFile).then((img) {
//       setState(() {
//         image = img;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Flutter Face Detection in Images"),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           getImage();
//         },
//         child: Icon(Icons.camera_alt),
//
//       ),
//       body: Container(
//         child: Center(
//           child: FittedBox(
//             child: SizedBox(
//               height: image == null ? height : image.height.toDouble(),
//               width: image == null ? width : image.width.toDouble(),
//               child: CustomPaint(
//                 painter: Painter(rectArr, image),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
// }
//
// class Painter extends CustomPainter {
//   Painter(@required this.rect, @required this.image);
//
//   final List<Rect> rect;
//   ui.Image image;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     var paint = Paint()
//       ..color = Colors.red
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 7;
//
//     if (image != null) {
//       canvas.drawImage(image, Offset.zero, paint);
//     }
//     for (var i = 0; i <= rect.length - 1; i++) {
//       canvas.drawRect(rect[i], paint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(oldDelegate) {
//     return true;
//   }
// }