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
import 'package:climbing_app/models/classModels.dart';

import 'package:climbing_app/firebaseFunctions.dart';

class newSessionPage extends StatefulWidget {
  List<ClimbPreviewItem>? climbPreview;
  String? selectedLocation;
  String? selectedDate;
  String? selectedStyle;
  double? selectedBoulderingGrade;
  double? selectedRopesGrade;
  List<String>? selectedFriends;
  String? selectedNotes;
  //String? selectedAttempts;

  newSessionPage(
      {this.climbPreview,
      this.selectedLocation = '',
      this.selectedDate,
      this.selectedStyle = 'Bouldering',
      this.selectedBoulderingGrade = 0,
      this.selectedRopesGrade = 6,
      this.selectedNotes = '',
      this.selectedFriends});

  @override
  State<newSessionPage> createState() => _newSessionPageState();
}

class _newSessionPageState extends State<newSessionPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late bool isLocationEmpty = false;
  late bool isClimbsEmpty = false;

  /* Drawer logClimbsDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menu',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
            ),
          ),
          ListTile(
            leading: Icon(CupertinoIcons.home),
            title: Text('Home'),
            onTap: () async {
              if (widget.climbPreview!.isNotEmpty) {
                var closed = await showSaveDialog(context) ?? false;
                if (closed == true) {
                  //Navigator.pop(context);
                  Navigator.pushNamed(context, '/homePage');
                } else {
                  Navigator.pop(context);
                }
              } else {
                Navigator.pushNamed(context, '/homePage');
              }
            },
          ),
          ListTile(
            leading: Icon(CupertinoIcons.list_bullet),
            title: Text('List'),
            onTap: () async {
              if (widget.climbPreview!.isNotEmpty) {
                var closed = await showSaveDialog(context) ?? false;
                if (closed == true) {
                  //Navigator.pop(context);
                  Navigator.pushNamed(context, '/listClimbsPage');
                } else {
                  Navigator.pop(context);
                }
              } else {
                Navigator.pushNamed(context, '/listClimbsPage');
              }
            },
          ),
          ListTile(
            leading: Icon(CupertinoIcons.doc),
            title: Text('Log Climbs'),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  } */

  @override
  void initState() {
    super.initState();
    widget.climbPreview = widget.climbPreview ?? [];
    widget.selectedDate =
        widget.selectedDate ?? DateTime.now().toString().split(" ")[0];
    widget.selectedFriends = [];
    //db = DB();
  }

  void updateLocation(text) {
    setState(() {
      if (text == null) {
        widget.selectedLocation = null;
      } else {
        isLocationEmpty = false;
        widget.selectedLocation = text;
      }
    });
  }

  void updateDate(dateTime) {
    setState(() {
      widget.selectedDate = (dateTime).toString();
    });
  }

  void updateStyle(text) {
    setState(() {
      widget.selectedStyle = text;
    });
  }

  void updateGrade(grade) {
    setState(() {
      grade = widget.selectedStyle != 'Bouldering'
          ? widget.selectedRopesGrade = grade
          : widget.selectedBoulderingGrade = grade;
    });
  }

  /*void postSession(context) async {
    if (!locationOptions.contains(widget.selectedLocation)) {
      locationOptions.add(widget.selectedLocation!);
    }
    List<ClimbItem> postedClimbs = widget.climbPreview!.map((climb) {
      return ClimbItem.fromPreview(
          climb, widget.selectedLocation!, widget.selectedDate!);
    }).toList();
    await db.insertClimbs(postedClimbs);
    Navigator.pushNamed(context, '/listClimbsPage');
  }*/

  /*void saveSession() async {
    SessionItem sessionItem = SessionItem(
        location: widget.selectedLocation!, date: widget.selectedDate!);
    await db.insertSession(sessionItem);
    int sessionID = await db.getLastSessionID();
    await db.insertPreview(sessionID, widget.climbPreview!);
  }*/

  void addClimbsToPreview(ClimbPreviewItem climb) {
    setState(() {
      isClimbsEmpty = false;
      widget.climbPreview!.add(climb);
    });
  }

  void editClimbsInPreview(ClimbPreviewItem climb, int index) {
    setState(() {
      widget.climbPreview![index] = climb;
    });
  }

  Future<bool?> showSaveDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            iconPadding: EdgeInsets.all(20),
            icon: Align(
                alignment: Alignment.topRight,
                child: Icon(
                  CupertinoIcons.xmark,
                  color: Colors.black,
                  size: 20,
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
                    Navigator.pop(context, false);
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
                          Navigator.pop(context, true);
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
        bottomNavigationBar: NavBottomBar(),
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              IconButton(
                icon: Icon(CupertinoIcons.xmark),
                onPressed: () => {showSaveDialog(context)},
              ),
              SizedBox(width: 5),
              Text(
                'New Session',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton(
                      child: Text(
                        'Post',
                        style: TextStyle(
                            color: Color(0xff007BDD),
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        if (widget.selectedLocation != '' &&
                            widget.climbPreview!.isNotEmpty) {
                          List<double> grades = [];
                          for (var climb in widget.climbPreview!) {
                            grades.add(climb.isBoulder
                                ? climb.grade
                                : climb.grade * -1);
                          }
                          var session = SessionItem(
                              location: widget.selectedLocation!,
                              date: widget.selectedDate!,
                              friends: widget.selectedFriends,
                              notes: widget.selectedNotes,
                              climbs: widget.climbPreview!,
                              grades: grades);
                          postSession(session);
                          Navigator.pop(context, true);
                          Navigator.pushNamed(context, '/listClimbsPage');
                        }
                        if (widget.selectedLocation == '') {
                          setState(() {
                            isLocationEmpty = true;
                          });
                        }
                        if (widget.climbPreview!.isEmpty) {
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
              selectedLocation: widget.selectedLocation,
              onLocationChanged: updateLocation,
            ),
            isLocationEmpty
                ? Text(
                    'Add climbing location to post session',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w700),
                  )
                : SizedBox(height: 20),
            SizedBox(height: 10),
            dateSection(
              selectedDateString: widget.selectedDate,
              onDateChanged: updateDate,
            ),
            SizedBox(
              height: 30,
            ),
            friendsSection(
                selectedFriends: widget.selectedFriends!,
                onFriendChanged: (String _) {}),
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
                        height: 60,
                        width: 190,
                        child: Text(
                          textAlign: TextAlign.center,
                          softWrap: true,
                          'You haven\'t added any climbs to this session',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        )))
                : Expanded(child: climbsPreviewList())
          ]),
        ));
  }

  ListView climbsPreviewList() {
    return ListView.separated(
        shrinkWrap: true,
        itemCount: widget.climbPreview!.length,
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
                        color: widget.climbPreview![index].isBoulder
                            ? utils.setBoulderingColor(
                                widget.climbPreview![index].grade)
                            : utils.setRopesColor(
                                widget.climbPreview![index].grade)),
                    shape: BoxShape.circle),
                child: Container(
                  width: 50,
                  child: Align(
                    child: AutoSizeText(
                      minFontSize: 10,
                      maxLines: 1,
                      //overflow: TextOverflow.ellipsis,
                      widget.climbPreview![index].isBoulder
                          ? 'V' +
                              widget.climbPreview![index].grade
                                  .toStringAsFixed(0)
                          : utils.setRopesGradeText(
                              widget.climbPreview![index].grade),
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
              Container(
                  width: 160,
                  child: widget.climbPreview![index].name == null
                      ? Text(
                          widget.climbPreview![index].attempts,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              widget.climbPreview![index].name!,
                              maxLines: 1,
                              minFontSize: 8,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              widget.climbPreview![index].attempts,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        )),
              SizedBox(width: 5),
              Expanded(
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => newClimbPage(
                              isUpdate: true,
                              isBoulder: true,
                              selectedGrade: widget.climbPreview![index].grade,
                              selectedAttempts:
                                  widget.climbPreview![index].attempts,
                              selectedName: widget.climbPreview![index].name,
                              onAddClimbsToPreview: (climb) =>
                                  {editClimbsInPreview(climb, index)},
                            ),
                          ),
                        );
                      });
                    },
                    icon: Icon(
                      CupertinoIcons.pencil,
                      color: Colors.blue,
                    )),
                IconButton(
                    onPressed: () {
                      setState(() {
                        widget.climbPreview!.removeAt(index);
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
