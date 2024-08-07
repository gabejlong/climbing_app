import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'package:climbing_app/widgets/locationSection.dart';
import 'package:climbing_app/widgets/dateSection.dart';
import 'package:climbing_app/widgets/climbingStylesSection.dart';
import 'package:climbing_app/widgets/gradesSection.dart';
import 'package:climbing_app/widgets/attemptsSection.dart';

import 'package:climbing_app/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:climbing_app/pages/database.dart';
import 'package:climbing_app/models/lists_model.dart';

class logClimbsPage extends StatefulWidget {
  List<ClimbPreviewItem>? climbPreview;
  String? selectedLocation;
  String? selectedDate;
  String? selectedStyle;
  double? selectedBoulderingGrade;
  double? selectedRopesGrade;
  String? selectedAttempts;

  logClimbsPage(
      {this.climbPreview,
      this.selectedLocation,
      this.selectedDate,
      this.selectedStyle = 'Bouldering',
      this.selectedBoulderingGrade = 0,
      this.selectedRopesGrade = 6,
      this.selectedAttempts = 'Flash'});

  @override
  State<logClimbsPage> createState() => _logClimbsPageState();
}

class _logClimbsPageState extends State<logClimbsPage> {
  late List<ClimbPreviewItem> displayClimbPreview;
  var previewMap = Map();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late DB db;

  Drawer logClimbsDrawer() {
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
  }

  @override
  void initState() {
    super.initState();
    widget.climbPreview = widget.climbPreview ?? [];
    widget.selectedDate =
        widget.selectedDate ?? DateTime.now().toString().split(" ")[0];
    db = DB();

    for (var climb in widget.climbPreview!) {
      if (!previewMap.containsKey(climb)) {
        previewMap[climb] = 1;
      } else {
        previewMap[climb] += 1;
      }
    }
  }

  void updateLocation(text) {
    setState(() {
      if (text == null) {
        widget.selectedLocation = null;
      } else {
        widget.selectedLocation = text;
      }
    });
  }

  void updateDate(text) {
    setState(() {
      widget.selectedDate = text;
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

  void updateAttempts(text) {
    setState(() {
      widget.selectedAttempts = text;
    });
  }

  void postSession(context) async {
    if (!locationOptions.contains(widget.selectedLocation)) {
      locationOptions.add(widget.selectedLocation!);
    }
    List<ClimbItem> postedClimbs = widget.climbPreview!.map((climb) {
      return ClimbItem.fromPreview(
          climb, widget.selectedLocation!, widget.selectedDate!);
    }).toList();
    await db.insertClimbs(postedClimbs);
    Navigator.pushNamed(context, '/listClimbsPage');
  }

  void saveSession() async {
    SessionItem sessionItem = SessionItem(
        location: widget.selectedLocation!, date: widget.selectedDate!);
    await db.insertSession(sessionItem);
    int sessionID = await db.getLastSessionID();
    await db.insertPreview(sessionID, widget.climbPreview!);
  }

  void addClimbstoPreview() {
    double grade = widget.selectedStyle != 'Bouldering'
        ? widget.selectedRopesGrade!
        : widget.selectedBoulderingGrade!;

    setState(() {
      widget.climbPreview!.add(ClimbPreviewItem(
          style: widget.selectedStyle!,
          grade: grade,
          attempts: widget.selectedAttempts!));

      if (!previewMap.containsKey(widget.climbPreview!.lastOrNull)) {
        previewMap[widget.climbPreview!.lastOrNull] = 1;
      } else {
        previewMap[widget.climbPreview!.lastOrNull] += 1;
      }
    });
  }

  Future<bool?> showSaveDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(2),
            title: Text('Save session for later?'),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: <Widget>[
              Row(children: [
                TextButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                      backgroundColor: MaterialStateProperty.all(Colors.blue)),
                  onPressed: () {
                    saveSession();
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 5),
                SizedBox(
                    //width: 90,
                    child: OutlinedButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 212, 212, 212)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          side: MaterialStateProperty.all(BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 210, 210, 210))),
                        ),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Text(
                          'Discard',
                          style: TextStyle(color: Colors.black),
                        ))),
                SizedBox(
                  width: 10,
                ),
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
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ])
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: logClimbsDrawer(),
        appBar: appBar(_scaffoldKey),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(
              height: 5,
            ),
            locationSection(
              selectedLocation: widget.selectedLocation,
              onLocationChanged: updateLocation,
            ),
            dateSection(
              selectedDate: widget.selectedDate,
              onDateChanged: updateDate,
            ),
            SizedBox(
              height: 10,
            ),
            climbingStylesSection(
              selectedStyle: widget.selectedStyle!,
              onStyleChanged: updateStyle,
            ),
            gradesSection(
                selectedStyle: widget.selectedStyle!,
                selectedRopesGrade: widget.selectedRopesGrade!,
                selectedBoulderingGrade: widget.selectedBoulderingGrade!,
                onGradeChanged: updateGrade),
            SizedBox(height: 10),
            attemptsSection(
              selectedAttempts: widget.selectedAttempts,
              onAttemptsChanged: updateAttempts,
            ),
            addClimbsButton(
              completed: widget.selectedLocation != null,
              onAddClimbsToPreview: addClimbstoPreview,
            ),
            //Text(uniqueClimbs.toString()),
            SizedBox(height: 10),
            climbPreviewSection(
              previewMap: previewMap,
              climbPreview: widget.climbPreview ?? [],
              onPostSessionPressed: postSession,
            ),
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

