import 'dart:async';

import 'package:Sochat/constants/Constantcolors.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

import '../landingPage/landingPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<Offset> animationOffset;

  ConstantColors constantColors = ConstantColors();
  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    final curve =
        CurvedAnimation(parent: animationController, curve: Curves.decelerate);
    animationOffset =
        Tween<Offset>(begin: const Offset(0.0, 0.35), end: Offset.zero)
            .animate(curve);
    Timer(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context,
            PageTransition(
                child: LandingPage(), type: PageTransitionType.leftToRight)));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 100),
            height: 300,
            width: 300,
            child: Lottie.asset("assets/animations/splashscreen.json"),
          ),
          //todo ANimate text

          Column(
            children: [],
          ),
          Center(
              child: RichText(
            text: TextSpan(
                text: 'Welcome',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0),
                children: <TextSpan>[
                  TextSpan(
                    text: ' To',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: constantColors.blueColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 34.0),
                  ),
                  TextSpan(
                    text: '  Aura',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 34.0),
                  )
                ]),
          )),
        ],
      ),
    );
  }
}
