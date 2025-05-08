import 'package:auto_size_text/auto_size_text.dart';
import 'package:climbing_app/pages/newSessionPage.dart';
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

import 'package:climbing_app/database/firebaseFunctions.dart';
import 'package:intl/intl.dart';

class sessionViewPage extends StatefulWidget {
  String sessionID;
  String uID;
  sessionViewPage({required this.uID, required this.sessionID});

  @override
  State<sessionViewPage> createState() => _sessionViewPageState();
}

class _sessionViewPageState extends State<sessionViewPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late SessionItem session;
  late List<ClimbPreviewItem> climbs;

  @override
  Widget build(BuildContext context) {
    print(widget.sessionID + " HIHIHIHI");
    return Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: NavBottomBar(),
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: FutureBuilder(
            future: getSession(widget.uID, widget.sessionID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 70),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                          strokeWidth: 3,
                        ),
                      ),
                    ));
              }
              if (snapshot.hasError) {
                return Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                        padding: EdgeInsets.only(top: 80),
                        child: Text(
                          "Error loading your session",
                          style: TextStyle(color: Colors.red),
                        )));
              }
              session = snapshot.data!;
              climbs = session.climbs;
              return Container(
                  padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'View Session',
                              style: TextStyle(
                                  fontSize: 27, fontWeight: FontWeight.w600),
                            ),
                            Spacer(),
                            TextButton.icon(
                              label: Text(
                                'Edit',
                                style: TextStyle(
                                    color: Color(0xff007BDD),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => newSessionPage(
                                        sessionID: widget.sessionID),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        ListTile(
                          leading: Icon(CupertinoIcons.location_solid),
                          title: Text(
                            session.location,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        ListTile(
                          leading: Icon(CupertinoIcons.calendar),
                          title: Text(
                            DateFormat('MMMM d, y')
                                .format(DateTime.parse(session.date)),
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        session.friends == null || session.friends!.isEmpty
                            ? SizedBox()
                            : ListTile(
                                leading: Icon(CupertinoIcons.person),
                                title: Text(
                                  session.friends.toString(),
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                        ListTile(
                          leading: Icon(CupertinoIcons.tags),
                          title: Text(
                            session.climbs.length.toString() + " climbs",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        session.notes == null
                            ? SizedBox()
                            : Text(
                                session.notes!,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                        Text(
                          'Climbs',
                          style: TextStyle(
                              fontSize: 27, fontWeight: FontWeight.w600),
                        ),
                        climbsList(),
                      ]));
            }));
  }

  Expanded climbsList() {
    return Expanded(
        child: ListView.separated(
            shrinkWrap: true,
            itemCount: climbs.length,
            scrollDirection: Axis.vertical,
            separatorBuilder: (context, index) => Divider(
                  height: 30,
                  color: const Color.fromARGB(255, 200, 200, 200),
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
                            color: climbs[index].isBoulder
                                ? utils.setBoulderingColor(climbs[index].grade)
                                : utils.setRopesColor(climbs[index].grade)),
                        shape: BoxShape.circle),
                    child: Container(
                      height: 50,
                      width: 50,
                      child: Align(
                        child: AutoSizeText(
                          minFontSize: 10,
                          maxLines: 1,
                          //overflow: TextOverflow.ellipsis,
                          climbs[index].isBoulder
                              ? 'V' + climbs[index].grade.toStringAsFixed(0)
                              : utils.setRopesGradeText(climbs[index].grade),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                      width: 180,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          climbs[index].name != null
                              ? AutoSizeText(
                                  maxLines: 1,
                                  minFontSize: 8,
                                  overflow: TextOverflow.ellipsis,
                                  climbs[index].name!,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                )
                              : SizedBox(),
                          AutoSizeText(
                            maxLines: 1,
                            climbs[index].attempts + ' •',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                        ],
                      )),
                ],
              );
            }));
  }
}
