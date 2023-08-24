import 'package:flutter/material.dart';
import 'create_bug.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'package:buganizer/screens/assignedBugs.dart';
import 'package:buganizer/screens/createdBugs.dart';
import 'package:buganizer/screens/imageUpload.dart';
import 'package:buganizer/models/user.dart';

class bgz_drawer extends StatelessWidget {
  bgz_drawer({super.key, this.username, required this.userProfilePic});
  User? user = FirebaseAuth.instance.currentUser;
  String userProfilePic;
  String? username;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ImageUploader()),
                    );
                  },
                  child: CircleAvatar(
                    radius: 30,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        userProfilePic!,
                        fit: BoxFit.cover,
                        height: 60,
                        width: 60,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "${user?.email}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.add_circle_outline),
            title: Text('Create Bug'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BugCreation()),
              );
            },
          ),
          ListTile(
              leading: Icon(Icons.person),
              title: Text('Assigned to me'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserAssignedBugs(
                            user: user,
                          )),
                );
              }),
          ListTile(
            leading: Icon(Icons.person_pin_rounded),
            title: Text('Reported by me'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserCreatedBugs(
                          user: user,
                        )),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
