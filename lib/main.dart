import 'package:flutter/material.dart';
import 'package:climbing_app/pages/listClimbsPage.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'package:climbing_app/pages/logClimbsPage.dart';
import 'package:climbing_app/pages/homePage.dart';
import 'package:flutter/widgets.dart';

//import 'dart:io' show Platform;

Future main() async {
  /*if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
  }*/
  sqfliteFfiInit();
  //WidgetsFlutterBinding.ensureInitialized();

  databaseFactory = databaseFactoryFfi;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.fl
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          '/homePage': (context) => homePage(),
          '/logClimbsPage': (context) => logClimbsPage(),
          '/listClimbsPage': (context) => listClimbsPage(),
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Poppins'),
        home: logClimbsPage());
  }
}
