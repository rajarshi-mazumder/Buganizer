import 'package:flutter/material.dart';
import 'package:buganizer/models/bug.dart';
import 'package:buganizer/screens/bugDetails.dart';
import 'package:intl/intl.dart';

class BugDisplayCard extends StatelessWidget {
  BugDisplayCard({super.key, required this.bug});
  var bug;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: bug['statusType'] != 'inactive'
                ? Colors.grey.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 3), // Adjust the shadow offset as needed
          ),
        ],
      ),
      child: Card(
        color: bug['statusType'] == 'inactive'
            ? Colors.grey.shade300
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${bug['heading']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Text(bug['priority'] != null ? '${bug['priority']}' : 'Undefined')
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: buildDetailRow(
                    Icons.confirmation_number,
                    '',
                    '${bug['id']}',
                  )),
                  Expanded(
                    child: buildDetailRow(
                      Icons.check_circle,
                      '',
                      bug['status'] != null ? '${bug['status']}' : 'Undefined',
                      color: getBugColor(bug['status']),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: buildDetailRow(
                        Icons.bug_report,
                        '',
                        bug['component'] != null
                            ? '${bug['component']}'
                            : 'Undefined'),
                  ),
                  Expanded(
                      child: buildDetailRow(
                          Icons.person, '', '${bug['createdBy']}')),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: buildDetailRow(Icons.calendar_today, '',
                        '${DateFormat.yMd().add_Hm().format(bug['dateCreated'].toDate())}'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BugDetails(
                                  bug: bug,
                                )),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text('Details'),
                  ),
                ],
              ),
            ],
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }
}

Widget buildDetailRow(IconData icon, String title, String subtitle,
    {Color color = Colors.black45}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Icon(icon, color: color),
        SizedBox(width: 8),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 4),
        Expanded(child: Text(subtitle)),
      ],
    ),
  );
}

Color getBugColor(String? bugStatusName) {
  Color tempCol = Colors.black45;
  bugStatusDefaultOpts.forEach((element) {
    {
      if (element['statusName'] == bugStatusName) tempCol = element['color'];
    }
  });
  return tempCol;
}
