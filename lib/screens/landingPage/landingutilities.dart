import 'dart:io';

import 'package:Sochat/constants/Constantcolors.dart';
import 'package:Sochat/screens/landingPage/landingServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class LandingUtils with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  // look at Image picker on flutter docs
  final picker = ImagePicker();
  // userAvatar is  a file not a string
  File userProfilePicture;
  File get getUserProfilePicture => userProfilePicture;
  // userUrl is string
  String userProfilePictureUrl;
  String get getuserProfilePictureUrl => userProfilePictureUrl;
  //method to pick user avatar from source or from gallery

  Future pickUserProfilePicture(
      BuildContext context, ImageSource source) async {
    final pickedUserProfilePicture = await picker.getImage(source: source);
    pickedUserProfilePicture == null
        ? print('Select Image')
        : userProfilePicture = File(pickedUserProfilePicture.path);
    print(
        "this is the path for picked picture${pickedUserProfilePicture.path}");
    print(
        "this this the path for userprofilePicture${userProfilePicture.path}");

    userProfilePicture != null
        ? Provider.of<LandingService>(context, listen: false)
            .confirmUserProfilePictureSheet(context)
        : print("userProfilePIcture is null =>$userProfilePicture");
    notifyListeners();
  }

  //method to select an user avatar
  Future selectUserProfilePictureOptionSheet(BuildContext context) async {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                        color: constantColors.blueColor,
                        child: Text(
                          'Gallery',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                        onPressed: () {
                          pickUserProfilePicture(context, ImageSource.gallery)
                              .whenComplete(() {
                            Navigator.pop(context);
                            Provider.of<LandingService>(context, listen: false)
                                .confirmUserProfilePictureSheet(context);
                          });
                        }),
                    MaterialButton(
                        color: constantColors.blueColor,
                        child: Text(
                          'Camera',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                        onPressed: () {
                          pickUserProfilePicture(context, ImageSource.camera)
                              .whenComplete(() {
                            Navigator.pop(context);
                            Provider.of<LandingService>(context, listen: false)
                                .confirmUserProfilePictureSheet(context);
                          });
                        }),
                  ],
                )
              ],
            ),
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12.0)),
          );
        });
  }
}
