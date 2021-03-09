import 'package:Sochat/screens/landingPage/landingutilities.dart';
import 'package:Sochat/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirebaseOperations with ChangeNotifier {
  String currentUserEmail, currentUserName, currentUserImage;
  String get getcurrentUserName => currentUserName;
  String get getcurrentUserEmail => currentUserEmail;
  String get getcurrentUserImage => currentUserImage;

  Future fetchCurrentUserData(BuildContext context) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((doc) {
      print('Fetching User data ');
      currentUserName = doc.data()['username'];
      currentUserEmail = doc.data()['useremail'];
      currentUserImage = doc.data()['userimage'];
      print(currentUserName);
      print(currentUserEmail);
      print(currentUserImage);
      notifyListeners();
    });
  }

  //uploadtask
  UploadTask imageUploadtask;
  //function to upload image to firestore

  Future uploadUserProfilePicture(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance.ref().child(
        'userProfileAvatar/${Provider.of<LandingUtils>(context, listen: false).getUserProfilePicture.path}/${TimeOfDay.now()}');
    imageUploadtask = imageReference.putFile(
        Provider.of<LandingUtils>(context, listen: false)
            .getUserProfilePicture);
    await imageUploadtask
        .whenComplete(() => print('userProfileImage  Uploaded'));
    imageReference.getDownloadURL().then((value) {
      Provider.of<LandingUtils>(context, listen: false).userProfilePictureUrl =
          value.toString();
      print(
          ' user profilepicture url => ${Provider.of<LandingUtils>(context, listen: false).userProfilePictureUrl} and it is uploaded to firebase storage');
      notifyListeners();
    });
  }

  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .set(data);
  }

  Future deleteUserCollection(BuildContext context, String userid) async {
    return FirebaseFirestore.instance.collection('users').doc(userid).delete();
  }

  Future uploadPostData(String documentPostID, dynamic data) async {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(documentPostID)
        .set(data);
  }
//todo

  // Future uploadAwardsimages(BuildContext context )async{
  //   Reference imageReference = FirebaseStorage.instance.ref().child("rewardIcons/${Provider.of(context)}")
  // }

  Future followUser(
      String followingUserUID,
      String followingDocID,
      dynamic followingUserData,
      String followerUserUID,
      String followerDocID,
      dynamic followerUserData) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(followingUserUID)
        .collection("followers")
        .doc(followingDocID)
        .set(followingUserData)
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection("users")
          .doc(followerUserUID)
          .collection("following")
          .doc(followerDocID)
          .set(followerUserData);
    });
  }

  Future submitChatroomData(String chatroomName, dynamic chatroomData) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatroomName)
        .set(chatroomData);
  }
}
