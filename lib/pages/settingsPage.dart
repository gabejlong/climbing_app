import 'package:auto_size_text/auto_size_text.dart';
import 'package:climbing_app/widgets/nameSection.dart';
import 'package:climbing_app/widgets/notesSection.dart';
import 'package:climbing_app/widgets/friendsSection.dart';
import 'package:climbing_app/widgets/navDrawer.dart';
import 'package:climbing_app/widgets/tagsSection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'package:climbing_app/widgets/locationSection.dart';
import 'package:climbing_app/widgets/dateSection.dart';
import 'package:climbing_app/widgets/climbingStylesSection.dart';
import 'package:climbing_app/widgets/gradesSection.dart';
import 'package:climbing_app/widgets/attemptsSection.dart';

import 'package:climbing_app/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:climbing_app/models/lists_model.dart';
import 'package:climbing_app/models/allModels.dart';
import 'package:firebase_auth/firebase_auth.dart';

class settingsPage extends StatefulWidget {
  settingsPage({super.key});

  @override
  State<settingsPage> createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? uID;
  @override
  void initState() {
    getData();

    super.initState();
  }

  void getData() {
    if (FirebaseAuth.instance.currentUser != null) {
      uID = FirebaseAuth.instance.currentUser?.uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: NavBottomBar(),
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Container(
            padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Text('This is your account ' + uID!),
              TextButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamed(context, '/welcomePage');
                  },
                  child: Text('Sign Out'))
            ])));
  }
}
