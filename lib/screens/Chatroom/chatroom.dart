import 'package:Sochat/constants/Constantcolors.dart';
import 'package:Sochat/screens/Chatroom/chartroomHelpers.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Chatroom extends StatelessWidget {
  final ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: constantColors.blueColor,
        onPressed: () {
          Provider.of<ChatroomHelper>(context, listen: false)
              .createChatroomSheet(context);
        },
        child: Icon(
          FontAwesomeIcons.plus,
          color: constantColors.greenColor,
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Provider.of<ChatroomHelper>(context, listen: false)
                .createChatroomSheet(context);
          },
          icon: Icon(
            FontAwesomeIcons.plus,
            color: constantColors.lightBlueColor,
          ),
        ),
        backgroundColor: constantColors.darkColor.withOpacity(0.4),
        actions: [
          IconButton(
              icon: Icon(
                EvaIcons.moreVertical,
                color: constantColors.whiteColor,
              ),
              onPressed: () {}),
        ],
        title: RichText(
          text: TextSpan(
              text: "Chat",
              style: TextStyle(
                  color: constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
              children: <TextSpan>[
                TextSpan(
                  text: "Room",
                  style: TextStyle(
                      color: constantColors.blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                )
              ]),
        ),
      ),
      body: Provider.of<ChatroomHelper>(context, listen: false)
          .showChatroom(context),
    );
  }
}
