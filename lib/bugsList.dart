import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widgetTemplates/bugDisplayCard.dart';

class BugsListScreen extends StatefulWidget {
  BugsListScreen(
      {this.user,
      required this.contextType,
      required GlobalKey<BugsListScreenState> key,
      this.searchQuery})
      : super(key: key);

  User? user;
  String contextType;
  GlobalKey<BugsListScreenState> key = GlobalKey<BugsListScreenState>();
  String? searchQuery = '';

  @override
  BugsListScreenState createState() => BugsListScreenState();
}

class BugsListScreenState extends State<BugsListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot<Map<String, dynamic>>> bugsStream;

  @override
  void initState() {
    super.initState();
    bugsStream = _firestore
        .collection('bugs')
        .orderBy("dateCreated", descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: bugsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        List<QueryDocumentSnapshot<Map<String, dynamic>>> results = [];

        final bugs = snapshot.data?.docs ?? [];

        if (widget.searchQuery != null)
          for (var doc in snapshot.data?.docs ?? []) {
            var data = doc.data();

            if ((data['id'] != null &&
                    data['id'].contains(widget.searchQuery)) ||
                (data['description'] != null &&
                    data['description'].contains(widget.searchQuery)) ||
                (data['heading'] != null &&
                    data['heading'].contains(widget.searchQuery)) ||
                (data['assignedTo'] != null &&
                    data['assignedTo'].contains(widget.searchQuery)) ||
                (data['createdBy'] != null &&
                    data['createdBy'].contains(widget.searchQuery)) ||
                (data['priority'] != null &&
                    data['priority'].contains(widget.searchQuery)) ||
                (data['bugType'] != null &&
                    data['bugType'].contains(widget.searchQuery)) ||
                (data['component'] != null &&
                    data['component'].contains(widget.searchQuery))) {
              results.add(doc);
            }
          }
        else
          results = bugs;

        List thisUsersBugs = [];

        if (widget.contextType == "Assigned") {
          results.forEach((bug) {
            if (bug['assignedTo'] == widget.user?.email) {
              thisUsersBugs.add(bug);
            }
          });
        } else if (widget.contextType == "Created") {
          results.forEach((bug) {
            if (bug['createdBy'] == widget.user?.email) {
              thisUsersBugs.add(bug);
            }
          });
        } else if (widget.contextType == "All") {
          thisUsersBugs = results;
        }
        if (results.isEmpty) {
          return Center(child: Text('No bugs found.'));
        }

        return ListView.builder(
          itemCount: thisUsersBugs.length,
          itemBuilder: (context, index) {
            final bugData = thisUsersBugs[index].data() as Map<String, dynamic>;
            final bugHeading = bugData['heading'] ?? 'No Heading';
            final bugDescription = bugData['description'] ?? 'No description';

            // return BugDisplayCard(bug: bugData);
            return BugDisplayCard(bug: bugData);
          },
        );
      },
    );
  }
}
