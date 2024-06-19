import 'package:face_auth/common/extensions/size_extensions.dart';
import 'package:face_auth/common/utils/screen_size_util.dart';
import 'package:face_auth/common/utils/theme.dart';
import 'package:face_auth/common/widgets/custom_button.dart';
import 'package:face_auth/common/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  void initializeUtilContexts(BuildContext context) {
    ScreenSizeUtil.context = context;
    CustomSnackbar.context = context;
  }

  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    initializeUtilContexts(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [scaffoldBottomGradientClr, scaffoldTopGradientClr])),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Face authetication flutter",
              style: kNunitoSansSemiBold20White,
            ),
            SizedBox(height: 0.07.sh,),

            CustomButton(
              text: 'Register user', 
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>Home() ),
                );
              }
              ),
              SizedBox(height: 0.025.sh,),
              CustomButton(
                text: "Authenticate user", 
                onTap: (){
                  
                }
                )
          ],
        ),
      ),
    );
  }
}
