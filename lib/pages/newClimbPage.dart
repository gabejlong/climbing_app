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

class newClimbPage extends StatefulWidget {
  final Function(ClimbPreviewItem) onAddClimbsToPreview;
  bool isUpdate;
  bool isBoulder;
  double? selectedGrade;
  String? selectedAttempts;
  String? selectedName;
  String? selectedTags;

  newClimbPage(
      {required this.isUpdate,
      required this.isBoulder,
      required this.onAddClimbsToPreview,
      this.selectedGrade,
      this.selectedName,
      this.selectedAttempts = 'Flash',
      this.selectedTags = 'Slab'});

  @override
  State<newClimbPage> createState() => _newClimbPageState();
}

class _newClimbPageState extends State<newClimbPage> {
  var previewMap = Map();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //late DB db;
  List<String>? tagsList = [];

  @override
  void initState() {
    super.initState();
    widget.selectedGrade ??= widget.isBoulder ? 0.0 : 6.0;
  }

  void updateGrade(grade) {
    setState(() {
      widget.selectedGrade = grade;
    });
  }

  void updateAttempts(text) {
    setState(() {
      widget.selectedAttempts = text;
    });
  }

  void updateName(text) {
    setState(() {
      widget.selectedName = text;
    });
  }

  void updateTags(text) {
    setState(() {
      widget.selectedTags = text;
    });
  }

  void addClimbstoPreview() {
    setState(() {
      widget.onAddClimbsToPreview(ClimbPreviewItem(
          isBoulder: widget.isBoulder,
          grade: widget.selectedGrade!,
          name: widget.selectedName,
          tags: tagsList,
          attempts: widget.selectedAttempts!));
    });
  }

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
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              IconButton(
                icon: Icon(CupertinoIcons.chevron_back),
                onPressed: () => {Navigator.pop(context)},
              ),
              Text(
                (widget.isUpdate ? 'Edit ' : 'New ') +
                    (widget.isBoulder ? 'Boulder' : 'Route'),
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton(
                    child: Text(
                      widget.isUpdate ? 'Update' : 'Add',
                      style: TextStyle(
                          color: Color(0xff007BDD),
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      addClimbstoPreview();
                      Navigator.pop(context);
                    },
                  ),
                ]),
              )
            ]),
            SizedBox(
              height: 25,
            ),
            gradesSection(
                isBoulder: widget.isBoulder,
                selectedGrade: widget.selectedGrade!,
                onGradeChanged: updateGrade),
            SizedBox(
              height: 30,
            ),
            attemptsSection(
              selectedAttempts: widget.selectedAttempts,
              onAttemptsChanged: updateAttempts,
            ),
            SizedBox(
              height: 30,
            ),
            nameSection(
              selectedName: widget.selectedName,
              onNameChanged: updateName,
            ),
            SizedBox(height: 20),
            tagsSection(
              selectedTags: widget.selectedTags,
              onTagsChanged: updateTags,
            ),
            /*
            addClimbsButton(
              completed: widget.selectedLocation != null,
              onAddClimbsToPreview: addClimbstoPreview,
            ),
            //Text(uniqueClimbs.toString()),
            SizedBox(height: 10),*/
            SizedBox(
              height: 10,
            )
          ]),
        ));
  }
}

AppBar appBar(key) {
  return AppBar(
    leading: IconButton(
        onPressed: () {
          key.currentState?.openDrawer();
        },
        icon: Icon(
          CupertinoIcons.bars,
          color: Colors.white,
          size: 30,
        )),
    title: Text(
      'Log Climbs',
      style: TextStyle(
          color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
    ),
    backgroundColor: Colors.blue,
    elevation: 0.0,
    centerTitle: true,
  );
}

class addClimbsButton extends StatefulWidget {
  final bool completed;
  final VoidCallback onAddClimbsToPreview;

  addClimbsButton(
      {required this.completed, required this.onAddClimbsToPreview});

  @override
  State<addClimbsButton> createState() => _addClimbsState();
}

class _addClimbsState extends State<addClimbsButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 40,
        child: TextButton(
          onPressed:
              widget.completed == true ? widget.onAddClimbsToPreview : null,
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
            backgroundColor: widget.completed == true
                ? MaterialStateProperty.all(Colors.blue)
                : MaterialStateProperty.all(Colors.grey),
          ),
          child: Text(
            'Add Climb',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ));
  }
}
