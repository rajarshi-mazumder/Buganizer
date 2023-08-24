class CustomUser {
  final String id;
  final String username;
  final String email;
  List? assignedBugs = [];
  List? createdBugs = [];
  List? notifications = [];
  String? profilePic = "";
  CustomUser({
    required this.id,
    required this.username,
    required this.email,
    this.assignedBugs,
    this.createdBugs,
    this.notifications,
    this.profilePic,
  });

  factory CustomUser.fromMap(Map<String, dynamic> data, String id) {
    return CustomUser(
        id: id,
        username: data['username'],
        email: data['email'],
        assignedBugs: data['assignedBugs'],
        createdBugs: data['createdBugs'],
        notifications: data['notifications']);
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
    };
  }
}

class CurrentUserManager {
  static String? userProfilePic = "https://i.stack.imgur.com/l60Hf.png";
  static String? username = "";
  static int notificationsCount = 0;
}
