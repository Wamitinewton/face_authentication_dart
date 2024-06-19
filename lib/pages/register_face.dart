import 'package:face_auth/common/extensions/size_extensions.dart';
import 'package:face_auth/common/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class RegisterFaceScreen extends StatefulWidget {
  const RegisterFaceScreen({super.key});

  @override
  State<RegisterFaceScreen> createState() => _RegisterFaceScreenState();
}

class _RegisterFaceScreenState extends State<RegisterFaceScreen> {
  final FaceDetector _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
          enableClassification: true,
          enableLandmarks: true,
          enableContours: true,
          enableTracking: true,
          performanceMode: FaceDetectorMode.accurate));

          String? _image;
          FaceFeatures? _faceFeatures;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kOffBlack,
        title: const Text(
          "Register User",
          style: TextStyle(color: kLynxWhite),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              scaffoldTopGradientClr,
              scaffoldBottomGradientClr,
            ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 0.82.sh,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(0.05.sw, 0.025.sh, 0.05.sw, 0.04.sh),
              decoration: BoxDecoration(
                  color: overlayContainerClr,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0.03.sh),
                      topRight: Radius.circular(0.03.sh))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
