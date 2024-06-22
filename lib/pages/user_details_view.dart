import 'package:face_auth/common/extensions/size_extensions.dart';
import 'package:face_auth/common/utils/theme.dart';
import 'package:face_auth/models/user_model.dart';
import 'package:flutter/material.dart';

class UserDetailsView extends StatelessWidget {
  final UserModel user;
  const UserDetailsView({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kOffBlack,
        title: const Text("Authenticated!!!"),
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
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 42,
                backgroundColor: kLynxWhite,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.check,
                    color: kLynxWhite,
                    size: 44,
                  ),
                ),
              ),
              SizedBox(height: 0.025.sh),
              Text(
                "Hey ${user.name} !",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 26,
                  color: kSeaGreen,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "You are Successfully Authenticated !",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: kSeaGreen.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
