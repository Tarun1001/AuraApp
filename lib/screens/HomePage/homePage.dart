import 'package:Sochat/constants/Constantcolors.dart';
import 'package:Sochat/screens/Chatroom/chatroom.dart';
import 'package:Sochat/screens/Feed/feed.dart';
import 'package:Sochat/screens/HomePage/homepageHelpers.dart';
import 'package:Sochat/screens/Profile/profile.dart';
import 'package:Sochat/services/firebaseoperations/firebaseoperations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController homepageController = PageController();
  final ConstantColors constantColors = ConstantColors();
  int pageIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FirebaseOperations>(context, listen: false)
          .fetchCurrentUserData(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: constantColors.darkColor,
        body: PageView(
          controller: homepageController,
          children: [Feed(), Chatroom(), Profile()],
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (page) {
            setState(() {
              pageIndex = page;
            });
          },
        ),
        bottomNavigationBar: Provider.of<HomePageHelper>(context, listen: false)
            .bottomNavBar(context, pageIndex, homepageController));
  }
}
