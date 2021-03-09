import 'dart:ui';

import 'package:Sochat/constants/Constantcolors.dart';
import 'package:Sochat/screens/HomePage/homePage.dart';
import 'package:Sochat/screens/landingPage/landingServices.dart';
import 'package:Sochat/screens/landingPage/landingutilities.dart';
import 'package:Sochat/services/authentication.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LandingHelpers with ChangeNotifier {
  Widget bodyImage(BuildContext context) {
    return Container(
      child: Lottie.asset('assets/animations/astronaut.json'),
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width,
      // decoration: BoxDecoration(
      //     image: DecorationImage(image: AssetImage('assets/images/login.png'))),
    );
  }

  Widget tagLineText(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return Positioned(
      top: 400,
      left: 50,
      child: Container(
        width: 300,
        child: RichText(
          text: TextSpan(
              text: 'Explore ',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  color: constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 34.0),
              children: <TextSpan>[
                TextSpan(
                  text: 'the world of',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: constantColors.greyColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 34.0),
                ),
                TextSpan(
                  text: ' Aura',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: constantColors.blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 36.0),
                ),
                TextSpan(
                  text: '               signin or login ',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 33.0),
                )
              ]),
        ),
      ),
    );
  }

  Widget mainbutton(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return Positioned(
      top: 600.0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                emailAuthSheet(context);
              },
              child: Container(
                child: Icon(
                  EvaIcons.email,
                  color: constantColors.yellowColor,
                  size: 30,
                ),
                width: 80.0,
                height: 40.0,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5,
                        spreadRadius: 1.0,
                        color: constantColors.darkColor.withOpacity(0.2))
                  ],
                  border: Border.all(
                      color: constantColors.yellowColor.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                child: Icon(
                  EvaIcons.facebook,
                  color: Colors.blueAccent,
                  size: 30,
                ),
                width: 80.0,
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5,
                        spreadRadius: 1.0,
                        color: constantColors.darkColor.withOpacity(0.2))
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Provider.of<Authentication>(context, listen: false)
                    .signInWithGoogle()
                    .whenComplete(() {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: HomePage(),
                          type: PageTransitionType.leftToRight));
                });
              },
              child: Container(
                child: Icon(
                  FontAwesomeIcons.google,
                  color: constantColors.greenColor,
                ),
                width: 80.0,
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: constantColors.greenColor.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5,
                        spreadRadius: 1.0,
                        color: constantColors.darkColor.withOpacity(0.2))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  emailAuthSheet(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.bottomsSheet,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Provider.of<LandingService>(context, listen: false)
                    .passWordLessSignInBox(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                        elevation: 15,
                        color: constantColors.blueColor,
                        child: Text(
                          'Log In',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Provider.of<LandingService>(context, listen: false)
                              .logInSheet(context);
                        }),
                    MaterialButton(
                        elevation: 15,
                        color: constantColors.redColor,
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Provider.of<LandingUtils>(context, listen: false)
                              .selectUserProfilePictureOptionSheet(context);
                        })
                  ],
                ),
              ],
            ),
          );
        });
  }
}
