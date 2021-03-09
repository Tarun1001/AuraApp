import 'package:Sochat/constants/Constantcolors.dart';
import 'package:Sochat/screens/HomePage/homePage.dart';
import 'package:Sochat/services/authentication.dart';
import 'package:Sochat/services/firebaseoperations/firebaseoperations.dart';
import 'package:Sochat/utilities/postOptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'altprofile.dart';

class ALtProfileHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget altProfileAppbar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_outlined,
          color: constantColors.whiteColor,
        ),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: HomePage(), type: PageTransitionType.leftToRight));
        },
      ),
      title: RichText(
        text: TextSpan(
            text: "The",
            style: TextStyle(
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
            children: <TextSpan>[
              TextSpan(
                  text: "Social",
                  style: TextStyle(
                      color: constantColors.blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0)),
            ]),
      ),
      backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
      actions: [
        IconButton(
            icon: Icon(
              EvaIcons.moreVertical,
              color: constantColors.whiteColor,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: HomePage(), type: PageTransitionType.leftToRight));
            })
      ],
    );
  }

  Widget headerProfile(BuildContext context,
      AsyncSnapshot<DocumentSnapshot> snapshot, String useruid) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 220.0,
                width: 180.0,
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
                              height: 70.0,
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
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          return new Text(
                                            snapshot.data.docs.length
                                                .toString(),
                                            style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
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
                          Container(
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
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.width,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        'Follow',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      onPressed: () {
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .followUser(
                                useruid,
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid,
                                {
                                  "username": Provider.of<FirebaseOperations>(
                                          context,
                                          listen: false)
                                      .currentUserName,
                                  'userimage': Provider.of<FirebaseOperations>(
                                          context,
                                          listen: false)
                                      .currentUserImage,
                                  "useruid": Provider.of<Authentication>(
                                          context,
                                          listen: false)
                                      .getUserUid,
                                  "useremail": Provider.of<FirebaseOperations>(
                                          context,
                                          listen: false)
                                      .currentUserEmail,
                                  "time": Timestamp.now()
                                },
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid,
                                useruid,
                                {
                                  "username": snapshot.data.data()["username"],
                                  "userimage":
                                      snapshot.data.data()["userimage"],
                                  "userUid": snapshot.data.data()["userUid"],
                                  "useremail":
                                      snapshot.data.data()["useremail"],
                                  "time": Timestamp.now()
                                })
                            .whenComplete(() {
                          followerNotification(
                              context, snapshot.data.data()["username"]);
                        });
                      }),
                  MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        'Messasge',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      onPressed: () {})
                ],
              ),
            ),
          )
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
          width: 160.0,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.0)),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Icon(
                  FontAwesomeIcons.userAstronaut,
                  color: constantColors.yellowColor,
                  size: 16.0,
                ),
              ),
              Text(
                "Recently Added",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: constantColors.whiteColor),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.1,
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
            return Center(child: CircularProgressIndicator());
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

  followerNotification(BuildContext context, String name) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Text(
                  "followed $name",
                  style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(1.0)),
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
                                      type: PageTransitionType.bottomToTop));
                            },
                            trailing: documentSnapshot.data()["useruid"] ==
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserUid
                                ? Container(
                                    height: 0,
                                    width: 0,
                                  )
                                : MaterialButton(
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

  viewFollowersSheet(BuildContext context, dynamic snapshot) {
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
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return ListTile(
                            onTap: () {
                              if (documentSnapshot.data()["useruid"] !=
                                  Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserUid) {
                                Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        child: AltProfile(
                                            userUID: documentSnapshot
                                                .data()["useruid"]),
                                        type: PageTransitionType.leftToRight));
                              }
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
