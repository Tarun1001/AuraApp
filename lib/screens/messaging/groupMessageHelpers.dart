import 'package:Sochat/constants/Constantcolors.dart';
import 'package:Sochat/screens/HomePage/homePage.dart';
import 'package:Sochat/services/authentication.dart';
import 'package:Sochat/services/firebaseoperations/firebaseoperations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class GroupMessageHelper with ChangeNotifier {
  String lastMessageTime;

  String get getlastMessageTime => lastMessageTime;
  bool didthisPersonJoin = false;
  bool get getdidPersonJoin => didthisPersonJoin;
  ConstantColors constantColors = ConstantColors();
  sendMessage(BuildContext context, TextEditingController messageController,
      DocumentSnapshot documentSnapshot) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(documentSnapshot.id)
        .collection("messages")
        .add({
      "message": messageController.text,
      "time": Timestamp.now(),
      "useruid": Provider.of<Authentication>(context, listen: false).getUserUid,
      "username": Provider.of<FirebaseOperations>(context, listen: false)
          .getcurrentUserName,
      "userimage": Provider.of<FirebaseOperations>(context, listen: false)
          .getcurrentUserImage,
      "useremail": Provider.of<FirebaseOperations>(context, listen: false)
          .getcurrentUserEmail,
    });
  }

  //retriving messages
  showMessages(BuildContext context, DocumentSnapshot documentSnapshot,
      String adminUseruid) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(documentSnapshot.id)
            .collection("messages")
            .orderBy("time", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return new ListView(
              reverse: true,
              children:
                  snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
                showLastMessageTime(documentSnapshot.data()['time']);
                return Container(
                  height: documentSnapshot.data()["message"] != null
                      ? MediaQuery.of(context).size.height * 0.14
                      : MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 50.0, top: 20),
                        child: Row(
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 120,
                                      child: Row(
                                        children: [
                                          Text(
                                            documentSnapshot.data()["username"],
                                            style: TextStyle(
                                                color:
                                                    constantColors.greenColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0),
                                          ),
                                          Provider.of<Authentication>(context,
                                                          listen: false)
                                                      .getUserUid ==
                                                  adminUseruid
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Icon(
                                                    FontAwesomeIcons.chessKing,
                                                    size: 12.0,
                                                    color: constantColors
                                                        .yellowColor,
                                                  ),
                                                )
                                              : Container(
                                                  width: 0,
                                                  height: 0,
                                                )
                                        ],
                                      ),
                                    ),
                                    documentSnapshot.data()["message"] != null
                                        ? Text(
                                            documentSnapshot.data()["message"],
                                            style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontSize: 14.0),
                                          )
                                        : Container(
                                            height: 100,
                                            width: 100,
                                            child: Image.network(
                                                documentSnapshot
                                                    .data()["sticker"]),
                                          ),
                                    Container(
                                      width: 80.0,
                                      child: Text(
                                        getlastMessageTime,
                                        style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontSize: 8.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Provider.of<Authentication>(context,
                                                  listen: false)
                                              .getUserUid ==
                                          documentSnapshot.data()["useruid"]
                                      ? constantColors.blueGreyColor
                                          .withOpacity(0.8)
                                      : constantColors.blueGreyColor),
                              constraints: BoxConstraints(
                                maxHeight: documentSnapshot.data()["message"] !=
                                        null
                                    ? MediaQuery.of(context).size.height * 0.14
                                    : MediaQuery.of(context).size.height * 0.44,
                                maxWidth: documentSnapshot.data()["message"] !=
                                        null
                                    ? MediaQuery.of(context).size.width * 0.8
                                    : MediaQuery.of(context).size.width * 0.9,
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        left: 10.0,
                        child:
                            Provider.of<Authentication>(context, listen: false)
                                        .getUserUid ==
                                    documentSnapshot.data()["useruid"]
                                ? Container(
                                    child: Column(
                                      children: [
                                        IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: constantColors.blueColor,
                                              size: 18.0,
                                            ),
                                            onPressed: () {}),
                                        IconButton(
                                            icon: Icon(
                                              FontAwesomeIcons.trashAlt,
                                              color: constantColors.redColor,
                                              size: 18.0,
                                            ),
                                            onPressed: () {})
                                      ],
                                    ),
                                  )
                                : Container(
                                    height: 0,
                                    width: 0,
                                  ),
                      ),
                      Positioned(
                          left: 40,
                          child: Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserUid ==
                                  documentSnapshot.data()["useruid"]
                              ? Container(
                                  height: 0,
                                  width: 0,
                                )
                              : CircleAvatar(
                                  radius: 17,
                                  backgroundColor: constantColors.darkColor,
                                  backgroundImage: NetworkImage(
                                      documentSnapshot.data()["userimage"]),
                                )),
                    ],
                  ),
                );
              }).toList(),
            );
          }
        });
  }

  Future checkIfJoined(BuildContext context, String chatRoomName,
      String chatRoomAdminUID) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomName)
        .collection("members")
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((value) {
      print("Initial state => $didthisPersonJoin");
      if (value.data()["joined"] != null) {
        didthisPersonJoin = value.data()["joined"];
        print("Final State => $didthisPersonJoin");
        notifyListeners();
      }
      if (Provider.of<Authentication>(context, listen: false).getUserUid ==
          chatRoomAdminUID) {
        didthisPersonJoin = true;
        notifyListeners();
      }
    });
  }

  askToJoinDailog(BuildContext context, String roomName) {
    return showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            backgroundColor: constantColors.darkColor,
            title: Text(
              "Join $roomName",
              style: TextStyle(
                  color: constantColors.whiteColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              MaterialButton(
                  child: Text(
                    "No",
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: constantColors.whiteColor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: HomePage(),
                            type: PageTransitionType.bottomToTop));
                  }),
              MaterialButton(
                  color: constantColors.blueColor,
                  child: Text(
                    "Yes",
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    FirebaseFirestore.instance
                        .collection("chatrooms")
                        .doc(roomName)
                        .collection("members")
                        .doc(Provider.of<Authentication>(context, listen: false)
                            .getUserUid)
                        .set({
                      "joined": true,
                      "username": Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getcurrentUserName,
                      "userimage": Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getcurrentUserImage,
                      "useremail": Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getcurrentUserEmail,
                      "useruid":
                          Provider.of<Authentication>(context, listen: false)
                              .getUserUid,
                      "time": Timestamp.now()
                    }).whenComplete(() {
                      Navigator.pop(context);
                    });
                  })
            ],
          );
        });
  }

  showStickers(BuildContext context, String chatroomId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return AnimatedContainer(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            duration: Duration(seconds: 1),
            curve: Curves.easeIn,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    color: constantColors.whiteColor,
                    thickness: 4.0,
                  ),
                ),
                SizedBox(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("stickers")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return GridView(
                          children: snapshot.data.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return GestureDetector(
                              onTap: () {
                                sendStickers(
                                    context,
                                    documentSnapshot.data()["image"],
                                    chatroomId);
                              },
                              child: Container(
                                height: 40.0,
                                width: 40.0,
                                child: Image.network(
                                    documentSnapshot.data()["image"]),
                              ),
                            );
                          }).toList(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          );
        });
  }

  sendStickers(
      BuildContext context, String stickerImageURl, String chatroomId) async {
    await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatroomId)
        .collection("messages")
        .add({
      "sticker": stickerImageURl,
      "username": Provider.of<FirebaseOperations>(context, listen: false)
          .getcurrentUserName,
      "userimage": Provider.of<FirebaseOperations>(context, listen: false)
          .getcurrentUserImage,
      "time": Timestamp.now()
    });
  }

  showLastMessageTime(dynamic timeData) {
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    lastMessageTime = timeago.format(dateTime);
    print(lastMessageTime);
    notifyListeners();
  }
}
