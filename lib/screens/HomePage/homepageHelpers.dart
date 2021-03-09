import 'package:Sochat/constants/Constantcolors.dart';
import 'package:Sochat/services/firebaseoperations/firebaseoperations.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget bottomNavBar(
      BuildContext context, int index, PageController pageController) {
    return CustomNavigationBar(
        currentIndex: index,
        bubbleCurve: Curves.bounceIn,
        scaleCurve: Curves.decelerate,
        selectedColor: constantColors.blueColor,
        unSelectedColor: constantColors.whiteColor,
        strokeColor: constantColors.blueColor,
        scaleFactor: 0.5,
        iconSize: 27.0,
        onTap: (val) {
          index = val;
          pageController.jumpToPage(val);
          notifyListeners();
        },
        backgroundColor: Color(0xff040307),
        items: [
          CustomNavigationBarItem(icon: Icon(EvaIcons.home)),
          CustomNavigationBarItem(icon: Icon(EvaIcons.messageCircle)),
          CustomNavigationBarItem(
              icon: CircleAvatar(
                  radius: 40.0,
                  backgroundColor: constantColors.blueGreyColor,
                  backgroundImage: Provider.of<FirebaseOperations>(context)
                              .getcurrentUserImage !=
                          null
                      ? NetworkImage(Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getcurrentUserImage)
                      : AssetImage("assets/images/empty.png"))),
        ]);
  }
}
