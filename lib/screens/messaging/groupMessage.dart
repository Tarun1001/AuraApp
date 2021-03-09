import 'dart:async';

import 'package:Sochat/constants/Constantcolors.dart';
import 'package:Sochat/screens/Chatroom/chatroom.dart';
import 'package:Sochat/screens/HomePage/homePage.dart';
import 'package:Sochat/screens/messaging/groupMessageHelpers.dart';
import 'package:Sochat/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class GroupMessage extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  GroupMessage({@required this.documentSnapshot});

  @override
  _GroupMessageState createState() => _GroupMessageState();
}

class _GroupMessageState extends State<GroupMessage> {
  @override
  void initState() {
    Provider.of<GroupMessageHelper>(context, listen: false)
        .checkIfJoined(context, widget.documentSnapshot.id,
            widget.documentSnapshot.data()['useruid'])
        .whenComplete(() async {
      if (Provider.of<GroupMessageHelper>(context, listen: false)
              .getdidPersonJoin ==
          false) {
        Timer(
            Duration(microseconds: 10),
            () => Provider.of<GroupMessageHelper>(context, listen: false)
                .askToJoinDailog(context, widget.documentSnapshot.id));
      }
    });
    super.initState();
  }

  final ConstantColors constantColors = ConstantColors();

  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      appBar: AppBar(
        backgroundColor: constantColors.darkColor.withOpacity(0.6),
        centerTitle: true,
        title: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: constantColors.darkColor,
                backgroundImage:
                    NetworkImage(widget.documentSnapshot.data()["roomPicture"]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.documentSnapshot.data()["roomname"],
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("chatrooms")
                            .doc(widget.documentSnapshot.id)
                            .collection("members")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: Container(
                                    height: 50,
                                    width: 50,
                                    child: Lottie.asset(
                                        "assets/animations/dotloading.json")));
                          } else {
                            return new Text(
                              "${snapshot.data.docs.length.toString()} Members",
                              style: TextStyle(
                                  color: constantColors.greenColor
                                      .withOpacity(0.5),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0),
                            );
                          }
                        })
                  ],
                ),
              )
            ],
          ),
        ),
        actions: [
          Provider.of<Authentication>(context, listen: false).getUserUid ==
                  widget.documentSnapshot.data()["useruid"]
              ? IconButton(
                  icon: Icon(
                    EvaIcons.moreVertical,
                    color: constantColors.whiteColor,
                  ),
                  onPressed: () {})
              : Container(
                  width: 0,
                  height: 0,
                ),
          IconButton(
              icon: Icon(
                EvaIcons.logOutOutline,
                color: constantColors.redColor,
              ),
              onPressed: () {}),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: Chatroom(), type: PageTransitionType.topToBottom));
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: constantColors.whiteColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              AnimatedContainer(
                child: Provider.of<GroupMessageHelper>(context, listen: false)
                    .showMessages(context, widget.documentSnapshot,
                        widget.documentSnapshot.data()["useruid"]),
                duration: Duration(seconds: 1),
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                curve: Curves.bounceIn,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Provider.of<GroupMessageHelper>(context,
                                  listen: false)
                              .showStickers(
                                  context, widget.documentSnapshot.id);
                        },
                        child: CircleAvatar(
                          backgroundColor: constantColors.transperant,
                          child: Icon(
                            FontAwesomeIcons.smile,
                            color: constantColors.yellowColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextField(
                            controller: messageController,
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                                hintText: "Droop a Hi..",
                                hintStyle: TextStyle(
                                    color: constantColors.greenColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                          child: Icon(
                            Icons.send_sharp,
                            color: constantColors.whiteColor,
                          ),
                          onPressed: () {
                            if (messageController.text.isNotEmpty) {
                              Provider.of<GroupMessageHelper>(context,
                                      listen: false)
                                  .sendMessage(context, messageController,
                                      widget.documentSnapshot);
                            }
                          })
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
