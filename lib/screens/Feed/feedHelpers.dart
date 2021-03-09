import 'package:Sochat/constants/Constantcolors.dart';
import 'package:Sochat/screens/alternateProfile/altprofile.dart';
import 'package:Sochat/services/authentication.dart';
import 'package:Sochat/utilities/postOptions.dart';
import 'package:Sochat/utilities/uploadpost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class FeedHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: constantColors.darkColor,
      centerTitle: true,
      actions: [
        IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {
              Provider.of<UpLoadPost>(context, listen: false)
                  .selectImagetoPost(context);
            })
      ],
      title: RichText(
        text: TextSpan(
            text: "Social",
            style: TextStyle(
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
            children: <TextSpan>[
              TextSpan(
                text: "Feed",
                style: TextStyle(
                    color: constantColors.blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              )
            ]),
      ),
    );
  }

  Widget feedBody(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .orderBy("time", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    height: 50,
                    width: 50,
                    child: Lottie.asset(
                      "assets/animations/dotloading.json",
                    ));
              } else if (snapshot.data.docs.isEmpty) {
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: "Add a",
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                            children: <TextSpan>[
                              TextSpan(
                                text: " Picture",
                                style: TextStyle(
                                    color: constantColors.blueColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              )
                            ]),
                      ),
                      Lottie.asset("assets/animations/addposts.json"),
                    ],
                  ),
                );
              } else {
                return loadposts(context, snapshot);
              }
            }),
        height: MediaQuery.of(context).size.height * 0.9,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: constantColors.darkColor.withOpacity(0.5),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0))),
      ),
    );
  }

  Widget loadposts(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
        padding: EdgeInsets.only(bottom: 50),
        children: snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
          Provider.of<PostFunctions>(context, listen: false)
              .showTime(documentSnapshot.data()["time"]);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: constantColors.bottomsSheet,
                  borderRadius: BorderRadius.circular(10.0)),
              height: MediaQuery.of(context).size.height * 0.60,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (documentSnapshot.data()["useruid"] !=
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid) {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: AltProfile(
                                        userUID:
                                            documentSnapshot.data()["useruid"],
                                      ),
                                      type: PageTransitionType.leftToRight));
                            }
                          },
                          child: CircleAvatar(
                            backgroundColor: constantColors.blueGreyColor,
                            radius: 22.5,
                            backgroundImage: NetworkImage(
                                documentSnapshot.data()['userimage']),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    documentSnapshot.data()["caption"],
                                    style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                ),
                                Container(
                                  child: RichText(
                                      text: TextSpan(
                                          text: documentSnapshot
                                              .data()['username'],
                                          style: TextStyle(
                                              color: constantColors.greenColor,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold),
                                          children: <TextSpan>[
                                        TextSpan(
                                            text:
                                                " , ${Provider.of<PostFunctions>(context, listen: false).getPostedTime.toString()}",
                                            style: TextStyle(
                                                color: constantColors
                                                    .lightBlueColor
                                                    .withOpacity(0.8)))
                                      ])),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      color: constantColors.darkColor,
                      height: MediaQuery.of(context).size.height * 0.40,
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                        child: Image.network(
                          documentSnapshot.data()["postimage"],
                          scale: 2,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 80.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onLongPress: () {
                                  Provider.of<PostFunctions>(context,
                                          listen: false)
                                      .showLikes(context,
                                          documentSnapshot.data()["caption"]);
                                },
                                onTap: () {
                                  print("liked the post");
                                  Provider.of<PostFunctions>(context,
                                          listen: false)
                                      .addLike(
                                          context,
                                          documentSnapshot.data()["caption"],
                                          Provider.of<Authentication>(context,
                                                  listen: false)
                                              .getUserUid);
                                },
                                child: Icon(
                                  FontAwesomeIcons.solidHeart,
                                  color: constantColors.redColor,
                                ),
                              ),
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("posts")
                                      .doc(documentSnapshot.data()["caption"])
                                      .collection("likes")
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else {
                                      return Text(
                                        snapshot.data.docs.length.toString(),
                                        style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      );
                                    }
                                  })
                            ],
                          ),
                        ),
                        Container(
                          width: 80.0,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Provider.of<PostFunctions>(context,
                                          listen: false)
                                      .showCommentSheet(
                                          context,
                                          documentSnapshot,
                                          documentSnapshot.data()["caption"]);
                                },
                                child: Icon(
                                  FontAwesomeIcons.comment,
                                  color: constantColors.blueColor,
                                ),
                              ),
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("posts")
                                      .doc(documentSnapshot.data()["caption"])
                                      .collection("comments")
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else {
                                      return Text(
                                        snapshot.data.docs.length.toString(),
                                        style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      );
                                    }
                                  })
                            ],
                          ),
                        ),
                        Container(
                          width: 80.0,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Provider.of<PostFunctions>(context,
                                          listen: false)
                                      .showRewards(context, documentSnapshot);
                                },
                                child: Icon(
                                  EvaIcons.messageSquareOutline,
                                  color: constantColors.yellowColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Provider.of<Authentication>(context, listen: false)
                                    .getUserUid ==
                                documentSnapshot.data()['useruid']
                            ? IconButton(
                                icon: Icon(
                                  EvaIcons.moreVertical,
                                  color: constantColors.whiteColor,
                                ),
                                onPressed: () {
                                  Provider.of<PostFunctions>(context,
                                          listen: false)
                                      .showPostOptions(context);
                                })
                            : Container(
                                width: 0,
                                height: 0,
                              )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList());
  }
}
