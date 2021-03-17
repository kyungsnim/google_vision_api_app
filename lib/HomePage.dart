import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'MachineLearningPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = "";
  File image;
  Future<File> imageFile;
  ImagePicker imagePicker;


  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
                title: Text('ML Vision', style: TextStyle(color: Colors.indigo, fontSize: 35, fontWeight: FontWeight.bold)),
                backgroundColor: Colors.white,
                elevation: 0.0,
                leading: Container(),
                ),
            body: Container(
              child: Center(
                child: InkWell(
                    onTap: () async {
                      PickedFile pickedFile = await imagePicker.getImage(source: ImageSource.camera);

                      image = File(pickedFile.path);

                      Navigator.push(context, MaterialPageRoute(builder: (context) => MachineLearningPage(image)));
                    },
                    child: Icon(Icons.camera_enhance_rounded, size: 50,))
              )
            )
        ),
      ),
    );
  }


}

