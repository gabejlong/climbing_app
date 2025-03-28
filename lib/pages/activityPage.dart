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
import 'package:climbing_app/models/classModels.dart';

class activityPage extends StatefulWidget {
  activityPage({super.key});

  @override
  State<activityPage> createState() => _profilePageState();
}

class _profilePageState extends State<activityPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: NavBottomBar(),
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Text(
                    'Activity',
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
                  )
                ],
              )
            ])));
  }
}
