// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class MLTestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MLTestPageState();
  }
}

class _MLTestPageState extends State<MLTestPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  File _loadedImage;

  Future<File> _cropImage(File image) async {
    File croppedFile;
    if (image.path != null) {
      croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        ratioX: 1.0,
        ratioY: 1.0,
        maxWidth: 512,
        maxHeight: 512,
      );
    } else {
      croppedFile = image;
    }
    return croppedFile;
  }

  Future<File> _openCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    return image;
    return _cropImage(image);
  }

  Future<File> _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    return image;
    return _cropImage(image);
  }

  void _vision(String type) async {
    print("Opening image");
    File f;
    if (type == 'g') {
      print("from gallery");
      f = await _openGallery();
    } else {
      print("from camera");
      f = await _openCamera();
    }
    setState(() {
      _loadedImage = f;
    });
    print("Creating firebaseVisionImage");
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(f);

    print("Createing faceDetector");
    final FaceDetector faceDetector = FirebaseVision.instance.faceDetector();

    print("Getting faces");
    final List<Face> faces = await faceDetector.processImage(visionImage);

    print("Faceces length ${faces.length}");
    for (Face face in faces) {
      print("listing face[]");

      final Rect boundingBox = face.boundingBox;

      print("boundingBox: $boundingBox");

      final double rotY = face.headEulerAngleY; // Head is rotated to the right rotY degrees
      final double rotZ = face.headEulerAngleZ; // Head is tilted sideways rotZ degrees

      // If landmark detection was enabled with FaceDetectorOptions (mouth, ears,
      // eyes, cheeks, and nose available):
      final FaceLandmark leftEar = face.getLandmark(FaceLandmarkType.leftEar);
      if (leftEar != null) {
        final Offset leftEarPos = leftEar.position;
      }

      // If classification was enabled with FaceDetectorOptions:
      if (face.smilingProbability != null) {
        final double smileProb = face.smilingProbability;
      }

      // If face tracking was enabled with FaceDetectorOptions:
      if (face.trackingId != null) {
        final int id = face.trackingId;
      }
    }
    showDialog(context: context, barrierDismissible: false, child: Text("Found ${faces.length} faces"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("ML-Test Page"),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            padding: EdgeInsets.all(40),
            children: <Widget>[
              _loadedImage != null ? Image.file(_loadedImage) : Container(child: Center(child: Text("Load image first"))),
              SizedBox(height: 30),
              RaisedButton(
                onPressed: () => _vision('c'),
                child: Text("Vision From Camera"),
              ),
              SizedBox(height: 30),
              RaisedButton(
                onPressed: () => _vision('g'),
                child: Text("Vision From Gallery"),
              )
            ],
          )
        ],
      ),
    );
  }
}
