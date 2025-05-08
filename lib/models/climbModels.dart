class ClimbReadItem {
  final String sessionID;
  final String location;
  final String date;
  final String? notes;
  final List<String>? friends;

  final bool isBoulder;
  final double grade;
  final String attempts;
  final String? name;
  final List<String>? tags;

  ClimbReadItem(
      {required this.sessionID,
      required this.location,
      required this.date,
      this.notes,
      this.friends,
      required this.isBoulder,
      required this.grade,
      required this.attempts,
      this.name,
      this.tags});

  /*factory ClimbItem.fromPreview(
          ClimbPreviewItem climbPreview, String location, String date) =>
      ClimbItem(
          isBoulder: climbPreview.isBoulder,
          grade: climbPreview.grade,
          attempts: climbPreview.attempts);*/

  factory ClimbReadItem.fromMap(
          Map<String, dynamic> json, String location, String date) =>
      ClimbReadItem(
          sessionID: json['sessionID'],
          location: location,
          date: date,
          notes: json["notes"],
          friends: json["friends"],
          isBoulder: json["isBoulder"],
          grade: json["grade"],
          attempts: json["attempts"],
          name: json["name"],
          tags: json["tags"]);

  Map<String, dynamic> toMap() => {
        "sessionID": sessionID,
        "location": location,
        "date": date,
        "isBoulder": isBoulder,
        "grade": grade,
        "attempts": attempts
      };
}

class ClimbPreviewItem {
  final String? climbID;
  final bool isBoulder;
  final double grade;
  final String attempts;
  final String? name;
  final List<String>? tags;

  ClimbPreviewItem(
      {this.climbID,
      required this.isBoulder,
      required this.grade,
      required this.attempts,
      this.name,
      this.tags});

  Map<String, dynamic> toMap(String sessionID) => {
        "sessionID": sessionID,
        "climbId": climbID,
        "isBoulder": isBoulder,
        "grade": grade,
        "name": name,
        "attempts": attempts
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClimbPreviewItem &&
          runtimeType == other.runtimeType &&
          isBoulder == other.isBoulder &&
          grade == other.grade &&
          attempts == other.attempts;

  @override
  int get hashCode => isBoulder.hashCode ^ grade.hashCode ^ attempts.hashCode;

  factory ClimbPreviewItem.fromMap(Map<String, dynamic> json,
          String climbID) => // TODO sessionID make part of it?
      ClimbPreviewItem(
          climbID: climbID,
          isBoulder: json['isBoulder'],
          grade: json["grade"],
          name: json["name"],
          attempts: json["attempts"]);
}
