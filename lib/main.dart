import 'package:climbing_app/pages/activityPage.dart';
import 'package:climbing_app/pages/loginPages/accountSetUpPage.dart';
import 'package:climbing_app/pages/loginPages/loginPage.dart';
import 'package:climbing_app/pages/loginPages/welcomePage.dart';
import 'package:climbing_app/pages/sessionViewPage.dart';
import 'package:climbing_app/pages/settingsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'package:climbing_app/pages/listClimbsPage.dart';
import 'package:climbing_app/pages/newClimbPage.dart';
import 'package:climbing_app/pages/newSessionPage.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:climbing_app/pages/profilePage.dart';
import 'package:climbing_app/pages/activityPage.dart';
import 'package:climbing_app/pages/statsPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

bool isLoggedIn = false;
//import 'dart:io' show Platform;
Future main() async {
  /*if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
  }*/
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user != null) {
      isLoggedIn = true;
    }
  });
  //sqfliteFfiInit();

  // TODO line should be disabled if android
  // databaseFactory = databaseFactoryFfi;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.fl
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          '/newSessionPage': (context) => newSessionPage(),
          '/listClimbsPage': (context) => listClimbsPage(),
          '/profilePage': (context) => profilePage(
                userID: FirebaseAuth.instance.currentUser!.uid,
              ),
          '/activityPage': (context) => activityPage(),
          '/statsPage': (context) => statsPage(),
          '/settingsPage': (context) => settingsPage(),
          '/welcomePage': (context) => welcomePage(),
          '/loginPage': (context) => loginPage(),
          '/accountSetUpPage': (context) => accountSetUpPage()
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: Colors.black,
            onPrimary: Colors.white,
            secondary: Colors.white,
            onSecondary: Colors.black,
            error: Colors.red,
            onError: Colors.white,
            background: Colors.white,
            onBackground: Colors.black,
            surface: Colors.white,
            onSurface: Colors.black,
          ),
          fontFamily: 'PlusJakartaSans',
        ),
        home: isLoggedIn ? statsPage() : welcomePage());
  }
}
