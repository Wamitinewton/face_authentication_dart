import 'dart:convert';
import 'dart:typed_data';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_auth/common/extensions/size_extensions.dart';
import 'package:face_auth/common/utils/theme.dart';
import 'package:face_auth/common/widgets/animated_view.dart';
import 'package:face_auth/common/widgets/custom_button.dart';
import 'package:face_auth/common/widgets/custom_snackbar.dart';
import 'package:face_auth/controllers/extract_face_features.dart';
import 'package:face_auth/models/user_model.dart';
import 'package:face_auth/pages/camera_view.dart';
import 'package:face_auth/pages/user_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_face_api/flutter_face_api.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'dart:math' as math;

class AuthenticateFaceView extends StatefulWidget {
  const AuthenticateFaceView({super.key});

  @override
  State<AuthenticateFaceView> createState() => _AuthenticateFaceViewState();
}

class _AuthenticateFaceViewState extends State<AuthenticateFaceView> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FaceDetector _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
          enableLandmarks: true,
          performanceMode: FaceDetectorMode.accurate,
          enableClassification: true,
          enableContours: true,
          enableTracking: true));
  FaceFeatures? _faceFeatures;
  MatchFacesImage? image1;
  MatchFacesImage? image2;

  final TextEditingController _nameController = TextEditingController();
  String _similarity = "";
  bool _canAthenticate = false;
  List<dynamic> users = [];
  bool userExists = false;
  UserModel? logginUser;
  bool isMatching = false;
  int trialNumber = 1;

  @override
  void dispose() {
    _faceDetector.close();
    _audioPlayer.dispose();
    super.dispose();
  }

  get _playScanningAudio => _audioPlayer
    ..setReleaseMode(ReleaseMode.loop)
    ..play(AssetSource("scan_beep.wav"));

  get _playFailedAudio => _audioPlayer
    ..setReleaseMode(ReleaseMode.release)
    ..play(AssetSource("failed.mp3"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kOffBlack,
        title: const Text("Authenticate Face"),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constrains) => Stack(
          children: [
            Container(
              width: constrains.maxWidth,
              height: constrains.maxHeight,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    scaffoldTopGradientClr,
                    scaffoldBottomGradientClr
                  ]
                  )
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 0.82.sh,
                      width: double.infinity,
                      padding: 
                      EdgeInsets.fromLTRB(0.05.sw, 0.025.sh, 0.05.sw, 0),
                      decoration: BoxDecoration(
                        color: overlayContainerClr,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0.03.sh),
                          topRight: Radius.circular(0.03.sh),
                        )
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CameraView(
                                onImage: (image){
                                  _setImage(image);
                                }, 
                                onInputImage: (inputImage) async{
                                  setState(()=> isMatching = true);
                                  _faceFeatures = await extractFaceFeatures(inputImage, _faceDetector);
                                  setState(()=> isMatching = false);
                                }
                                ),
                                if(isMatching)
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 0.064.sh),
                                    child: const AnimatedView(),
                                    ),
                                )
                            ],
                          ),
                           const Spacer(),
                          if (_canAthenticate)
                            CustomButton(
                              text: "Authenticate",
                              onTap: () {
                                setState(() => isMatching = true);
                                _playScanningAudio;
                                _fetchUsersAndMatchFace();
                              },
                            ),
                          SizedBox(height: 0.038.sh),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        )
        ),
    );
  }

  Future _setImage(Uint8List imageToAuthenticate) async {
    image2 = MatchFacesImage(imageToAuthenticate, ImageType.PRINTED);
    setState(() {
      _canAthenticate = true;
    });
  }

  double euclideanDistance(Points p1, Points p2) {
    final sqr =
        math.sqrt(math.pow((p1.x! - p2.x!), 2) + math.pow((p1.y! - p2.y!), 2));
    return sqr;
  }

  double compareFace(FaceFeatures face1, FaceFeatures face2) {
    double distEar1 = euclideanDistance(face1.rightEar!, face2.leftEar!);
    double distEar2 = euclideanDistance(face2.rightEar!, face2.leftEar!);
    double ratioEar = distEar1 / distEar2;
    double distEye1 = euclideanDistance(face1.rightEye!, face1.leftEye!);
    double distEye2 = euclideanDistance(face2.rightEye!, face2.leftEye!);

    double ratioEye = distEye1 / distEye2;

    double distCheek1 = euclideanDistance(face1.rightCheek!, face1.leftCheek!);
    double distCheek2 = euclideanDistance(face2.rightCheek!, face2.leftCheek!);

    double ratioCheek = distCheek1 / distCheek2;

    double distMouth1 = euclideanDistance(face1.rightMouth!, face1.leftMouth!);
    double distMouth2 = euclideanDistance(face2.rightMouth!, face2.leftMouth!);

    double ratioMouth = distMouth1 / distMouth2;

    double distNoseToMouth1 =
        euclideanDistance(face1.noseBase!, face1.bottomMouth!);
    double distNoseToMouth2 =
        euclideanDistance(face2.noseBase!, face2.bottomMouth!);
    double ratioNoseTomouth = distNoseToMouth1 / distNoseToMouth2;

    double ratio = (ratioEar + ratioEye + ratioCheek + ratioMouth + ratioNoseTomouth) / 5;
    return ratio;
  }

  _fetchUsersAndMatchFace() {
    FirebaseFirestore.instance.collection("users").get().catchError((e) {
      log('Getting user Error: $e');
      setState(() => isMatching = false);
      _playFailedAudio;
      CustomSnackbar.errorSnackBar("Something went wrong. Please try again");
    }).then((snap) {
      if (snap.docs.isNotEmpty) {
        users.clear();
        log(snap.docs.length.toString(), name: "Total registered users");
        for (var doc in snap.docs) {
          UserModel user = UserModel.fromJson(doc.data());
          double similarity = compareFace(_faceFeatures!, user.faceFeatures!);
          if (similarity >= 0.8 && similarity <= 1.5) {
            users.add([user, similarity]);
          }
        }
        log(users.length.toString(), name: "filtered users");
        setState(() {
          // sort the users based on similarity
          // more similar faces are put first
          users.sort((a, b) => (((a.last as double) - 1).abs())
              .compareTo(((b.last as double) - 1).abs()));
        });
        _matchFaces();
      } else {
        _showFailureDialog(title: "Error", description: "Not found");
      }
    });
  }

  _matchFaces() async {
    bool faceMatched = false;
    for (List user in users) {
      // assuming the user.first is a UserModel and not Uint8List, adjust accordingly
      Uint8List imageBytes = base64Decode((user.first as UserModel).image!);
      image1 = MatchFacesImage(imageBytes, ImageType.PRINTED);
      // image2 is already in the _setImage
      var request = MatchFacesRequest([image1!, image2!]);
      var response = await FaceSDK.instance.matchFaces(request);
      var split =
          await FaceSDK.instance.splitComparedFaces(response.results, 0.75);
      setState(() {
        _similarity = split.matchedFaces.isNotEmpty
            ? (split.matchedFaces[0].similarity * 100).toStringAsFixed(2)
            : "error";
        log("similarity: $_similarity");

        if (_similarity != "error" && double.parse(_similarity) > 90.00) {
          faceMatched = true;
          logginUser = user.first;
        } else {
          faceMatched = false;
        }
      });
      if (faceMatched) {
        _audioPlayer
          ..stop()
          ..setReleaseMode(ReleaseMode.release)
          ..play(AssetSource("success.mp3"));

        setState(() {
          trialNumber = 1;
          isMatching = false;
        });
        if (mounted) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UserDetailsView(user: logginUser!)));
        }
        break;
      }
    }
    if (!faceMatched) {
      if (trialNumber == 4) {
        setState(() => trialNumber = 1);
        _showFailureDialog(
            title: "Redeem failed",
            description: "Face does not match. Please try again");
      } else if (trialNumber == 3) {
        _audioPlayer.stop();
        setState(() {
          isMatching = false;
          trialNumber++;
        });
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Enter Name"),
                content: TextFormField(
                  controller: _nameController,
                  cursorColor: Colors.green,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.green,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.green,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (_nameController.text.trim().isEmpty) {
                        CustomSnackbar.errorSnackBar("Enter a name to proceed");
                      } else {
                        Navigator.of(context).pop();
                        setState(() => isMatching = true);
                        _playScanningAudio;
                        _fetchUserByName(_nameController.text.trim());
                      }
                    },
                    child: const Text(
                      "Done",
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  )
                ],
              );
            });
      } else {
        setState(() => trialNumber++);
        _showFailureDialog(
            title: "Redeem failed",
            description: "Face does not match. Try again");
      }
    }
  }

  _fetchUserByName(String orgID) {
    FirebaseFirestore.instance
        .collection("users")
        .where("organizationId", isEqualTo: orgID)
        .get()
        .catchError((e) {
      log("Getting User Error: $e");
      setState(() => isMatching = false);
      _playFailedAudio;
      CustomSnackbar.errorSnackBar("Something went wrong. Please try again.");
    }).then((snap) {
      if (snap.docs.isNotEmpty) {
        users.clear();

        for (var doc in snap.docs) {
          setState(() {
            users.add([UserModel.fromJson(doc.data()), 1]);
          });
        }
        _matchFaces();
      } else {
        setState(() => trialNumber = 1);
        _showFailureDialog(
          title: "User Not Found",
          description:
              "User is not registered yet. Register first to authenticate.",
        );
      }
    });
  }

  _showFailureDialog({
    required String title,
    required String description,
  }) {
    _playFailedAudio;
    setState(() => isMatching = false);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Ok",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
