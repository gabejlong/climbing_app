class Filters {
  String selectedSort;
  double lowGrade;
  double highGrade;
  Set<String> selectedTypeFilters = {};
  Set<String> selectedAttemptsFilters = {};
  Set<String> selectedLocationFilters = {};
  Set<String> selectedTagsFilters = {};

  Filters({
    this.selectedSort = 'Old to New',
    this.lowGrade = 0,
    this.highGrade = 17,
    Set<String>? selectedTypeFilters,
    Set<String>? selectedAttemptsFilters,
    Set<String>? selectedLocationFilters,
    Set<String>? selectedTagsFilters,
  })  : selectedTypeFilters = selectedTypeFilters ?? {},
        selectedAttemptsFilters = selectedAttemptsFilters ?? {},
        selectedLocationFilters = selectedLocationFilters ?? {},
        selectedTagsFilters = selectedTagsFilters ?? {};

  List<String> toList() {
    List<String> filters = [];
    print(lowGrade.toString() + " hihihihihi " + highGrade.toString());
    if (!(lowGrade == 0.0 && highGrade == 17.0)) {
      print("YUHUH");
      filters.add(("V " +
          lowGrade.toStringAsFixed(0) +
          " to V" +
          highGrade.toStringAsFixed(0)));
    }
    filters.addAll(selectedTypeFilters.toList());
    filters.addAll(selectedAttemptsFilters.toList());
    filters.addAll(selectedLocationFilters.toList());
    filters.addAll(selectedTagsFilters.toList());
    return filters;
  }
}

class ClimbReadItem {
  final int? id;
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
      {this.id,
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
          id: json['id'],
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
        "id": id,
        "location": location,
        "date": date,
        "isBoulder": isBoulder,
        "grade": grade,
        "attempts": attempts
      };
}

class SessionItem {
  final int? sessionId;
  final String location;
  final String date;
  final List<String>? friends;
  final String? notes;
  final List<ClimbPreviewItem> climbs;
  final List<double> grades;

  SessionItem(
      {this.sessionId,
      required this.location,
      required this.date,
      this.friends,
      this.notes,
      required this.climbs,
      required this.grades});

  Map<String, dynamic> toMap() => {
        "id": sessionId, "location": location, "date": date,
        "grades":
            grades.map((e) => e.toDouble()).toList(), // Convert to List<double>
      };

  factory SessionItem.fromMap(Map<String, dynamic> json) => SessionItem(
        sessionId: json['id'],
        location: json["location"],
        date: json["date"],
        friends: json["json"],
        notes: json["notes"],
        climbs: [],
        grades: (json["grades"] as List<dynamic>)
            .map((e) => (e as num).toDouble())
            .toList(),
      );
}

class SessionReadItem {
  final int? sessionId;
  final String location;
  final String date;
  final List<double> grades;

  SessionReadItem(
      {this.sessionId,
      required this.location,
      required this.date,
      required this.grades});

  Map<String, dynamic> toMap() => {
        "id": sessionId, "location": location, "date": date,
        "grades":
            grades.map((e) => e.toDouble()).toList(), // Convert to List<double>
      };

  factory SessionReadItem.fromMap(Map<String, dynamic> json) => SessionReadItem(
        sessionId: json['id'],
        location: json["location"],
        date: json["date"],
        grades: (json["grades"] as List<dynamic>)
            .map((e) => (e as num).toDouble())
            .toList(),
      );
}

class ClimbPreviewItem {
  final int? id;
  final bool isBoulder;
  final double grade;
  final String attempts;
  final String? name;
  final List<String>? tags;

  ClimbPreviewItem(
      {this.id,
      required this.isBoulder,
      required this.grade,
      required this.attempts,
      this.name,
      this.tags});

  Map<String, dynamic> toMap() => {
        "id": id,
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

  factory ClimbPreviewItem.fromMap(Map<String, dynamic> json) =>
      ClimbPreviewItem(
          id: json['id'],
          isBoulder: json['isBoulder'],
          grade: json["grade"],
          name: json["name"],
          attempts: json["attempts"]);
}

class UserInfo {
  String userID;
  String name;
  String email;
  String password;
  String bio;
  String location;

  UserInfo(
      {required this.userID,
      required this.name,
      required this.email,
      required this.password,
      required this.bio,
      required this.location});

  Map<String, dynamic> toMap() => {
        "userID": userID,
        "name": name,
        "email": email,
        "password": password,
        "bio": bio,
        "location": location
      };

  factory UserInfo.fromMap(Map<String, dynamic> json) => UserInfo(
        userID: json['userID'],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        bio: json["bio"],
        location: json["location"],
      );
}
