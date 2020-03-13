import 'package:custom_splash/custom_splash.dart';
import 'package:flutter/material.dart';
import 'package:sparring/screens/onboarding/onboarding.dart';

class Splashscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomSplash(
      imagePath: 'assets/img/soccer-player.png',
      backGroundColor: Theme.of(context).primaryColor,
      home: OnboardingScreen(),
      duration: 2500,
      type: CustomSplashType.StaticDuration,
      //animationEffect: 'zoom-in',      
    );
  }
}
