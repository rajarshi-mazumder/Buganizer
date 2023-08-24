import 'package:buganizer/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'screens/registration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login.dart';
import 'screens/sidebar.dart';
import 'screens/create_bug.dart';
import 'bugsList.dart';
import 'temp.dart';
import 'screens/appBar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        // Set your desired text direction here
        textDirection: TextDirection.ltr, // Or TextDirection.rtl
        child: Scaffold(
          body: user != null
              ? HomePageWidget(
                  user: user,
                )
              : LoginScreen(),
        ),
      ),
    );
  }
}

class HomePageWidget extends StatefulWidget {
  HomePageWidget({Key? key, this.user, String? photoURL, String? userName})
      : super(key: key);
  User? user = FirebaseAuth.instance.currentUser;
  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  // late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<BugsListScreenState> _bugsListKey =
      GlobalKey<BugsListScreenState>();
  bool showSearchBar = false;

  String tmpQuery = '';

  void getCurrentUserDetails() async {
    final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user?.email)
            .get();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user?.email)
        .get()
        .then((value) {
      setState(() {
        CurrentUserManager.userProfilePic = value['profilePic'];
        CurrentUserManager.username = value['username'];
        CurrentUserManager.notificationsCount = value['notifications'].length;
        print("NOTIFS COUNT: ${CurrentUserManager.notificationsCount}");
      });
    });

    // if (userSnapshot.exists) {
    //   print("User snapshot ${userSnapshot['username']}");
    // }
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    // Call your function here
    getCurrentUserDetails();
    updateSearchQuery(tmpQuery);
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserDetails();
    // _model = createModel(context, () => HomePageModel());
    //print(widget.user);
  }

  void updateSearchQuery(String query) {
    setState(() {
      tmpQuery;
    });
  }

  @override
  void dispose() {
    // _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        drawer: bgz_drawer(
          username: CurrentUserManager.username,
          userProfilePic: CurrentUserManager.userProfilePic!,
        ),
        appBar: AppBarNav(
          goToHomePage: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePageWidget(user: widget.user),
              ),
            );
          },
          unreadNotificationsCount: CurrentUserManager.notificationsCount,
        ),
        body: Column(
          children: [
            Expanded(
              child: SafeArea(
                top: true,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      tmpQuery.length > 0
                          ? "Filtered with: ${tmpQuery}"
                          : "All bugs",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 15),
                    Expanded(
                      child: Container(
                        child: BugsListScreen(
                          key: _bugsListKey,
                          user: widget.user,
                          contextType: "All",
                          searchQuery: tmpQuery,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              child: showSearchBar
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Find Bug...',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                tmpQuery = value;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              showSearchBar = !showSearchBar;
            });
          },
          child: Icon(showSearchBar ? Icons.close : Icons.search),
        ),
      ),
    );
  }
}
