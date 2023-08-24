import 'package:flutter/material.dart';

class Bug {
  final String id;
  String heading;
  String description;
  String? assignedTo = "";
  String? createdBy = "";
  static int totalBugs = 0;
  String? bugType;
  List<String>? comments = [];
  DateTime? dateCreated;
  String? priority;
  String? component;
  String? status;

  Bug(
      {required this.id,
      required this.heading,
      required this.description,
      this.assignedTo,
      this.createdBy,
      this.bugType,
      this.comments,
      this.dateCreated,
      this.priority,
      this.component,
      this.status});
}

enum BugType { none, featureRequest, ProductBreakingBug }

List<String> priorityOpts = ['P0', 'P1', 'P2', 'P3', 'P4'];
List<String> bugTypeOpts = [
  'None',
  'Bug',
  'Feature Request',
  'Process',
  'Vulnerability',
  'Project'
];
List<String> bugStatusOpts = [
  'New',
  'Open',
  'assigned',
  'accepted',
  'closed',
  'fixed',
  'verified',
  'duplicate',
  'infeasible',
  'intended behavior',
  'not reproducible',
  'obsolete'
];
List<String> componentOpts = ['Gmail', 'GMeet', 'GChat', 'GCalendar'];
List<Map> bugStatusDefaultOpts = [
  {'statusName': 'New', 'color': Colors.blue.shade500, 'statusType': 'active'},
  {
    'statusName': 'Open',
    'color': Colors.blueAccent.shade700,
    'statusType': 'active'
  },
  {
    'statusName': 'Assigned',
    'color': Colors.greenAccent,
    'statusType': 'active'
  },
  {
    'statusName': 'Accepted',
    'color': Colors.green.shade200,
    'statusType': 'active'
  },
  {
    'statusName': 'Closed',
    'color': Colors.grey.shade200,
    'statusType': 'inactive'
  },
  {
    'statusName': 'Fixed',
    'color': Colors.green.shade800,
    'statusType': 'inactive'
  },
  {
    'statusName': 'Verified',
    'color': Colors.teal.shade800,
    'statusType': 'inactive'
  },
  {
    'statusName': 'Infeasible',
    'color': Colors.orangeAccent.shade400,
    'statusType': 'inactive'
  },
  {
    'statusName': 'Intended Behavior',
    'color': Colors.greenAccent.shade700,
    'statusType': 'inactive'
  },
  {
    'statusName': 'Not reproducible',
    'color': Colors.grey.shade800,
    'statusType': 'inactive'
  },
  {'statusName': 'Obsolete', 'color': Colors.grey, 'statusType': 'inactive'},
];
