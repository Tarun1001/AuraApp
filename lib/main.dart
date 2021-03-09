import 'package:Sochat/constants/Constantcolors.dart';
import 'package:Sochat/screens/Chatroom/chartroomHelpers.dart';
import 'package:Sochat/screens/Feed/feedHelpers.dart';
import 'package:Sochat/screens/HomePage/homepageHelpers.dart';
import 'package:Sochat/screens/Profile/profileHelpers.dart';
import 'package:Sochat/screens/alternateProfile/altProfile_helper.dart';
import 'package:Sochat/screens/landingPage/landingHelpers.dart';
import 'package:Sochat/screens/landingPage/landingServices.dart';
import 'package:Sochat/screens/landingPage/landingutilities.dart';
import 'package:Sochat/screens/messaging/groupMessageHelpers.dart';
import 'package:Sochat/screens/splashScreen/splashScreen.dart';
import 'package:Sochat/services/authentication.dart';
import 'package:Sochat/services/firebaseoperations/firebaseoperations.dart';
import 'package:Sochat/utilities/postOptions.dart';
import 'package:Sochat/utilities/uploadpost.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConstantColors constantColor = ConstantColors();
    return MultiProvider(
        child: MaterialApp(
          home: SplashScreen(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            accentColor: constantColor.blueColor,
            fontFamily: "Poppins",
            canvasColor: Colors.transparent,
          ),
        ),
        //inside provider we will have a list of all the providers
        providers: [
          ChangeNotifierProvider(create: (_) => GroupMessageHelper()),
          ChangeNotifierProvider(create: (_) => ChatroomHelper()),
          ChangeNotifierProvider(create: (_) => ALtProfileHelper()),
          ChangeNotifierProvider(create: (_) => UpLoadPost()),
          ChangeNotifierProvider(create: (_) => FeedHelpers()),
          ChangeNotifierProvider(create: (_) => ProfileHelpers()),
          ChangeNotifierProvider(create: (_) => HomePageHelper()),
          ChangeNotifierProvider(create: (_) => PostFunctions()),
          ChangeNotifierProvider(create: (_) => LandingUtils()),
          ChangeNotifierProvider(create: (_) => FirebaseOperations()),
          ChangeNotifierProvider(create: (_) => LandingHelpers()),
          ChangeNotifierProvider(create: (_) => Authentication()),
          ChangeNotifierProvider(create: (_) => LandingService())
        ]);
  }
}
