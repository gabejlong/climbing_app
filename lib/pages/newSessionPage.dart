import 'package:auto_size_text/auto_size_text.dart';
import 'package:climbing_app/pages/newClimbPage.dart';
import 'package:climbing_app/widgets/notesSection.dart';
import 'package:climbing_app/widgets/friendsSection.dart';
import 'package:climbing_app/widgets/navDrawer.dart';
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

import 'package:climbing_app/database/firebaseFunctions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class newSessionPage extends StatefulWidget {
  String? sessionID;

  newSessionPage({this.sessionID});

  @override
  State<newSessionPage> createState() => _newSessionPageState();
}

class _newSessionPageState extends State<newSessionPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late bool isLocationEmpty = false;
  late bool isClimbsEmpty = false;

  List<ClimbPreviewItem>? climbPreview = [];
  SessionPreviewItem session = SessionPreviewItem.empty();
  late bool isEdit;
  bool isLoading = true;
  String? uID;

  @override
  void initState() {
    isEdit = widget.sessionID != null;
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      uID = FirebaseAuth.instance.currentUser?.uid;
    }
    if (widget.sessionID != null) {
      loadSession();
    } else {
      isLoading = false;
    }
  }
  // loading session we need to set all these variables to the session
  // loading null they need to be set

  void updateLocation(text) {
    setState(() {
      if (text == null) {
        session.location = null;
      } else {
        isLocationEmpty = false;
        session.location = text;
      }
    });
  }

  void updateDate(dateTime) {
    setState(() {
      session.date = (dateTime).toString();
    });
  }

  void addClimbsToPreview(ClimbPreviewItem climb) {
    setState(() {
      isClimbsEmpty = false;
      session.climbs.add(climb);
    });
  }

  void editClimbsInPreview(ClimbPreviewItem climb, int index) {
    setState(() {
      session.climbs[index] = climb;
    });
  }

  void finalizeSession(bool inProgress) {
    List<double> grades = [];
    bool hasBoulder = false;
    bool hasRopes = false;
    for (var climb in session.climbs) {
      grades.add(climb.isBoulder ? climb.grade : climb.grade * -1);
      if (climb.isBoulder == true) {
        hasBoulder = true;
      } else if (climb.isBoulder == false) {
        hasRopes = false;
      }
    }

    var finalSession = SessionItem(
      sessionId: session.sessionId,
      inProgress: inProgress,
      location: session.location!,
      date: session.date,
      grades: grades,
      type: hasBoulder && hasRopes
          ? "Mixed"
          : hasBoulder
              ? "Boulder"
              : "Route",
      friends: session.friends,
      notes: session.notes,
      climbs: session.climbs,
    );
    isEdit
        ? updateSession(finalSession, uID!)
        : postSession(finalSession, uID!);
  }

  Future<bool?> showSaveDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            iconPadding: EdgeInsets.all(20),
            icon: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    CupertinoIcons.xmark,
                    color: Colors.black,
                    size: 20,
                  ),
                )),
            insetPadding: EdgeInsets.all(2),
            title: Text(
              'Save progress?',
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text(
              'All session information will be lost.',
              style: TextStyle(color: Color(0xff222222)),
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: <Widget>[
              Row(children: [
                TextButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                      overlayColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 212, 212, 212))),
                  onPressed: () {
                    finalizeSession(true);
                    Navigator.pop(context, false);
                    Navigator.pushNamed(context, '/listClimbsPage');
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(color: Color(0xff007BDD)),
                  ),
                ),
                SizedBox(width: 5),
                SizedBox(
                    child: OutlinedButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 212, 212, 212)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          side: MaterialStateProperty.all(
                              BorderSide(width: 1, color: Colors.red)),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/listClimbsPage');
                        },
                        child: Text(
                          'Delete Session',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w600),
                        ))),
                SizedBox(
                  width: 10,
                ),
              ])
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        //bottomNavigationBar: NavBottomBar(),
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: isLoading
            ? Center(
                child: Container(
                    padding: EdgeInsets.only(top: 40),
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    )))
            : sessionPage());
  }

  void loadSession() async {
    session = (await getSession(uID!, widget.sessionID!)).toEditItem();

    setState(() {
      isLoading = false;
    });
  }

  Container sessionPage() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          IconButton(
            icon: Icon(CupertinoIcons.xmark),
            onPressed: () => {
              if (session.climbs.isNotEmpty)
                {showSaveDialog(context)}
              else
                {Navigator.pushNamed(context, '/listClimbsPage')}
            },
          ),
          SizedBox(width: 5),
          Text(
            isEdit ? 'Edit Session' : 'New Session',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(
                  child: Text(
                    isEdit
                        ? session.inProgress!
                            ? 'Post'
                            : 'Update'
                        : 'Post',
                    style: TextStyle(
                        color: Color(0xff007BDD),
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    if (session.location != '' && session.climbs.isNotEmpty) {
                      finalizeSession(false);
                      Navigator.pop(context, true);
                      Navigator.pushNamed(context, '/listClimbsPage');
                    }
                    if (session.location == '') {
                      setState(() {
                        isLocationEmpty = true;
                      });
                    }
                    if (session.climbs.isEmpty) {
                      setState(() {
                        isClimbsEmpty = true;
                      });
                    } else {}
                  }),
            ]),
          )
        ]),
        SizedBox(
          height: 25,
        ),
        locationSection(
          selectedLocation: session.location,
          onLocationChanged: updateLocation,
        ),
        isLocationEmpty
            ? Text(
                'Add climbing location to post session',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
              )
            : SizedBox(height: 20),
        SizedBox(height: 10),
        dateSection(
          selectedDateString: session.date,
          onDateChanged: updateDate,
        ),
        SizedBox(
          height: 30,
        ),
        friendsSection(
            selectedFriends: session.friends, onFriendChanged: (String _) {}),
        SizedBox(
          height: 30,
        ),
        notesSection(selectedNotes: (), onNotesChanged: (String _) {}),
        SizedBox(
          height: 30,
        ),
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(
            'Climbs',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton.icon(
                    label: Text(
                      'Boulder',
                      style: TextStyle(
                          color: Color(0xff007BDD),
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    icon: Icon(
                      CupertinoIcons.add,
                      color: Color(0xff007BDD),
                      size: 16,
                    ),
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => newClimbPage(
                            isUpdate: false,
                            isBoulder: true,
                            onAddClimbsToPreview: addClimbsToPreview,
                          ),
                        ),
                      )
                    },
                  ),
                  TextButton.icon(
                      label: Text(
                        'Route',
                        style: TextStyle(
                            color: Color(0xff007BDD),
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      icon: Icon(
                        CupertinoIcons.add,
                        color: Color(0xff007BDD),
                        size: 18,
                      ),
                      onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => newClimbPage(
                                  isUpdate: false,
                                  isBoulder: false,
                                  onAddClimbsToPreview: addClimbsToPreview,
                                ),
                              ),
                            )
                          })
                ]),
          )
        ]),
        isClimbsEmpty
            ? Center(
                heightFactor: 4,
                child: Container(
                    height: 53.5,
                    width: 190,
                    child: Text(
                      textAlign: TextAlign.center,
                      softWrap: true,
                      'You haven\'t added any climbs to this session',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    )))
            : Expanded(child: climbsPreviewList()),
        Center(
            child: TextButton(
                onPressed: () {
                  if (session.sessionId != null) {
                    deleteSession(uID!, session.sessionId!);
                  }
                  if (session.climbs.isNotEmpty) {
                    showSaveDialog(context);
                  } else {
                    Navigator.pushNamed(context, '/listClimbsPage');
                  }
                },
                child: Text(
                  'Delete Session',
                  style: TextStyle(
                      color: Color.fromARGB(255, 221, 0, 0),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )))
      ]),
    );
  }

  ListView climbsPreviewList() {
    return ListView.separated(
        shrinkWrap: true,
        itemCount: session.climbs.length,
        scrollDirection: Axis.vertical,
        separatorBuilder: (context, index) => Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Divider(
                  height: 5,
                  color: Colors.grey,
                )
              ],
            ),
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 4,
                        color: session.climbs[index].isBoulder
                            ? utils
                                .setBoulderingColor(session.climbs[index].grade)
                            : utils.setRopesColor(session.climbs[index].grade)),
                    shape: BoxShape.circle),
                child: Container(
                  width: 50,
                  child: Align(
                    child: AutoSizeText(
                      minFontSize: 10,
                      maxLines: 1,
                      //overflow: TextOverflow.ellipsis,
                      session.climbs[index].isBoulder
                          ? 'V' + session.climbs[index].grade.toStringAsFixed(0)
                          : utils
                              .setRopesGradeText(session.climbs[index].grade),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 0.8 // Increase for extra boldness
                          ..color = Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              InkWell(
                  onTap: () {
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => newClimbPage(
                            isUpdate: true,
                            isBoulder: true,
                            selectedGrade: session.climbs[index].grade,
                            selectedAttempts: session.climbs[index].attempts,
                            selectedName: session.climbs[index].name,
                            onAddClimbsToPreview: (climb) =>
                                {editClimbsInPreview(climb, index)},
                          ),
                        ),
                      );
                    });
                  },
                  child: Container(
                      width: 160,
                      child: session.climbs[index].name == null
                          ? Text(
                              session.climbs[index].attempts,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  session.climbs[index].name!,
                                  maxLines: 1,
                                  minFontSize: 8,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  session.climbs[index].attempts,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ))),
              SizedBox(width: 5),
              Expanded(
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        session.climbs.removeAt(index);
                      });
                    },
                    icon: Icon(
                      CupertinoIcons.trash,
                      color: Colors.red,
                    )),
                SizedBox(width: 5),
              ]))
            ],
          );
        });
  }
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
