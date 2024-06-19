import 'package:face_auth/common/extensions/size_extensions.dart';
import 'package:face_auth/common/utils/theme.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const CustomButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0.05.sw),
        decoration: BoxDecoration(
            color: kNoghreiSilver,
            borderRadius: BorderRadius.circular(0.02.sh)),
        child: Padding(
          padding: EdgeInsets.all(0.03.sw),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 0.03.sw),
                child: Text(
                  text,
                  style: TextStyle(
                    color: kOffBlack,
                    fontSize: 0.025.sh,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              CircleAvatar(
                radius: 0.03.sh,
                backgroundColor: kSeaGreen,
                child: const Icon(
                  Icons.arrow_circle_right,
                  color: kLynxWhite,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
