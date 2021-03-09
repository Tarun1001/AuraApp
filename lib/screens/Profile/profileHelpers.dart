import 'package:Sochat/constants/Constantcolors.dart';
import 'package:Sochat/screens/alternateProfile/altprofile.dart';
import 'package:Sochat/screens/landingPage/landingPage.dart';
import 'package:Sochat/services/authentication.dart';
import 'package:Sochat/utilities/postOptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ProfileHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget headerProfile(BuildContext context, dynamic snapshot) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 220.0,
            width: 170.0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: CircleAvatar(
                      backgroundColor: constantColors.transperant,
                      radius: 40.0,
                      backgroundImage:
                          NetworkImage(snapshot.data.data()['userimage']),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    snapshot.data.data()["username"],
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        EvaIcons.email,
                        size: 14,
                        color: constantColors.greenColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          snapshot.data.data()["useremail"],
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          viewFollowersSheet(context, snapshot);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: constantColors.darkColor,
                              borderRadius: BorderRadius.circular(15.0)),
                          height: 80.0,
                          width: 80.0,
                          child: Column(
                            children: [
                              StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(snapshot.data.data()["useruid"])
                                      .collection("followers")
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: Lottie.asset(
                                              "assets/animations/dotloading.json"));
                                    } else {
                                      return new Text(
                                        snapshot.data.docs.length.toString(),
                                        style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28.0),
                                      );
                                    }
                                  }),
                              Text(
                                "Followers",
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          viewFollowingUsersSheet(context, snapshot);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: constantColors.darkColor,
                              borderRadius: BorderRadius.circular(15.0)),
                          height: 70.0,
                          width: 80.0,
                          child: Column(
                            children: [
                              StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(snapshot.data.data()["useruid"])
                                      .collection("following")
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else {
                                      return new Text(
                                        snapshot.data.docs.length.toString(),
                                        style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28.0),
                                      );
                                    }
                                  }),
                              Text(
                                "Following",
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0),
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
                    decoration: BoxDecoration(
                        color: constantColors.darkColor,
                        borderRadius: BorderRadius.circular(15.0)),
                    height: 70.0,
                    width: 80.0,
                    child: Column(
                      children: [
                        Text(
                          "0",
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 28.0),
                        ),
                        Text(
                          "posts",
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return SizedBox(
      height: 25,
      width: 350,
      child: Divider(
        color: constantColors.whiteColor,
      ),
    );
  }

  Widget middleProfile(BuildContext context, dynamic snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 190.0,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.0)),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Icon(
                  FontAwesomeIcons.userAlt,
                  color: constantColors.yellowColor,
                  size: 16.0,
                ),
                Text(
                  " Recently Followed",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: constantColors.whiteColor),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(snapshot.data.data()["useruid"])
                    .collection("following")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child:
                            Lottie.asset("assets/animations/dotloading.json"));
                  } else {
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data.docs
                          .map((DocumentSnapshot documentSnapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: Lottie.asset(
                                  "assets/animations/dotloading.json"));
                        } else {
                          return Container(
                              height: 60.0,
                              width: 60.0,
                              child: Image.network(
                                  documentSnapshot.data()["userimage"]));
                        }
                      }).toList(),
                    );
                  }
                }),
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(15.0)),
          ),
        )
      ],
    );
  }

  Widget footProfile(BuildContext context, dynamic snapshot) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(snapshot.data.data()["useruid"])
            .collection("posts")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Lottie.asset("assets/animations/dotloading.json"));
          } else if (snapshot.data.docs.isEmpty) {
            return Container(
              child: Lottie.asset("assets/animations/emptypicture.json"),
            );
          } else {
            return GridView(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              children:
                  snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
                return GestureDetector(
                  onTap: () async {
                    await showPostDetails(context, documentSnapshot);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: constantColors.bottomsSheet,
                          borderRadius: BorderRadius.circular(5)),
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                        child:
                            Image.network(documentSnapshot.data()["postimage"]),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: constantColors.darkColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(15.0)),
    );
  }

  logOutDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: constantColors.darkColor,
            title: Text(
              "log out ? ",
              style: TextStyle(
                  color: constantColors.whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "No",
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        decoration: TextDecoration.underline,
                        decorationColor: constantColors.whiteColor),
                  )),
              MaterialButton(
                  color: constantColors.redColor,
                  onPressed: () {
                    Provider.of<Authentication>(context, listen: false)
                        .logOutEmail()
                        .whenComplete(() {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: LandingPage(),
                              type: PageTransitionType.bottomToTop));
                    });
                  },
                  child: Text(
                    "Yes",
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          );
        });
  }

  viewFollowersSheet(BuildContext context, dynamic snapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12.0)),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(snapshot.data.data()["useruid"])
                    .collection("followers")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return new ListView(
                      children: snapshot.data.docs
                          .map((DocumentSnapshot documentSnapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: Lottie.asset(
                                  "assets/animations/dotloading.json"));
                        } else {
                          return new ListTile(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: AltProfile(
                                          userUID: documentSnapshot
                                              .data()["useruid"]),
                                      type: PageTransitionType.bottomToTop));
                            },
                            trailing: MaterialButton(
                                color: constantColors.blueColor,
                                child: Text(
                                  "Unfollow",
                                  style: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                                onPressed: () {}),
                            leading: CircleAvatar(
                              backgroundColor: constantColors.darkColor,
                              backgroundImage: NetworkImage(
                                  documentSnapshot.data()["userimage"]),
                            ),
                            title: Text(
                              documentSnapshot.data()["username"],
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                            subtitle: Text(
                              documentSnapshot.data()["useremail"],
                              style: TextStyle(
                                  color: constantColors.yellowColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0),
                            ),
                          );
                        }
                      }).toList(),
                    );
                  }
                }),
          );
        });
  }

  viewFollowingUsersSheet(BuildContext context, dynamic snapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(12.0)),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(snapshot.data.data()["useruid"])
                    .collection("following")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return new ListView(
                      children: snapshot.data.docs
                          .map((DocumentSnapshot documentSnapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return ListTile(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: AltProfile(
                                          userUID: documentSnapshot
                                              .data()["useruid"]),
                                      type: PageTransitionType.topToBottom));
                            },
                            trailing: MaterialButton(
                                color: constantColors.blueColor,
                                child: Text(
                                  "Unfollow",
                                  style: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                                onPressed: () {}),
                            leading: CircleAvatar(
                              backgroundColor: constantColors.darkColor,
                              backgroundImage: NetworkImage(
                                  documentSnapshot.data()["userimage"]),
                            ),
                            title: Text(
                              documentSnapshot.data()["username"],
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                            subtitle: Text(
                              documentSnapshot.data()["useremail"],
                              style: TextStyle(
                                  color: constantColors.yellowColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0),
                            ),
                          );
                        }
                      }).toList(),
                    );
                  }
                }),
          );
        });
  }

  showPostDetails(BuildContext context, DocumentSnapshot documentSnapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12.0)),
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: FittedBox(
                    child: Image.network(documentSnapshot.data()["postimage"]),
                  ),
                ),
                Text(
                  documentSnapshot.data()["caption"],
                  style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
                Container(
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
                                FontAwesomeIcons.heart,
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
                                    .showCommentSheet(context, documentSnapshot,
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
                                FontAwesomeIcons.award,
                                color: constantColors.yellowColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Text(
                                "0",
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Provider.of<Authentication>(context, listen: false)
                                  .getUserUid !=
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
          );
        });
  }
}
