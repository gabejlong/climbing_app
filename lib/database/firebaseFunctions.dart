import 'package:climbing_app/models/allModels.dart';
import 'package:climbing_app/models/filtersModels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<SessionReadItem>> getSessions(
    String userID, bool inProgress) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<SessionReadItem> sessions = [];

  QuerySnapshot allSessionsSnapshot = await firestore
      .collection('users')
      .doc(userID)
      .collection('sessions')
      .where('inProgress', isEqualTo: inProgress)
      .get();

  for (var sessionDoc in allSessionsSnapshot.docs) {
    SessionReadItem session = SessionReadItem.fromMap(
        sessionDoc.data() as Map<String, dynamic>, sessionDoc.id);
    sessions.add(session);
  }
  return sessions;
}

Future<SessionItem> getSession(String userID, String sessionID) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentSnapshot snapshot = await firestore
      .collection('users')
      .doc(userID)
      .collection('sessions')
      .doc(sessionID)
      .get();
  List<ClimbPreviewItem> climbs = await getSessionClimbs(userID, sessionID);
  SessionItem session = SessionItem.fromMap(
      snapshot.data() as Map<String, dynamic>, climbs, sessionID);
  return session;
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
    climbs.add(ClimbPreviewItem.fromMap(
        climbDoc.data() as Map<String, dynamic>, climbDoc.id));
  }

  return climbs;
}

void deleteSession(String uID, String sessionID) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(uID)
      .collection('sessions')
      .doc(sessionID)
      .delete();
}

Future<List<ClimbReadItem>> getAllClimbs(
    String userID, BaseFilters selectedFilters) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<ClimbReadItem> climbs = [];
  QuerySnapshot allSessionsSnapshot = await firestore
      .collection('users')
      .doc(userID)
      .collection('sessions')
      .where('inProgress', isEqualTo: false)
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
    if (selectedFilters.selectedTypeFilters.isNotEmpty) {
      query = query.where('type',
          whereIn: selectedFilters.selectedTypeFilters.toList());
    }
    if (selectedFilters.selectedLocationFilters.isNotEmpty) {
      query = query.where('location',
          whereIn: selectedFilters.selectedLocationFilters.toList());
    }
    // TODO sort by
    if (selectedFilters is ClimbFilters) {
      query = query.where('grade',
          isGreaterThanOrEqualTo: selectedFilters.lowGrade);
      query =
          query.where('grade', isLessThanOrEqualTo: selectedFilters.highGrade);
      if (selectedFilters.selectedAttemptsFilters.isNotEmpty) {
        query = query.where('attempts',
            whereIn: selectedFilters.selectedAttemptsFilters.toList());
      }
      if (selectedFilters.selectedTagsFilters.isNotEmpty) {
        query = query.where('tags',
            whereIn: selectedFilters.selectedTagsFilters.toList());
      }
    }

    QuerySnapshot querySnapshot = await query.get();

    for (var climbDoc in querySnapshot.docs) {
      climbs.add(ClimbReadItem.fromMap(climbDoc.data() as Map<String, dynamic>,
          sessionLocation, sessionDate));
    }
  }
  return climbs;
}

Future<int> getAllSessionsCount(String userID) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot query = await firestore
      .collection("users")
      .doc(userID)
      .collection("sessions")
      .where('inProgress', isEqualTo: false)
      .get();
  return query.size;
}

Future<int> getAllClimbsCount(String userID) async {
  int totalCount = 0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot sessions = await firestore
      .collection("users")
      .doc(userID)
      .collection("sessions")
      .where('inProgress', isEqualTo: false)
      .get();
  for (var sessionDoc in sessions.docs) {
    CollectionReference climbsRef =
        await sessionDoc.reference.collection("climbs");
    QuerySnapshot query = await climbsRef.get();
    totalCount += query.size;
  }
  return totalCount;
}

void postSession(SessionItem session, String uID) async {
  String sessionID = await insertSession(session, uID);
  for (var climb in session.climbs) {
    insertClimb(sessionID, climb, uID);
  }
}

void updateSession(SessionItem session, String uID) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  await firestore
      .collection("users")
      .doc(uID)
      .collection("sessions")
      .doc(session.sessionId.toString())
      .set(session.toMap());

  for (var climb in session.climbs) {
    insertClimb(session.sessionId!, climb, uID);
  }
}

Future<String> insertSession(SessionItem session, uID) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference sessionRef = await firestore
      .collection("users")
      .doc(uID)
      .collection("sessions")
      .add(session.toMap());
  return sessionRef.id;
}

Future<void> insertClimb(
    String sessionID, ClimbPreviewItem climb, String uID) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  await firestore
      .collection("users")
      .doc(uID)
      .collection("sessions")
      .doc(sessionID)
      .collection("climbs")
      .doc(climb.climbID)
      .set(climb.toMap(sessionID));
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
