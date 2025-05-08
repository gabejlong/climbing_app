import 'package:climbing_app/models/climbModels.dart';

class SessionItem {
  final String? sessionId;
  bool inProgress;
  final String location;
  final String date;
  final String? type;
  final List<String>? friends;
  final String? notes;
  final List<double>? grades;
  final List<ClimbPreviewItem> climbs;

  SessionItem({
    this.sessionId,
    required this.inProgress,
    required this.location,
    required this.date,
    this.type,
    this.friends,
    this.notes,
    this.grades,
    required this.climbs,
  });

  Map<String, dynamic> toMap() => {
        "id": sessionId,
        "inProgress": inProgress,
        "location": location,
        "date": date,
        "type": type,
        "grades": grades!.map((e) => e.toDouble()).toList(),
      };

  factory SessionItem.fromMap(
          Map<String, dynamic> json, climbs, String sessionID) =>
      SessionItem(
        sessionId: sessionID,
        inProgress: json['inProgress'],
        location: json["location"],
        date: json["date"],
        type: json["type"],
        friends: [],
        notes: json["notes"],
        climbs: climbs,
        grades: (json["grades"] as List<dynamic>)
            .map((e) => (e as num).toDouble())
            .toList(),
      );

  SessionPreviewItem toEditItem() {
    return SessionPreviewItem(
      sessionId: sessionId,
      location: location,
      inProgress: inProgress,
      date: date,
      friends: friends,
      notes: notes,
      climbs: climbs,
    );
  }
}

class SessionPreviewItem {
  String? sessionId;
  String? location;
  String date;
  List<String>? friends;
  String? notes;
  bool? inProgress;
  List<ClimbPreviewItem> climbs;

  SessionPreviewItem({
    this.sessionId,
    this.location,
    required this.date,
    this.friends,
    this.inProgress,
    this.notes,
    required this.climbs,
  });

  SessionPreviewItem.empty()
      : sessionId = null,
        location = '',
        date = DateTime.now().toString().split(" ")[0],
        friends = [],
        inProgress = false,
        notes = '',
        climbs = [];
  /*Map<String, dynamic> toMap() => {
        "id": sessionId, "location": location, "date": date, "type": type,
      };*/

  factory SessionPreviewItem.fromMap(Map<String, dynamic> json, climbs) =>
      SessionPreviewItem(
        sessionId: json['id'],
        location: json["location"],
        date: json["date"],
        inProgress: json['inProgress'],
        friends: [],
        notes: json["notes"],
        climbs: climbs,
      );

  SessionItem toFinalItem() {
    return SessionItem(
        sessionId: sessionId!,
        inProgress: inProgress!,
        location: location!,
        date: date,
        climbs: climbs);
  }
}

class SessionReadItem {
  final String sessionID;
  final bool inProgress;
  final String location;
  final String date;
  final String type;
  final List<double> grades;

  SessionReadItem(
      {required this.sessionID,
      required this.inProgress,
      required this.location,
      required this.date,
      required this.type,
      required this.grades});

  Map<String, dynamic> toMap() => {
        "id": sessionID,
        "inProgress": inProgress,
        "location": location,
        "date": date,
        "grades": grades.map((e) => e.toDouble()).toList(),
      };

  factory SessionReadItem.fromMap(
          Map<String, dynamic> json, String sessionID) =>
      SessionReadItem(
        sessionID: sessionID,
        inProgress: json['inProgress'],
        location: json["location"],
        date: json["date"],
        type: json["type"],
        grades: (json["grades"] as List<dynamic>)
            .map((e) => (e as num).toDouble())
            .toList(),
      );
}
