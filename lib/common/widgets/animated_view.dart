import 'dart:async';
import 'dart:math';

import 'package:face_auth/common/extensions/size_extensions.dart';
import 'package:face_auth/common/widgets/animated_circle.dart';
import 'package:flutter/material.dart';

class AnimatedView extends StatefulWidget {
  const AnimatedView({super.key});

  @override
  State<AnimatedView> createState() => _AnimatedViewState();
}

class _AnimatedViewState extends State<AnimatedView>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late Animation animation;
  late Animation opacity;
  late AnimationController animationController;
  late int sAngle;
  late int mAngle;
  late int lAngle;
  Random random = Random();
  late Timer timer;

  @override
  void initState() {
    super.initState();
    sAngle = random.nextInt(360);
    mAngle = random.nextInt(360);
    lAngle = random.nextInt(360);
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      sAngle = random.nextInt(360);
      mAngle = random.nextInt(360);
      lAngle = random.nextInt(360);
    });
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    opacity = Tween<double>(begin: 0.8, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeIn));
    animation = Tween<double>(begin: 0, end: 140).animate(CurvedAnimation(
        parent: animationController, curve: Curves.easeInOutQuad))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          animationController.repeat();
        }
      });
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    timer.cancel();

    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      height: 0.3.sh,
      width: 0.66.sw,
      child: CustomPaint(
        painter: AnimatedCircle(
            value: animation.value,
            opacity: opacity.value,
            sAngle: sAngle,
            mAngle: mAngle,
            lAngle: lAngle,
            showOnxSmallCircle: true,
            showonMediumCircle: true,
            showOnLargeCirlce: true),
      ),
    );
  }
}
