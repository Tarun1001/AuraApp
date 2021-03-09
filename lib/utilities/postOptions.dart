import 'package:Sochat/constants/Constantcolors.dart';
import 'package:Sochat/screens/alternateProfile/altprofile.dart';
import 'package:Sochat/services/authentication.dart';
import 'package:Sochat/services/firebaseoperations/firebaseoperations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostFunctions with ChangeNotifier {
  TextEditingController commentController = TextEditingController();
  ConstantColors constantColors = ConstantColors();
  String postedTime;
  String get getPostedTime => postedTime;

  showPostOptions(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                            color: constantColors.blueColor,
                            child: Text("Edit Caption",
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0)),
                            onPressed: () {}),
                        MaterialButton(
                            color: constantColors.redColor,
                            child: Text("Delete Caption",
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0)),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: constantColors.darkColor,
                                      title: Text(
                                        "Delete the Post?",
                                        style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      actions: [
                                        MaterialButton(
                                            child: Text("No",
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    decorationColor:
                                                        constantColors
                                                            .whiteColor,
                                                    color: constantColors
                                                        .whiteColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0)),
                                            onPressed: () {}),
                                        MaterialButton(
                                            onPressed: () {},
                                            color: constantColors.redColor,
                                            child: Text("Yes",
                                                style: TextStyle(
                                                    color: constantColors
                                                        .whiteColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0)))
                                      ],
                                    );
                                  });
                            })
                      ],
                    ),
                  )
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.12,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0)),
              ));
        });
  }

  showTime(dynamic timeData) {
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    postedTime = timeago.format(dateTime);
    print("time of post recorded");
  }

  Future addLike(
      BuildContext context, String postID, String likedUserId) async {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(postID)
        .collection("likes")
        .doc(likedUserId)
        .set({
      "likes": FieldValue.increment(1),
      "username": Provider.of<FirebaseOperations>(context, listen: false)
          .getcurrentUserName,
      "useruid": Provider.of<Authentication>(context, listen: false).getUserUid,
      "userimage": Provider.of<FirebaseOperations>(context, listen: false)
          .getcurrentUserImage,
      "useremail": Provider.of<FirebaseOperations>(context, listen: false)
          .getcurrentUserEmail,
      "time": Timestamp.now()
    });
  }

  Future addComment(BuildContext context, String postID, String comment) async {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(postID)
        .collection("comments")
        .doc(comment)
        .set({
      "comment": comment,
      "username": Provider.of<FirebaseOperations>(context, listen: false)
          .getcurrentUserName,
      "useruid": Provider.of<Authentication>(context, listen: false).getUserUid,
      "userimage": Provider.of<FirebaseOperations>(context, listen: false)
          .getcurrentUserImage,
      "useremail": Provider.of<FirebaseOperations>(context, listen: false)
          .getcurrentUserEmail,
      "time": Timestamp.now()
    });
  }

  showCommentSheet(
      BuildContext context, DocumentSnapshot snapshot, String docID) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
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
                //todo asdf

                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: constantColors.whiteColor),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      "Comments",
                      style: TextStyle(
                          color: constantColors.blueColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("posts")
                          .doc(docID)
                          .collection("comments")
                          .orderBy("time")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: Lottie.asset(
                                  "assets/animations/dotloading.json"));
                        } else {
                          return new ListView(
                            // why? below 2 lines
                            //  scrollDirection: Axis.vertical,
                            // shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: snapshot.data.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  PageTransition(
                                                      child: AltProfile(
                                                          userUID:
                                                              documentSnapshot
                                                                      .data()[
                                                                  "useruid"]),
                                                      type: PageTransitionType
                                                          .bottomToTop));
                                            },
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  constantColors.darkColor,
                                              radius: 15,
                                              backgroundImage: NetworkImage(
                                                  documentSnapshot
                                                      .data()["userimage"]),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Container(
                                              child: Text(
                                            documentSnapshot.data()["username"],
                                            style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0),
                                          )),
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              Row(
                                                children: [
                                                  IconButton(
                                                      icon: Icon(
                                                        FontAwesomeIcons
                                                            .arrowUp,
                                                        color: constantColors
                                                            .blueColor,
                                                        size: 14.0,
                                                      ),
                                                      onPressed: () {}),
                                                  Text(
                                                    "0",
                                                    style: TextStyle(
                                                        color: constantColors
                                                            .blueColor,
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  IconButton(
                                                      icon: Icon(
                                                        FontAwesomeIcons
                                                            .arrowDown,
                                                        color: constantColors
                                                            .yellowColor,
                                                        size: 14.0,
                                                      ),
                                                      onPressed: () {}),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        children: [
                                          IconButton(
                                              icon: Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                                color: constantColors.blueColor,
                                                size: 13,
                                              ),
                                              onPressed: () {}),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.75,
                                            child: Text(
                                              documentSnapshot
                                                  .data()["comment"],
                                              style: TextStyle(
                                                  color:
                                                      constantColors.whiteColor,
                                                  fontSize: 16.0),
                                            ),
                                          ),
                                          IconButton(
                                              icon: Icon(
                                                FontAwesomeIcons.trashAlt,
                                                color: constantColors.redColor,
                                                size: 16,
                                              ),
                                              onPressed: () {}),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 50,
                            width: 300,
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                  hintText: "Add Comments...",
                                  hintStyle: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              controller: commentController,
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          FloatingActionButton(
                              backgroundColor: constantColors.greenColor,
                              child: Icon(
                                FontAwesomeIcons.comment,
                                color: constantColors.whiteColor,
                              ),
                              onPressed: () {
                                print("adding comment");
                                addComment(context, snapshot.data()['caption'],
                                        commentController.text)
                                    .whenComplete(() {
                                  commentController.clear();
                                  notifyListeners();
                                });
                              })
                        ]),
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
          );
        });
  }

  showLikes(BuildContext context, postID) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: constantColors.whiteColor),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      "likes",
                      style: TextStyle(
                          color: constantColors.blueColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("posts")
                        .doc(postID)
                        .collection("likes")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child:
                              Lottie.asset("assets/animations/dotloading.json"),
                        );
                      } else {
                        return new ListView(
                          children: snapshot.data.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return ListTile(
                              leading: GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            child: AltProfile(
                                                userUID: documentSnapshot
                                                    .data()["useruid"]),
                                            type: PageTransitionType
                                                .bottomToTop));
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        documentSnapshot.data()["userimage"]),
                                  )),
                              title: Text(
                                documentSnapshot.data()['username'],
                                style: TextStyle(
                                    color: constantColors.blueColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                              subtitle: Text(
                                documentSnapshot.data()['useremail'],
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),
                              trailing: Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid ==
                                      documentSnapshot.data()["useruid"]
                                  ? Container(
                                      height: 0,
                                      width: 0,
                                    )
                                  : MaterialButton(
                                      color: constantColors.blueColor,
                                      onPressed: () {},
                                      child: Text(
                                        "Follow",
                                        style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0),
                                      ),
                                    ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
          );
        });
  }

  showRewards(BuildContext context, postId) {
    return showBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: constantColors.whiteColor),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      "Rewards",
                      style: TextStyle(
                          color: constantColors.blueColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("awards")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: Lottie.asset(
                                  "assets/animations/dotloading.json"));
                        } else {
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return GestureDetector(
                                onTap: () {
                                  //todo add awards
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
