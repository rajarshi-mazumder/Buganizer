import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buganizer/screens/appBar.dart';
import 'package:buganizer/main.dart';

class ImageUploader extends StatefulWidget {
  String? uploadedImgURL = "";
  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  File? _image;
  final picker = ImagePicker();
  Reference _storageReference = FirebaseStorage.instance.ref().child('images');

  User? user = FirebaseAuth.instance.currentUser;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      uploadImage();
    }
  }

  Future uploadImage() async {
    if (_image == null) {
      // Handle the case when no image is selected
      return;
    }

    UploadTask uploadTask =
        _storageReference.child(user!.email!).putFile(_image!);

    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    // Here you can use the `downloadURL` for further processing
    setState(() {
      widget.uploadedImgURL = downloadURL;
    });
    setUserProfileImage();
    print("Download URL: $downloadURL");
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Profile pic updated'),
        content: const Text('Successfully updated profile pic'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  setUserProfileImage() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user?.email)
        .update({'profilePic': widget.uploadedImgURL});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarNav(
        goToHomePage: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePageWidget(
                      user: user,
                    )),
          );
        },
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 200),
            _image != null
                ? Image.file(
                    _image!,
                    height: 100,
                    width: 100,
                  )
                : Column(
                    children: [
                      widget.uploadedImgURL != ""
                          ? Image.network(
                              widget.uploadedImgURL!,
                              height: 100,
                              width: 100,
                            )
                          : Container(
                              child: Icon(
                                Icons.image,
                                size: 100,
                              ),
                              height: 100,
                            ),
                    ],
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: getImage,
              child: Text("Select Image"),
            ),
            // ElevatedButton(
            //   onPressed: uploadImage,
            //   child: Text("Upload Image"),
            // ),
          ],
        ),
      ),
    );
  }
}
