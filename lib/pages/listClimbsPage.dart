import 'package:auto_size_text/auto_size_text.dart';
import 'package:climbing_app/pages/filterPanel.dart';
import 'package:climbing_app/pages/newSessionPage.dart';
import 'package:climbing_app/pages/sessionViewPage.dart';
import 'package:climbing_app/pages/sortPanel.dart';
import "package:flutter/material.dart";
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:climbing_app/widgets/allWidgets.dart';

import 'package:climbing_app/widgets/myDropDown.dart';
import 'package:flutter/cupertino.dart';

import 'package:climbing_app/utils.dart' as utils;
import 'package:intl/intl.dart';

import 'package:climbing_app/models/lists_model.dart';
import 'package:climbing_app/models/allModels.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:climbing_app/database/firebaseFunctions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:climbing_app/models/filtersModels.dart';

import 'package:d_chart/d_chart.dart';

class listClimbsPage extends StatefulWidget {
  listClimbsPage({super.key});

  @override
  State<listClimbsPage> createState() => _listClimbsPageState();
}

class _listClimbsPageState extends State<listClimbsPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSort = true;
  late Future<List<ClimbReadItem>> gettingClimbs;
  List<ClimbReadItem> climbs = [];

  List<SessionReadItem> savedSessions = [];
  List<List<NumericData>> savedPiesList = [];
  List<SessionReadItem> inProgressSessions = [];
  List<List<NumericData>> inProgressPiesList = [];

  late ClimbFilters climbFilters;
  late SessionFilters sessionFilters;

  RangeValues activeGradeFilter = const RangeValues(0, 17);
  int totalCount = 0;
  late TabController tabController;
  ValueNotifier<int> tabIndexNotifier = ValueNotifier<int>(0);
  late String? uID;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    climbFilters = ClimbFilters();
    sessionFilters = SessionFilters();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      /*setState(() {
        tabIndexNotifier.value = tabController.index;
      });*/
    });
    if (FirebaseAuth.instance.currentUser != null) {
      uID = FirebaseAuth.instance.currentUser?.uid;
    }
    getData();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void getData() async {
    loadSessions();
    loadClimbs();
    //loadInProgress();

    totalCount = await getAllClimbsCount(uID!);
  }

  void loadSessions() async {
    isLoading = true;
    savedSessions = await getSessions(uID!, false);
    savedPiesList = setSessionSlices(savedSessions, savedPiesList);
    setState(() {
      isLoading = false;
    });
  }

  void loadClimbs() async {
    isLoading = true;
    climbs = await getAllClimbs(uID!, climbFilters);
    setState(() {
      isLoading = false;
    });
  }

  List<List<NumericData>> setSessionSlices(
      List<SessionReadItem> sessions, List<List<NumericData>> piesList) {
    for (var session in sessions) // loop through sessions
    {
      List<NumericData> pies = [];
      for (int i = 0; i < session.grades.length; i++) // loop through climbs
      {
        Color color = session.grades[i] >= 0
            ? utils.setBoulderingColor(session.grades[i])
            : utils.setRopesColor(session.grades[i] * -1);
        pies.add(NumericData(domain: i, measure: 1 / session.grades.length));
      }
      piesList.add(pies);
    }
    return piesList;
  }

  String filterType = 'Style';
  late List<String> filtList;
  String sortBy = 'Date';
  int? selectedFilter;
  final DateFormat outputFormat = DateFormat('MMM d');
  int? selectedClimb;
  final PanelController panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavBottomBar(),
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: SlidingUpPanel(
            controller: panelController,
            snapPoint: isSort ? null : 0.5,
            maxHeight: isSort ? 300 : 600,
            minHeight: 0,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            backdropEnabled: true,
            panel: isSort
                ? tabIndexNotifier == 1
                    ? SortPanel(
                        selectedSort: climbFilters.selectedSort,
                        isClimb: true,
                        onPanelChanged: (sort) {
                          setState(() {
                            climbFilters.selectedSort = sort;
                          });
                        })
                    : SortPanel(
                        selectedSort: sessionFilters.selectedSort,
                        isClimb: false,
                        onPanelChanged: (sort) {
                          setState(() {
                            sessionFilters.selectedSort = sort;
                          });
                        })
                : tabIndexNotifier == 1
                    ? FilterPanel(
                        filters: climbFilters,
                        onPanelChanged: (changedFilters) {
                          setState(() {
                            climbFilters = changedFilters as ClimbFilters;
                          });
                        })
                    : FilterPanel(
                        filters: sessionFilters,
                        onPanelChanged: (changedFilters) {
                          setState(() {
                            sessionFilters = changedFilters as SessionFilters;
                          });
                        }),
            body: Center(
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 50, 20, 50),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Climbs',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 27, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              height: 62,
                              //width: 200,
                              child: AppBar(
                                bottom: TabBar(
                                    controller: tabController,
                                    isScrollable: true,
                                    labelPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 0),
                                    labelColor: Colors.black,
                                    dividerColor: Colors.grey,
                                    unselectedLabelColor: Colors.grey,
                                    tabAlignment: TabAlignment.start,
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    labelStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                    splashBorderRadius:
                                        BorderRadius.circular(50),
                                    tabs: [
                                      Tab(height: 30, child: Text('Sessions')),
                                      Tab(height: 30, child: Text('Climbs')),
                                      Tab(
                                          height: 30,
                                          child: Text('In Progress'))
                                    ]),
                              )),
                          filterSortButtons(
                            notifier: tabIndexNotifier,
                            onFilterClicked: (isClimb) {
                              //setState(() {
                              setState(() {
                                isSort = false;
                              });
                              panelController.animatePanelToPosition(0.5);
                              //});
                            },
                            onSortClicked: (isClimb) {
                              setState(() {
                                isSort = true;
                                panelController.open();
                              });
                            },
                            onResetClicked: (isClimb) {},
                          ),
                          appliedFiltersBar(),
                          Expanded(
                            child: TabBarView(
                              controller: tabController,
                              children: [
                                FutureBuilder(
                                    // TODO add case for no connection after stops loading cache something?
                                    future: getSessions(uID!, false),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Align(
                                            alignment: Alignment.topCenter,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.blue,
                                                  strokeWidth: 3,
                                                ),
                                              ),
                                            ));
                                      }
                                      if (!snapshot.hasData) {
                                        return Align(
                                            alignment: Alignment.topCenter,
                                            child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 20),
                                                child: Text(
                                                  "No sessions match the filters",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                )));
                                      }
                                      savedSessions = snapshot.data!;
                                      savedPiesList = setSessionSlices(
                                          savedSessions, savedPiesList);

                                      return sessionsList(
                                          savedSessions, savedPiesList);
                                    }),
                                isLoading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                        color: Colors.blue,
                                      ))
                                    : climbsList(),
                                FutureBuilder(
                                    // TODO add case for no connection after stops loading cache something?
                                    future: getSessions(uID!, true),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Align(
                                            alignment: Alignment.topCenter,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.blue,
                                                  strokeWidth: 3,
                                                ),
                                              ),
                                            ));
                                      }
                                      if (!snapshot.hasData) {
                                        return Align(
                                            alignment: Alignment.topCenter,
                                            child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 20),
                                                child: Text(
                                                  "No sessions match the filters",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                )));
                                      }
                                      inProgressSessions = snapshot.data!;
                                      inProgressPiesList = setSessionSlices(
                                          inProgressSessions,
                                          inProgressPiesList);

                                      return sessionsList(inProgressSessions,
                                          inProgressPiesList);
                                    }),
                              ],
                            ),
                          ),
                        ])))));
  }

  Column appliedFiltersBar() {
    List<String> filtersDisplay = climbFilters.toList();
    return Column(children: [
      Wrap(
        spacing: 5,
        runSpacing: 5,
        children: List.generate(
          filtersDisplay.length,
          (index) {
            return Column(
              children: [
                TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      overlayColor: MaterialStateProperty.all(
                          Colors.white.withOpacity(0.1)),
                    ),
                    child: Text(
                      filtersDisplay[index],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ],
            );
          },
        ),
      ),
      SizedBox(height: 10),
      Divider(
        height: 10,
        thickness: 1,
        color: Colors.grey,
      ),
      FutureBuilder(
          future: tabController.index == 1
              ? getAllClimbsCount(uID!)
              : getAllSessionsCount(uID!),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    textAlign: TextAlign.left,
                    (tabController.index == 1
                            ? climbFilters.selectedSort
                            : sessionFilters.selectedSort) +
                        " • Showing " +
                        (tabController.index == 1
                            ? climbs.length.toString()
                            : savedSessions.length
                                .toString()) + // TODO fix to include tab 3
                        " of " +
                        totalCount.toString(),
                    style: TextStyle(color: Colors.grey),
                  ));
            } else {
              return SizedBox();
            }
          }),
      SizedBox(
        height: 10,
      )
    ]);
  }

  ListView sessionsList(
      List<SessionReadItem> sessions, List<List<NumericData>> pies) {
    String? uID = FirebaseAuth.instance.currentUser!.uid;
    return ListView.separated(
      shrinkWrap: true,
      itemCount: sessions.length,
      scrollDirection: Axis.vertical,
      separatorBuilder: (context, index) => Divider(
        thickness: 1,
        color: Colors.grey,
      ),
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () => {
                  if (sessions[index].inProgress)
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => newSessionPage(
                            sessionID: sessions[index].sessionID,
                          ),
                        ),
                      )
                    }
                  else
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => sessionViewPage(
                            uID: uID,
                            sessionID: sessions[index].sessionID!,
                          ),
                        ),
                      )
                    }
                },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                sessionPie(sessions[index], pies[index]),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sessions[index].location,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                    ),
                    Text(DateFormat('MMMM d')
                        .format(DateTime.parse(sessions[index].date)))
                  ],
                ),
                Spacer(),
                // TODO wasteful to check for each element
                sessions[index].inProgress
                    ? IconButton(
                        onPressed: () {
                          deleteSession(uID, sessions[index].sessionID);
                          setState(() {
                            sessions.removeAt(index);
                          });
                        },
                        icon: Icon(
                          CupertinoIcons.trash,
                          color: Colors.red,
                        ))
                    : SizedBox()
              ],
            ));
      },
    );
  }

  ListView climbsList() {
    return ListView.separated(
        shrinkWrap: true,
        itemCount: climbs.length,
        scrollDirection: Axis.vertical,
        separatorBuilder: (context, index) => Divider(
              height: 10,
              color: const Color.fromARGB(255, 200, 200, 200),
            ),
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => sessionViewPage(
                      uID: uID!,
                      sessionID: climbs[index].sessionID,
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 3,
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
                              fontSize: 16, fontWeight: FontWeight.w900),
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
                          AutoSizeText(
                            maxLines: 1,
                            minFontSize: 8,
                            overflow: TextOverflow.ellipsis,
                            climbs[index].location,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          Container(
                              width: 80,
                              child: Text(
                                climbs[index].attempts,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey),
                              )),
                        ],
                      )),
                  SizedBox(width: 5),
                  Expanded(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                        AutoSizeText(
                          maxLines: 1,
                          outputFormat
                              .format(DateTime.parse(climbs[index].date)),
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey),
                        ),
                        SizedBox(width: 5),
                      ]))
                ],
              ));
        });
  }
}

