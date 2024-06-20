import 'package:face_auth/common/extensions/size_extensions.dart';
import 'package:face_auth/common/utils/theme.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final GlobalKey formFieldKey;
  final String validatorText;
  const CustomTextField({super.key, required this.controller, required this.hintText, required this.formFieldKey, required this.validatorText});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.055.sw, vertical: 0.02.sh),
      child: TextFormField(
        key: formFieldKey,
        controller: controller,
        cursorColor: kLeadBlack.withOpacity(0.8),
        style: const TextStyle(
          color: kOffBlack,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.6,
        ),
        decoration: InputDecoration(
          hintText: hintText
        ),
        validator: (val){
          if(val == null || val.trim().isEmpty){
            return "Name cannot be empty";
          } else {
            return null;
          }
        },
      ),
    );
  }
}