class climbPreviewSection extends StatefulWidget {
  final List<ClimbPreviewItem> climbPreview;
  final previewMap;
  final void Function(BuildContext) onPostSessionPressed;
  climbPreviewSection(
      {required this.climbPreview,
      required this.previewMap,
      required this.onPostSessionPressed});

  @override
  State<climbPreviewSection> createState() => _climbPreviewState();
}

class _climbPreviewState extends State<climbPreviewSection> {
  SizedBox postSessionButton(context) {
    return SizedBox(
        height: 40,
        child: TextButton(
            onPressed: widget.climbPreview.isEmpty
                ? null
                : () => widget.onPostSessionPressed(context),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
              backgroundColor: widget.climbPreview.isNotEmpty
                  ? MaterialStateProperty.all(Colors.blue)
                  : MaterialStateProperty.all(Colors.grey),
            ),
            child: Text(
              'Post Session',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            )));
  }

  void removeClimb(index) {
    setState(() {
      widget.climbPreview.removeAt(index);
      selectedPreview = null;
      final climbElement = widget.previewMap.keys.elementAt(index);
      widget.previewMap.remove(climbElement);
    });
  }

  int? selectedPreview = null;

  SizedBox removeClimbButton(index) {
    return SizedBox(
        height: 40,
        child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
              backgroundColor: selectedPreview != null
                  ? MaterialStateProperty.all(Colors.red)
                  : MaterialStateProperty.all(Colors.grey),
            ),
            onPressed:
                selectedPreview != null ? () => removeClimb(index) : null,
            child: Icon(
              CupertinoIcons.trash,
              size: 20,
              color: Colors.white,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 70,
          width: double.infinity,
          color: widget.climbPreview.isEmpty
              ? Colors.white
              : Color.fromARGB(26, 150, 150, 150),
          child: ListView.separated(
              shrinkWrap: true,
              itemCount: widget.previewMap.length,
              scrollDirection: Axis.horizontal,
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              separatorBuilder: (context, index) => SizedBox(
                    width: 5,
                  ),
              itemBuilder: (context, index) {
                final climbElement = widget.previewMap.keys.elementAt(index);
                final count = widget.previewMap[climbElement];
                return Stack(children: [
                  Container(
                      height: 50,
                      width: 50,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            if (selectedPreview == index) {
                              selectedPreview = null;
                            } else {
                              selectedPreview = index;
                            }
                          });
                        },
                        style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                Colors.white.withOpacity(0.1)),
                            backgroundColor: MaterialStateProperty.all(
                              climbElement.style != 'Bouldering'
                                  ? (selectedPreview == index
                                      ? utils.setRopesColor(climbElement.grade)
                                      : Colors.grey)
                                  : (selectedPreview == index
                                      ? utils.setBoulderingColor(
                                          climbElement.grade)
                                      : Colors.grey),
                            ),
                            shape: MaterialStateProperty.all(CircleBorder())),
                        child: Align(
                          child: AutoSizeText(
                            minFontSize: 10,
                            maxLines: 1,
                            climbElement.style != 'Bouldering'
                                ? utils.setRopesGradeText(climbElement.grade)
                                : 'V' + (climbElement.grade).toStringAsFixed(0),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )),
                  Align(
                    widthFactor: 1.2,
                    heightFactor: 2.8,
                    alignment: Alignment(0, 1),
                    child: climbElement.attempts == 'Flash'
                        ? Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                color: Color(0xffF7F8F8).withOpacity(0.8),
                                borderRadius: BorderRadius.circular(15)),
                            child: Icon(
                              CupertinoIcons.bolt_fill,
                              color: Colors.amber,
                              size: 18,
                            ))
                        : Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                color: Color(0xffF7F8F8).withOpacity(0.8),
                                borderRadius: BorderRadius.circular(15)),
                            child: Icon(
                              CupertinoIcons.circle_fill,
                              color: Colors.red,
                              size: 15,
                            )),
                  ),
                  count > 1
                      ? Align(
                          widthFactor: 2.8,
                          heightFactor: 2.8,
                          alignment: Alignment(1, 1),
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(15)),
                            child: Text(
                              textAlign: TextAlign.center,
                              count.toString(),
                              style: TextStyle(
                                  color: Color(0xffF7F8F8),
                                  fontWeight: FontWeight.w700),
                            ),
                          ))
                      : SizedBox(),
                ]);
              }),
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 60, child: removeClimbButton(selectedPreview)),
            SizedBox(
              width: 25,
            ),
            postSessionButton(context),
          ],
        ),
      ],
    );
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