class filterSortButtons extends StatelessWidget {
  final ValueNotifier<int> notifier;
  final Function(bool) onFilterClicked;
  final Function(bool) onSortClicked;
  final Function(bool) onResetClicked;

  filterSortButtons(
      {required this.notifier,
      required this.onFilterClicked,
      required this.onSortClicked,
      required this.onResetClicked});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: notifier,
        builder: (context, tabIndex, child) {
          return Row(
            children: [
              TextButton.icon(
                label: Text(
                  'Filters',
                  style: TextStyle(
                      color: Color(0xff007BDD),
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () => {
                  print(notifier.toString() + " ajsdi"),
                  onFilterClicked(notifier == 1)
                  /*setState(() {
                    isSort = false;
                    panelController.animatePanelToPosition(0.5);
                  });*/
                },
              ),
              TextButton.icon(
                label: Text(
                  'Sort',
                  style: TextStyle(
                      color: Color(0xff007BDD),
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
                icon: Icon(
                  CupertinoIcons.arrow_up_arrow_down,
                  color: Color(0xff007BDD),
                  size: 18,
                ),
                onPressed: () {
                  onSortClicked(notifier == 1);
                  /*setState(() {
                    isSort = true;
                    panelController.open();
                  });*/
                },
              ),
              Spacer(),
              TextButton.icon(
                label: Text(
                  'Reset',
                  style: TextStyle(
                      color: Color(0xff007BDD),
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
                icon: Icon(
                  CupertinoIcons.refresh_thin,
                  color: Color(0xff007BDD),
                  size: 18,
                ),
                onPressed: () {},
              ),
            ],
          );
        });
  }
}

Container sessionPie(SessionReadItem session, List<NumericData> pie) {
  return Container(
      padding: EdgeInsets.all(0),
      width: 85,
      height: 85,
      child: Stack(children: [
        DChartPieN(
          layoutMargin: LayoutMargin(5, 0, 15, 0),
          data: pie,
          configSeriesPie: ConfigSeriesPieN(
              customColor: (group, data, i) {
                return session.grades[i!] >= 0
                    ? utils.setBoulderingColor(session.grades[i])
                    : utils.setRopesColor(session.grades[i] * -1);
              },
              arcWidth: 5),
        ),
        Center(
            child: Text(
          session.grades.length.toString() + '   ', // TODO this is real bad
          style: TextStyle(fontWeight: FontWeight.w800),
        )),
      ]));
}
