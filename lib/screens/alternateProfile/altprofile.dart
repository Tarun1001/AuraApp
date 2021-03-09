import 'package:Sochat/constants/Constantcolors.dart';
import 'package:Sochat/screens/alternateProfile/altProfile_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AltProfile extends StatelessWidget {
  final ConstantColors constantColors = ConstantColors();
  final String userUID;
  AltProfile({@required this.userUID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Provider.of<ALtProfileHelper>(context, listen: false)
          .altProfileAppbar(context),
      body: SingleChildScrollView(
        child: Container(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(userUID)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  children: [
                    Provider.of<ALtProfileHelper>(context, listen: false)
                        .headerProfile(context, snapshot, userUID),
                    Provider.of<ALtProfileHelper>(context, listen: false)
                        .divider(),
                    Provider.of<ALtProfileHelper>(context, listen: false)
                        .middleProfile(context, snapshot),
                    Provider.of<ALtProfileHelper>(context, listen: false)
                        .footProfile(context, snapshot)
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                );
              }
            },
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: constantColors.blueGreyColor.withOpacity(0.6),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0))),
        ),
      ),
    );
  }
}
