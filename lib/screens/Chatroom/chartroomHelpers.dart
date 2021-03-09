import 'package:Sochat/constants/Constantcolors.dart';
import 'package:Sochat/screens/alternateProfile/altprofile.dart';
import 'package:Sochat/screens/messaging/groupMessage.dart';
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

class ChatroomHelper with ChangeNotifier {
  String latestMessageTime;
  String get getLatestMessageTime => latestMessageTime;
  String chatroomPictureURl, chatroomID;
  String get getChatroomID => chatroomID;
  String get getChatroomprofileURL => chatroomPictureURl;
  ConstantColors constantColors = ConstantColors();
  TextEditingController chatroomNameController = TextEditingController();

  createChatroomSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            child: Padding(
              padding: EdgeInsets.only(bottom: 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      color: constantColors.whiteColor,
                      thickness: 4.0,
                    ),
                  ),
                  Text(
                    "Select ChatRoom profile picture",
                    style: TextStyle(
                        color: constantColors.greenColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("chatroomIcons")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return GestureDetector(
                                onTap: () {
                                  chatroomPictureURl =
                                      documentSnapshot.data()["image"];
                                  print(chatroomPictureURl);
                                  notifyListeners();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: chatroomPictureURl ==
                                                    documentSnapshot
                                                        .data()["image"]
                                                ? constantColors.blueColor
                                                : constantColors.transperant)),
                                    height: 50,
                                    width: 50,
                                    child: Image.network(
                                        documentSnapshot.data()["image"]),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextField(
                          autofocus: true,
                          textCapitalization: TextCapitalization.words,
                          controller: chatroomNameController,
                          decoration: InputDecoration(
                              hintText: "Enter Chat Room ID",
                              hintStyle: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0)),
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: (() async {
                          Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .submitChatroomData(chatroomNameController.text, {
                            "roomPicture": getChatroomprofileURL,
                            "time": Timestamp.now(),
                            "roomname": chatroomNameController.text,
                            "username": Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .getcurrentUserName,
                            "useremail": Provider.of<FirebaseOperations>(
                                    context,
                                    listen: false)
                                .getcurrentUserEmail,
                            "useruid": Provider.of<Authentication>(context,
                                    listen: false)
                                .getUserUid,
                            "userimage": Provider.of<FirebaseOperations>(
                                    context,
                                    listen: false)
                                .getcurrentUserImage,
                            //sdfasd
                          }).whenComplete(() async {
                            Navigator.pop(context);
                          });
                        }),
                        backgroundColor: constantColors.blueGreyColor,
                        child: Icon(
                          FontAwesomeIcons.plus,
                          color: constantColors.yellowColor,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
          );
        });
  }

  showChatroom(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("chatrooms").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: Container(
                    child: Lottie.asset("assets/animations/dotloading.json")),
              ),
            );
          } else if (snapshot.data.docs.isEmpty) {
            return Container(
              child: Center(
                child: RichText(
                  text: TextSpan(
                      text: "Create a",
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                      children: <TextSpan>[
                        TextSpan(
                          text: " Chat Room",
                          style: TextStyle(
                              color: constantColors.blueColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        )
                      ]),
                ),
              ),
            );
          } else {
            return new ListView(
                children:
                    snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
              return ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: GroupMessage(
                            documentSnapshot: documentSnapshot,
                          ),
                          type: PageTransitionType.leftToRight));
                },
                onLongPress: () {
                  showChatroomDetails(context, documentSnapshot);
                },
                leading: CircleAvatar(
                  backgroundColor: constantColors.transperant,
                  backgroundImage:
                      NetworkImage(documentSnapshot.data()["roomPicture"]),
                ),
                title: Text(
                  documentSnapshot.data()["roomname"],
                  style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("chatrooms")
                      .doc(documentSnapshot.id)
                      .collection("messages")
                      .orderBy("time", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.data.docs.isEmpty) {
                      return Text(
                        "Start Messaging",
                        style: TextStyle(
                            color: constantColors.greenColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                      );
                    } else if (snapshot.data.docs.first.data()["username"] !=
                            null &&
                        snapshot.data.docs.first.data()["message"] != null) {
                      return Text(
                        "${snapshot.data.docs.first.data()["username"]} : ${snapshot.data.docs.first.data()["message"]}",
                        style: TextStyle(
                            color: constantColors.greenColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                      );
                    } else if (snapshot.data.docs.first.data()["username"] !=
                            null &&
                        snapshot.data.docs.first.data()["stickers"] != null) {
                      return Text(
                        "${snapshot.data.docs.first.data()["username"]} : Sticker ",
                        style: TextStyle(
                            color: constantColors.greenColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                      );
                    } else {
                      return Container(
                        height: 0,
                        width: 0,
                      );
                    }
                  },
                ),
                trailing: Container(
                  width: 60.0,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("chatrooms")
                        .doc(documentSnapshot.id)
                        .collection("messages")
                        .orderBy("time", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.data.docs.isEmpty) {
                        return Text(" ");
                      } else {
                        showlastMessageTime(
                            snapshot.data.docs.first.data()["time"]);
                        return Text(
                          getLatestMessageTime ?? "--",
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold),
                        );
                      }
                    },
                  ),
                ),
              );
            }).toList());
          }
        });
  }

  //showing chat room details
  showChatroomDetails(BuildContext context, DocumentSnapshot documentSnapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    color: constantColors.whiteColor,
                    thickness: 4.0,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: constantColors.blueColor),
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Members",
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("chatrooms")
                        .doc(documentSnapshot.id)
                        .collection("members")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return new ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return GestureDetector(
                              onTap: () {
                                if (Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserUid !=
                                    documentSnapshot.data()["useruid"]) {
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          child: AltProfile(
                                            userUID: documentSnapshot
                                                .data()["useruid"],
                                          ),
                                          type:
                                              PageTransitionType.bottomToTop));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: CircleAvatar(
                                  backgroundColor: constantColors.darkColor,
                                  backgroundImage: NetworkImage(
                                      documentSnapshot.data()["userimage"]),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                  height: MediaQuery.of(context).size.height * 0.09,
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: constantColors.yellowColor),
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Admin",
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: constantColors.transperant,
                        backgroundImage:
                            NetworkImage(documentSnapshot.data()["userimage"]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          documentSnapshot.data()["username"],
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
          );
        });
  }

  showlastMessageTime(dynamic timeData) {
    Timestamp t = timeData;
    DateTime dateTime = t.toDate();
    latestMessageTime = timeago.format(dateTime);
    // notifyListeners();
  }
}
