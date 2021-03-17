import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class MachineLearningPage extends StatefulWidget {
  final image;

  MachineLearningPage(this.image);

  @override
  _MachineLearningPageState createState() => _MachineLearningPageState();
}

class _MachineLearningPageState extends State<MachineLearningPage> {
  List<Face> faces;

  // 사각형 그리는 용도
  List<Rect> rectArr = new List();
  ui.Image image;

  List<ImageLabel> labels;
  VisionText visionText;
  var result;

  FaceDetector faceDetector;
  TextRecognizer recognizer;
  ImageLabeler labeler;

  double rotY;
  double rotZ;

  String imageLabelResult;
  String text;
  String entityId;
  double confidence;

  var myStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();

    setState(() {
      performFaceDetecting();
      // Future.delayed(Duration(seconds: 4));
      performTextDetecting();
      // Future.delayed(Duration(seconds: 4));
      performImageLabeling();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text('ML Vision',
                style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 35,
                    fontWeight: FontWeight.bold)),
            backgroundColor: Colors.white,
            elevation: 0.0,
            leading: Container(),
            bottom: TabBar(
              indicatorColor: Colors.indigo,
              labelColor: Colors.indigo,
              indicatorWeight: 5,
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.face),
                  text: 'Face',
                ),
                Tab(icon: Icon(Icons.text_fields), text: 'Text'),
                Tab(icon: Icon(Icons.find_in_page), text: 'Label'),
//                  Tab(icon: Icon(Icons.more_horiz), text: 'More'),
              ],
            )),
        body: TabBarView(children: <Widget>[
          faceTabPage(),
          textTabPage(),
          imageLabelTabPage(),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pop(context),
          backgroundColor: Colors.indigo,
          child: Icon(Icons.keyboard_return_outlined, color: Colors.white, )
        ),
      ),
    );
  }

  faceTabPage() {
    return Container(
        child: Column(
      children: [
        Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: TextButton(
                onPressed: () {
                  // pickImageFromGallery();
                },
                onLongPress: () {
                  // captureImageWithCamera();
                },
                child: widget.image != null
                    ? Stack(children: [
                        Image.file(widget.image, fit: BoxFit.cover),
                        FittedBox(
                          child: SizedBox(
                            height: image == null
                                ? MediaQuery.of(context).size.height
                                : image.height.toDouble(),
                            width: image == null
                                ? MediaQuery.of(context).size.width
                                : image.width.toDouble(),
                            child: CustomPaint(
                              painter: Painter(rectArr, image),
                            ),
                          ),
                        ),
                      ])
                    : Container(
                        child: Icon(
                        Icons.camera_front,
                        size: 100,
                        color: Colors.grey,
                      ))),
          ),
        ),
        SizedBox(height: 3),
        Divider(),
        SizedBox(height: 3),
        faces == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                shrinkWrap: true,
                itemCount: faces.length,
                itemBuilder: (context, index) {
                  final Rect boundingBox = faces[index].boundingBox;

                  print('>>>>>> boundingBox : $boundingBox');

                  rotY = faces[index]
                      .headEulerAngleY; // Head is rotated to the right rotY degrees
                  rotZ = faces[index]
                      .headEulerAngleZ; // Head is tilted sideways rotZ degrees

                  print('>>>>>> rotY : $rotY');
                  print('>>>>>> rotZ : $rotZ');
                  // If landmark detection was enabled with FaceDetectorOptions (mouth, ears,
                  // eyes, cheeks, and nose available):
                  final FaceLandmark leftEar =
                      faces[index].getLandmark(FaceLandmarkType.leftEar);
                  if (leftEar != null) {
                    final Offset leftEarPos = leftEar.position;
                    print('>>>>>> leftEarPos : $leftEarPos');
                  }

                  // If classification was enabled with FaceDetectorOptions:
                  if (faces[index].smilingProbability != null) {
                    final double smileProb = faces[index].smilingProbability;
                    print('>>>>>> smileProb : $smileProb');
                  }

                  // If face tracking was enabled with FaceDetectorOptions:
                  if (faces[index].trackingId != null) {
                    final int id = faces[index].trackingId;
                    print('>>>>>> id : $id');
                  }
                  return Column(
                    children: [
                      Text('rotY : $rotY', style: myStyle),
                      Text('rotZ : $rotZ', style: myStyle),
                    ],
                  );
                })
      ],
    ));
  }

  textTabPage() {
    return Container(
        child: ListView(
      children: [
        Center(
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.4,
            child: TextButton(
                onPressed: () {
                  // pickImageFromGallery();
                },
                onLongPress: () {
                  // captureImageWithCamera();
                },
                child: widget.image != null
                    ? Image.file(widget.image, fit: BoxFit.cover)
                    : Container(
                        child: Icon(
                        Icons.camera_front,
                        size: 100,
                        color: Colors.grey,
                      ))),
          ),
        ),
        SizedBox(height: 3),
        Divider(),
        SizedBox(height: 3),
        result == null
            ? Center(child: CircularProgressIndicator())
            : Center(child: Text(result, style: myStyle)),
        SizedBox(height: 10),
      ],
    ));
  }

  imageLabelTabPage() {
    return Container(
      child: ListView(children: [
        Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: TextButton(
                onPressed: () {
                  // pickImageFromGallery();
                },
                onLongPress: () {
                  // captureImageWithCamera();
                },
                child: widget.image != null
                    ? Image.file(widget.image, fit: BoxFit.cover)
                    : Container(
                        child: Icon(
                        Icons.camera_front,
                        size: 100,
                        color: Colors.grey,
                      ))),
          ),
        ),
        SizedBox(height: 3),
        Divider(),
        SizedBox(height: 3),
        labels == null
            ? Center(child: CircularProgressIndicator())
            : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(child: Text(imageLabelResult, style: myStyle))
              ]),
        SizedBox(height: 10),
      ]),
    );
  }

  performFaceDetecting() async {
    final FirebaseVisionImage firebaseVisionImage =
        FirebaseVisionImage.fromFile(widget.image);

    FaceDetector faceDetector = FirebaseVision.instance.faceDetector();

    faces = await faceDetector.processImage(firebaseVisionImage);

    rectArr.clear();
    for (Face face in faces) {
      final Rect boundingBox = face.boundingBox;
      rectArr.add(face.boundingBox);
      print('>>>>>> boundingBox : $boundingBox');

      final double rotY =
          face.headEulerAngleY; // Head is rotated to the right rotY degrees
      final double rotZ =
          face.headEulerAngleZ; // Head is tilted sideways rotZ degrees

      print('>>>>>> rotY : $rotY');
      print('>>>>>> rotZ : $rotZ');
      // If landmark detection was enabled with FaceDetectorOptions (mouth, ears,
      // eyes, cheeks, and nose available):
      final FaceLandmark leftEar = face.getLandmark(FaceLandmarkType.leftEar);
      if (leftEar != null) {
        final Offset leftEarPos = leftEar.position;
        print('>>>>>> leftEarPos : $leftEarPos');
      }

      // If classification was enabled with FaceDetectorOptions:
      if (face.smilingProbability != null) {
        final double smileProb = face.smilingProbability;
        print('>>>>>> smileProb : $smileProb');
      }

      // If face tracking was enabled with FaceDetectorOptions:
      if (face.trackingId != null) {
        final int id = face.trackingId;
        print('>>>>>> id : $id');
      }
    }

    // 사각형 그리는 용도
    var bytesFromImageFile = widget.image.readAsBytesSync();
    decodeImageFromList(bytesFromImageFile).then((img) {
      setState(() {
        image = img;
      });
    });

    faceDetector.close();
  }

  performImageLabeling() async {
    final FirebaseVisionImage firebaseVisionImage =
        FirebaseVisionImage.fromFile(widget.image);

    ImageLabeler labeler = FirebaseVision.instance.imageLabeler();

    labels = await labeler.processImage(firebaseVisionImage);

    setState(() {
      imageLabelResult = "";
      for (ImageLabel label in labels) {
        final String text = label.text;
        final String entityId = label.entityId;
        final double confidence = label.confidence;

        imageLabelResult +=
            '$text : ${(confidence * 100).toString().substring(0, 4)}%\n';
      }
    });

    labeler.close();
  }

  performTextDetecting() async {
    final FirebaseVisionImage firebaseVisionImage =
        FirebaseVisionImage.fromFile(widget.image);

    recognizer = FirebaseVision.instance.textRecognizer();

    VisionText visionText = await recognizer.processImage(firebaseVisionImage);

    result = "";

    setState(() {
      for (TextBlock block in visionText.blocks) {
        final String text = block.text;

        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            result += '${element.text} ';
          }
        }

        result += '\n';
      }
    });

    recognizer.close();
  }
}

class Painter extends CustomPainter {
  Painter(@required this.rect, @required this.image);

  final List<Rect> rect;
  ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.redAccent.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30;

    if (image != null) {
      canvas.drawImage(image, Offset.zero, paint);
    }
    for (var i = 0; i <= rect.length - 1; i++) {
      canvas.drawRect(rect[i], paint);
    }
  }

  @override
  bool shouldRepaint(oldDelegate) {
    return true;
  }
}
