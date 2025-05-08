import 'package:climbing_app/models/allModels.dart';
import 'package:climbing_app/models/filtersModels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<UserItem> getUser(String uID) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentSnapshot userRef = await firestore.collection("users").doc(uID).get();
  return UserItem.fromMap(userRef.data() as Map<String, dynamic>, uID);
}

void addUser(UserItem userItem) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  await firestore
      .collection("users")
      .doc(userItem.userID)
      .set(userItem.toMap());
}
