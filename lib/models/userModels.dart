class UserItem {
  String userID;
  String username;
  String name;
  String email;
  String bio;
  String location;

  UserItem(
      {required this.userID,
      required this.username,
      required this.name,
      required this.email,
      required this.bio,
      required this.location});

  Map<String, dynamic> toMap() => {
        "username": username,
        "name": name,
        "email": email,
        "bio": bio,
        "location": location
      };

  factory UserItem.fromMap(Map<String, dynamic> json, String userID) =>
      UserItem(
        userID: userID,
        username: json['username'],
        name: json["name"],
        email: json["email"],
        bio: json["bio"],
        location: json["location"],
      );
}
