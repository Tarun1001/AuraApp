import 'dart:io';

import 'package:Sochat/constants/Constantcolors.dart';
import 'package:Sochat/services/authentication.dart';
import 'package:Sochat/services/firebaseoperations/firebaseoperations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UpLoadPost with ChangeNotifier {
  TextEditingController captionController = TextEditingController();
  File uploadPostImage;
  File get getUploadPostImage => uploadPostImage;
  String uploadPostImageUrl;
  String get getUploadPostImageUrl => uploadPostImageUrl;
  final picker = ImagePicker();
  UploadTask imagePostUploadTask;

  Future pickUploadPostImage(BuildContext context, ImageSource source) async {
    final uploadImageValue = await picker.getImage(source: source);
    uploadImageValue == null
        ? print('Select Image')
        : uploadPostImage = File(uploadImageValue.path);
    print(uploadImageValue.path);

    uploadPostImage != null
        ? confirmUploadPostimagesheet(context)
        : print("image upload error");
    notifyListeners();
  }

  Future uploadPostImageToFirestore() async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child("posts/${uploadPostImage.path})/${TimeOfDay.now()}");

    imagePostUploadTask = imageReference.putFile(uploadPostImage);
    await imagePostUploadTask.whenComplete(() {
      print("Post image is uploaded to storage");
    });
    imageReference.getDownloadURL().then((value) {
      uploadPostImageUrl = value;
      print(" url of uploaded post is $uploadPostImageUrl");
    });
    notifyListeners();
  }

  ConstantColors constantColors = ConstantColors();
  selectImagetoPost(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.circular(12),
            ),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MaterialButton(
                        color: constantColors.blueColor,
                        child: Text(
                          "Gallery",
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                        onPressed: () async {
                          await pickUploadPostImage(
                              context, ImageSource.gallery);
                          Navigator.canPop(context);
                        }),
                    MaterialButton(
                        color: constantColors.blueColor,
                        child: Text(
                          "Camera",
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                        onPressed: () {
                          pickUploadPostImage(context, ImageSource.camera);
                          Navigator.pop(context);
                        })
                  ],
                )
              ],
            ),
          );
        });
  }

  confirmUploadPostimagesheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  child: Container(
                    height: 200,
                    width: 400,
                    child: Image.file(
                      uploadPostImage,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                          child: Text(
                            'Reselect Image',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: constantColors.whiteColor),
                          ),
                          onPressed: () {
                            selectImagetoPost(context);
                          }),
                      MaterialButton(
                          color: constantColors.blueColor,
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            uploadPostImageToFirestore().whenComplete(() {
                              print("image uploaded to firebase");
                              editPostSheet(context);
                              //Navigator.Pop(context);
                            });
                          }),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  editPostSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
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
                      children: [
                        Container(
                          child: Column(
                            children: [
                              IconButton(
                                  icon: Icon(
                                    Icons.image_aspect_ratio,
                                    color: constantColors.greenColor,
                                  ),
                                  onPressed: () {}),
                              IconButton(
                                  icon: Icon(
                                    Icons.fit_screen,
                                    color: constantColors.yellowColor,
                                  ),
                                  onPressed: () {})
                            ],
                          ),
                        ),
                        Container(
                          height: 200.0,
                          width: 300.0,
                          child: Image.file(
                            uploadPostImage,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                            height: 30,
                            width: 30,
                            child: Icon(
                              FontAwesomeIcons.smile,
                              color: Colors.yellow,
                            )),
                        Container(
                          height: 110,
                          width: 5.0,
                          color: constantColors.blueColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            height: 120,
                            width: 330.0,
                            child: TextField(
                              maxLines: 5,
                              textCapitalization: TextCapitalization.words,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(100)
                              ],
                              maxLength: 100,
                              controller: captionController,
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                  hintText: "Add a caption...",
                                  hintStyle: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                      child: Text(
                        "Share",
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                      onPressed: () async {
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .uploadPostData(captionController.text, {
                          "caption": captionController.text,
                          "username": Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .getcurrentUserName,
                          "userimage": Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .getcurrentUserImage,
                          "useruid": Provider.of<Authentication>(context,
                                  listen: false)
                              .getUserUid,
                          "useremail": Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .getcurrentUserEmail,
                          "postimage": getUploadPostImageUrl,
                          "time": Timestamp.now(),
                        }).whenComplete(() async {
                          return FirebaseFirestore.instance
                              .collection("users")
                              .doc(Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid)
                              .collection("posts")
                              .add({
                            "caption": captionController.text,
                            "username": Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .getcurrentUserName,
                            "userimage": Provider.of<FirebaseOperations>(
                                    context,
                                    listen: false)
                                .getcurrentUserImage,
                            "useruid": Provider.of<Authentication>(context,
                                    listen: false)
                                .getUserUid,
                            "useremail": Provider.of<FirebaseOperations>(
                                    context,
                                    listen: false)
                                .getcurrentUserEmail,
                            "postimage": getUploadPostImageUrl,
                            "time": Timestamp.now(),
                          });
                        }).whenComplete(() {
                          Navigator.pop(context);
                          print(
                              "all the details are sent to firestore inside posts collection");
                        });
                      })
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12),
              ));
        });
  }
}
