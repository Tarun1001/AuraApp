import 'dart:ui';

import 'package:Sochat/constants/Constantcolors.dart';
import 'package:Sochat/screens/HomePage/homePage.dart';
import 'package:Sochat/screens/landingPage/landingutilities.dart';
import 'package:Sochat/services/authentication.dart';
import 'package:Sochat/services/firebaseoperations/firebaseoperations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LandingService with ChangeNotifier {
  // These are the text controllers for texxtFIeld during the signIn and LogIn phase
  TextEditingController userNameController = TextEditingController();
  TextEditingController useremailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  //.
  ConstantColors constantColors = ConstantColors();
  // A custom widget in the landing page
  //It displayes a list of tiles(cards), these cads contains info like =>(user image,userName,Useremail,traash icon )
  // it will collect these info from firebase
  Widget passWordLessSignInBox(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.40,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              print(snapshot.data);
              return ListView(
                  children: snapshot.data.docs
                      .map((DocumentSnapshot documentSnapshot) {
                return Container(
                  margin: EdgeInsets.only(left: 4, bottom: 4, right: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: constantColors.darkColor,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: constantColors.darkColor,
                      backgroundImage:
                          NetworkImage(documentSnapshot.data()['userimage']),
                    ),
                    title: Text(
                      documentSnapshot.data()['username'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: constantColors.name),
                    ),
                    subtitle: Text(
                      documentSnapshot.data()['useremail'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: constantColors.whiteColor.withOpacity(0.7),
                          fontSize: 12.0),
                    ),
                    trailing: Container(
                      height: 50.0,
                      width: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              icon: Icon(
                                FontAwesomeIcons.check,
                                color: constantColors.greenColor,
                              ),
                              onPressed: () {
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .logInToAccount(
                                        documentSnapshot.data()['useremail'],
                                        documentSnapshot.data()["userpassword"])
                                    .whenComplete(() {
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          child: HomePage(),
                                          type:
                                              PageTransitionType.leftToRight));
                                });
                              }),
                          IconButton(
                            icon: Icon(
                              FontAwesomeIcons.trashAlt,
                              color: constantColors.redColor,
                            ),
                            onPressed: () {
                              Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .deleteUserCollection(context,
                                      documentSnapshot.data()['useruid']);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList());
            }
          },
        ));
  }

  // custom widget ,displayes a bottom sheet to let user sign in
  signInSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                ),
                CircleAvatar(
                  backgroundImage: FileImage(
                      Provider.of<LandingUtils>(context, listen: false)
                          .getUserProfilePicture),
                  backgroundColor: constantColors.redColor,
                  radius: 50.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    controller: userNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter name...',
                      hintStyle: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    controller: useremailController,
                    decoration: InputDecoration(
                      hintText: 'Enter email...',
                      hintStyle: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    controller: userPasswordController,
                    decoration: InputDecoration(
                      hintText: 'Enter password...',
                      hintStyle: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                      backgroundColor: constantColors.redColor,
                      child: Icon(
                        FontAwesomeIcons.check,
                        color: constantColors.whiteColor,
                      ),
                      onPressed: () {
// on pressing send button it should send user details to firebase and let user to go to homepage
                        if (useremailController.text.isNotEmpty) {
                          Provider.of<Authentication>(context, listen: false)
                              .registerAccount(useremailController.text,
                                  userPasswordController.text)
                              .whenComplete(() {
                            print("creating user collection");
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .createUserCollection(context, {
                              "useruid": Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid,
                              "useremail": useremailController.text,
                              "username": userNameController.text,
                              "userimage": Provider.of<LandingUtils>(context,
                                      listen: false)
                                  .getuserProfilePictureUrl,
                              "userpassword": userPasswordController.text,
                            });
                          }).whenComplete(() {
                            userNameController.clear();
                            useremailController.clear();
                            userPasswordController.clear();
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: HomePage(),
                                    type: PageTransitionType.leftToRight));
                          });
                        } else {
                          warningText(context, 'fill all the data');
                        }
                      }),
                )
              ],
            ),
          );
        });
  }

  logInSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0))),
              child: Column(
                children: [
                  Padding(
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: useremailController,
                      decoration: InputDecoration(
                        hintText: 'Enter email...',
                        hintStyle: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: userPasswordController,
                      decoration: InputDecoration(
                        hintText: 'Enter password...',
                        hintStyle: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: FloatingActionButton(
                        backgroundColor: constantColors.blueColor,
                        child: Icon(
                          FontAwesomeIcons.check,
                          color: constantColors.whiteColor,
                        ),
                        onPressed: () {
                          if (useremailController.text.isNotEmpty) {
                            Provider.of<Authentication>(context, listen: false)
                                .logInToAccount(useremailController.text,
                                    userPasswordController.text)
                                .whenComplete(() {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: HomePage(),
                                      type: PageTransitionType.leftToRight));
                            });
                          } else {
                            warningText(context, 'fill all the data');
                          }
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }

  warningText(BuildContext context, String warning) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(15.0)),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            child: Text(
              warning,
              style: TextStyle(
                  color: constantColors.whiteColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
          );
        });
  }

  confirmUserProfilePictureSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                CircleAvatar(
                  radius: 60.0,
                  backgroundColor: constantColors.transperant,
                  backgroundImage: FileImage(
                      Provider.of<LandingUtils>(context, listen: false)
                          .userProfilePicture),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                          child: Text(
                            'Reselect Image',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: constantColors.whiteColor),
                          ),
                          onPressed: () {
                            Provider.of<LandingUtils>(context, listen: false)
                                .pickUserProfilePicture(
                                    context, ImageSource.gallery);
                          }),
                      MaterialButton(
                          color: constantColors.blueColor,
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .uploadUserProfilePicture(context)
                                .whenComplete(() {
                              signInSheet(context);
                              // Navigator.pop(context);
                            });
                          }),
                    ],
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
          );
        });
  }
}
