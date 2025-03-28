import 'package:climbing_app/main.dart';
import 'package:climbing_app/models/classModels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<List<SessionReadItem>> getSessions(String userID) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<SessionReadItem> sessions = [];

  QuerySnapshot allSessionsSnapshot = await firestore
      .collection('users')
      .doc(userID)
      .collection('sessions')
      .get();

  for (var sessionDoc in allSessionsSnapshot.docs) {
    SessionReadItem session =
        SessionReadItem.fromMap(sessionDoc.data() as Map<String, dynamic>);
    sessions.add(session);
  }
  return sessions;
}

Future<List<ClimbPreviewItem>> getSessionClimbs(
    String userID, String sessionID) async {
  List<ClimbPreviewItem> climbs = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  QuerySnapshot sessionSnapshot = await firestore
      .collection('users')
      .doc(userID)
      .collection('sessions')
      .doc(sessionID)
      .collection('climbs')
      .get();
  for (var climbDoc in sessionSnapshot.docs) {
    climbs
        .add(ClimbPreviewItem.fromMap(climbDoc.data() as Map<String, dynamic>));
  }

  return climbs;
}

Future<List<ClimbReadItem>> getAllClimbs(
    String userID, Filters selectedFilters) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<ClimbReadItem> climbs = [];
  print(selectedFilters.lowGrade);
  QuerySnapshot allSessionsSnapshot = await firestore
      .collection('users')
      .doc(userID)
      .collection('sessions')
      .get();

  for (var sessionDoc in allSessionsSnapshot.docs) {
    String sessionId = sessionDoc.id;
    String sessionLocation = sessionDoc['location'];
    String sessionDate = sessionDoc['date'];

    CollectionReference climbsRef = firestore
        .collection('users')
        .doc(userID)
        .collection('sessions')
        .doc(sessionId)
        .collection('climbs');
    Query query = climbsRef;
    print(selectedFilters.selectedAttemptsFilters);

    query =
        query.where('grade', isGreaterThanOrEqualTo: selectedFilters.lowGrade);
    query =
        query.where('grade', isLessThanOrEqualTo: selectedFilters.highGrade);
    if (selectedFilters.selectedAttemptsFilters.isNotEmpty) {
      query = query.where('attempts',
          whereIn: selectedFilters.selectedAttemptsFilters.toList());
    }
    QuerySnapshot querySnapshot = await query.get();

    for (var climbDoc in querySnapshot.docs) {
      climbs.add(ClimbReadItem.fromMap(climbDoc.data() as Map<String, dynamic>,
          sessionLocation, sessionDate));
    }
  }
  return climbs;
}

Future<int> getAllClimbsCount(String userID) async {
  return 5;
}

void postSession(SessionItem session) async {
  String sessionID = await insertSession(session);
  for (var climb in session.climbs) {
    insertClimb(sessionID, climb);
  }
}

Future<UserInfo> getUserInfo(String userID) async {
  /*FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentSnapshot userRef =
      await firestore.collection("users").doc(userID).get();
  return UserInfo.fromMap(userRef.data() as Map<String, dynamic>);*/
  return UserInfo(
      userID: "long.climber",
      name: "Gabriel Long",
      email: "gabrieljzlong@gmail.com",
      bio: "I LOVE to climb!",
      password: "abc",
      location: "Waterloo, ON");
}

String userID = 'long.climber';

Future<String> insertSession(SessionItem session) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference sessionRef = await firestore
      .collection("users")
      .doc(userID)
      .collection("sessions")
      .add(session.toMap());
  return sessionRef.id;
}

Future<void> insertClimb(String sessionID, ClimbPreviewItem climb) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference sessionRef = await firestore
      .collection("users")
      .doc(userID)
      .collection("sessions")
      .doc(sessionID)
      .collection("climbs")
      .add(climb.toMap());
  return;
}

Future<int> getFollowers(String userID) async {
  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  //DocumentReference sessionRef = await firestore;
  return 5;
}

Future<int> getFollowing(String userID) async {
  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  //DocumentReference sessionRef = await firestore;
  return 10;
}
