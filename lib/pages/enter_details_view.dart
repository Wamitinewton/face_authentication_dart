import 'dart:nativewrappers/_internal/vm/lib/developer.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_auth/common/utils/theme.dart';
import 'package:face_auth/common/widgets/custom_button.dart';
import 'package:face_auth/common/widgets/custom_snackbar.dart';
import 'package:face_auth/common/widgets/custom_text_field.dart';
import 'package:face_auth/models/user_model.dart';
import 'package:face_auth/pages/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class EnterDetailsView extends StatefulWidget {
  final String image;
  final FaceFeatures faceFeatures;
  const EnterDetailsView(
      {super.key, required this.image, required this.faceFeatures});

  @override
  State<EnterDetailsView> createState() => _EnterDetailsViewState();
}

class _EnterDetailsViewState extends State<EnterDetailsView> {
  bool isRegistering = false;
  final _formfieldKey = GlobalKey<FormFieldState>();
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kOffBlack,
        title: Text(
          "Add details",
          style: kNunitoSansBold18.copyWith(color: kLynxWhite, fontSize: 20),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [scaffoldTopGradientClr, scaffoldBottomGradientClr])),
        child: Center(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                    controller: _nameController,
                    hintText: "Name",
                    formFieldKey: _formfieldKey,
                    validatorText: "Name cannot be empty"),
                CustomButton(
                    text: "Register now",
                    onTap: () {
                      if (_formfieldKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();

                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.purple,
                                  ),
                                ));
                        String userId = Uuid().v1();
                        UserModel user = UserModel(
                            id: userId,
                            name: _nameController.text.trim().toUpperCase(),
                            image: widget.image,
                            registeredOn: DateTime.now().hour,
                            faceFeatures: widget.faceFeatures);
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(userId)
                            .set(user.toJson())
                            .catchError((e) {
                          log("Registration Error: $e");
                          Navigator.of(context).pop();
                          CustomSnackbar.successSnackBar(
                              "Registration success!");
                          Future.delayed(const Duration(seconds: 1), () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Home()));
                          });
                        });
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
