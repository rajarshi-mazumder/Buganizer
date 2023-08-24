import 'package:buganizer/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:buganizer/models/user.dart';

class Authentication {
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userPhotoURL = '';

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult.user;

        if (user != null) {
          print(
              "Signed in with Google: ${user.displayName}. Profile Image URL: ${user.uid} and the email is ${user.email}");

          bool flag = false;
          await FirebaseFirestore.instance
              .collection('users')
              .get()
              .then((value) {
            if (value.docs.every((element) {
              if (element['email'] == user.email) {
                flag = true;
                CurrentUserManager.username = user.displayName;
                CurrentUserManager.userProfilePic = element['profilePic'];
                CurrentUserManager.notificationsCount =
                    element['notifications'].length;
              }
              return true;
            })) ;
          });

          if (flag == false) _register(user.displayName, user.email);

          Navigator.pushReplacement(
            context,
            await MaterialPageRoute(
                builder: (context) => HomePageWidget(
                    photoURL: userPhotoURL, userName: user.displayName)),
          );
        }
      }
    } catch (error) {
      print("Error signing in with Google: $error");
    }
  }

  Future<void> _register(String? displayName, String? email) async {
    try {
      // Create user object in Firestore
      await FirebaseFirestore.instance.collection('users').doc(email).set({
        'username': displayName,
        'email': email,
        'assignedBugs': [],
        'createdBugs': [],
        'notifications': [],
        'profilePic': "none"
      });
    } catch (e) {
      print("Error during registration: $e");
    }
  }

  Future<void> signOutGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await googleSignIn.signOut(); // Cierra la sesión de Google
      await auth.signOut(); // Cierra la sesión de Firebase (si la estás usando)
      print("Sign out successful");
    } catch (error) {
      print("Error signing out: $error");
    }
  }
}
