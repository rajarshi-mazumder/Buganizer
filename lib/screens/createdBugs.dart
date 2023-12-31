import 'package:buganizer/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sidebar.dart';
import 'package:buganizer/bugsList.dart';
import 'package:buganizer/screens/appBar.dart';
import 'package:buganizer/models/user.dart';

class UserCreatedBugs extends StatefulWidget {
  UserCreatedBugs({super.key, this.user});
  User? user = FirebaseAuth.instance.currentUser;
  @override
  State<UserCreatedBugs> createState() => _UserCreatedBugsState();
}

class _UserCreatedBugsState extends State<UserCreatedBugs> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<BugsListScreenState> _bugsListKey =
      GlobalKey<BugsListScreenState>();
  void getCurrentUserDetails() async {
    final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user?.email)
            .get();

    // if (userSnapshot.exists) {
    //   print("User snapshot ${userSnapshot['username']}");
    // }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserDetails();
    // _model = createModel(context, () => HomePageModel());
    //print(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        drawer: bgz_drawer(
          userProfilePic: CurrentUserManager.userProfilePic!,
          username: CurrentUserManager.username,
        ),
        appBar: AppBarNav(
          goToHomePage: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePageWidget(
                        user: widget.user,
                      )),
            );
          },
        ),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                "Reported by me",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 15),
              Expanded(
                child: Container(
                  child: BugsListScreen(
                    key: _bugsListKey,
                    user: widget.user,
                    contextType: "Created",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
