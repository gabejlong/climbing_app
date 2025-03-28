import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:climbing_app/models/classModels.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:climbing_app/firebaseFunctions.dart';

import 'package:d_chart/d_chart.dart';

class listClimbsPage extends StatefulWidget {
  listClimbsPage({super.key});

  @override
  State<listClimbsPage> createState() => _listClimbsPageState();
}

String userID = 'long.climber';

class _listClimbsPageState extends State<listClimbsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSort = true;
  late Future<List<ClimbReadItem>> gettingClimbs;
  List<ClimbReadItem> climbs = [];

  List<SessionReadItem> sessions = [];
  List<List<NumericData>> piesList = [];

  late Filters climbFilters;
  late Filters sessionFilters;

  RangeValues activeGradeFilter = const RangeValues(0, 17);
  int totalCount = 0;
  @override
  void initState() {
    climbFilters = Filters(
      lowGrade: activeGradeFilter.start,
      highGrade: activeGradeFilter.end,
    );
    super.initState();
    // db = DB();
    getData();
  }

  void getData() async {
    totalCount = await getAllClimbsCount(userID);
  }

  List<List<NumericData>> setSessionSlices() {
    for (var session in sessions) // loop through sessions
    {
      List<NumericData> pies = [];
      for (int i = 0; i < session.grades.length; i++) // loop through climbs
      {
        Color color = session.grades[i] >= 0
            ? utils.setBoulderingColor(session.grades[i])
            : utils.setRopesColor(session.grades[i] * -1);
        pies.add(NumericData(
            domain: i, color: color, measure: 1 / session.grades.length));
      }
      piesList.add(pies);
    }
    return piesList;
  }

  String filterType = 'Style';
  late List<String> filtList;
  String sortBy = 'Date';
  int? selectedFilter;
  final DateFormat outputFormat = DateFormat('MMMM d, yyyy');
  int? selectedClimb;
  final PanelController panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            bottomNavigationBar: NavBottomBar(),
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            body: SlidingUpPanel(
                controller: panelController,
                snapPoint: isSort ? null : 0.5,
                maxHeight: isSort ? 300 : 600,
                minHeight: 0,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                backdropEnabled: true,
                panel: isSort ? sortPanel() : filterPanel(),
                body: Center(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(20, 30, 20, 50),
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
                                          Tab(
                                              height: 30,
                                              child: Text('Sessions')),
                                          Tab(
                                              height: 30,
                                              child: Text('Climbs')),
                                          Tab(
                                              height: 30,
                                              child: Text('In Progress'))
                                        ]),
                                  )),
                              filterSortBar(context),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    FutureBuilder(
                                        // TODO add case for no connection after stops loading cache something?
                                        future: getSessions(userID),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Align(
                                                alignment: Alignment.topCenter,
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 20),
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
                                                    padding: EdgeInsets.only(
                                                        top: 20),
                                                    child: Text(
                                                      "No sessions match the filters",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    )));
                                          }
                                          sessions = snapshot.data!;
                                          piesList = setSessionSlices();

                                          return sessionsList();
                                        }),
                                    FutureBuilder(
                                        future:
                                            getAllClimbs(userID, climbFilters),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Align(
                                                alignment: Alignment.topCenter,
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 20),
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
                                          if (snapshot.hasError) {
                                            return Align(
                                                alignment: Alignment.topCenter,
                                                child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 20),
                                                    child: Text(
                                                      "Error loading climbs",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    )));
                                          }
                                          if (snapshot.data!.isEmpty) {
                                            return Align(
                                                alignment: Alignment.topCenter,
                                                child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 20),
                                                    child: Text(
                                                      "No climbs match the filters",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    )));
                                          }
                                          climbs = snapshot.data!;
                                          return climbsList();
                                        }),
                                    Center(
                                      child: Text("Content for Tab 3"),
                                    ),
                                  ],
                                ),
                              ),
                            ]))))));
  }

  Column filterSortBar(context) {
    List<String> filtersDisplay = climbFilters.toList();
    return Column(children: [
      Row(
        children: [
          TextButton.icon(
            label: Text(
              'Filters',
              style: TextStyle(
                  color: Color(0xff007BDD),
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              setState(() {
                isSort = false;
                panelController.animatePanelToPosition(0.5);
              });
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
              setState(() {
                isSort = true;
                panelController.open();
              });
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
            onPressed: () {
              setState(() {
                // set all filters to null
              });
            },
          ),
        ],
      ),
      Row(
        children: [
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
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
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
        ],
      ),
      SizedBox(height: 10),
      Divider(
        height: 10,
        thickness: 1,
        color: Colors.grey,
      ),
      Align(
          alignment: Alignment.topLeft,
          child: Text(
            textAlign: TextAlign.left,
            climbFilters.selectedSort +
                " • Showing " +
                climbs.length.toString() +
                " of " +
                totalCount.toString(),
            style: TextStyle(color: Colors.grey),
          ))
    ]);
  }

  Container filterPanel() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Container(
            width: 35,
            height: 5,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(10)),
          )),
          SizedBox(height: 10),
          Text(
            'Filters',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
          ),
          Text(
            'Type',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          MultiSelect(
              selected: climbFilters.selectedTypeFilters,
              items: typeList,
              onItemPressed: (filterSet) => {
                    setState(() {
                      climbFilters.selectedTypeFilters = filterSet;
                    })
                  }),
          SizedBox(height: 20),
          Text('Grade Range: V' +
              activeGradeFilter.start.toStringAsFixed(0) +
              ' to V' +
              activeGradeFilter.end.toStringAsFixed(0)),
          SliderTheme(
              data: SliderThemeData(
                  valueIndicatorColor: Colors.white,
                  // overlayColor: Colors.white,
                  thumbColor: Colors.white,
                  trackHeight: 8,
                  activeTrackColor: Colors.blue,
                  inactiveTrackColor: Color(0xffdddddd),
                  inactiveTickMarkColor: Colors.grey),
              child: RangeSlider(
                max: 17,
                min: 0,
                divisions: 17,
                values: activeGradeFilter,
                onChanged: (values) {
                  setState(() {
                    activeGradeFilter = values;
                    climbFilters.lowGrade = values.start;
                    climbFilters.highGrade = values.end;
                  });
                },
              )),
          SizedBox(height: 20),
          Text(
            'Attempts',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          MultiSelect(
            selected: climbFilters.selectedAttemptsFilters,
            items: attemptsList,
            onItemPressed: (filterSet) {
              climbFilters.selectedAttemptsFilters = filterSet;
            },
          ),
        ],
      ),
    );
  }

  Container sortPanel() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Container(
            width: 35,
            height: 5,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(10)),
          )),
          SizedBox(height: 10),
          Text(
            'Sort',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(sortOptions.length, (index) {
              return Column(children: [
                Row(children: [
                  Container(
                    width: 15,
                    height: 15,
                    child: TextButton(
                      child: Text(''),
                      onPressed: () {
                        setState(() {
                          climbFilters.selectedSort = sortOptions[index];
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            climbFilters.selectedSort == sortOptions[index]
                                ? Colors.black
                                : Color(0xfff0f0f0)),
                        overlayColor: MaterialStateProperty.all(
                            Colors.white.withOpacity(0.1)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    textAlign: TextAlign.left,
                    sortOptions[index],
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  )
                ]),
                SizedBox(
                  height: 15,
                )
              ]);
            }),
          ),
        ],
      ),
    );
  }

  ListView sessionsList() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: sessions.length,
      scrollDirection: Axis.vertical,
      separatorBuilder: (context, index) => Divider(
        thickness: 1,
        color: Colors.grey,
      ),
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.all(0),
                width: 100,
                height: 100,
                child: Stack(children: [
                  DChartPieN(
                    data: piesList[index],
                    configRenderPie: const ConfigRenderPie(arcWidth: 5),
                  ),
                  Center(
                      child: Text(
                    sessions[index].grades.length.toString(),
                    style: TextStyle(fontWeight: FontWeight.w800),
                  )),
                ])),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sessions[index].location,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
                Text(outputFormat.format(DateTime.parse(sessions[index].date)))
              ],
            )
          ],
        );
      },
    );
  }

  ListView climbsList() {
    return ListView.separated(
        shrinkWrap: true,
        itemCount: climbs.length,
        scrollDirection: Axis.vertical,
        separatorBuilder: (context, index) => Divider(
              height: 5,
              color: Colors.grey,
            ),
        itemBuilder: (context, index) {
          return Row(
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
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
                      AutoSizeText(
                        maxLines: 1,
                        outputFormat.format(DateTime.parse(climbs[index].date)),
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey),
                      ),
                    ],
                  )),
              SizedBox(width: 5),
              Expanded(
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Container(
                    width: 80,
                    child: Text(
                      climbs[index].attempts,
                      textAlign: TextAlign.end,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    )),
                SizedBox(width: 5),
              ]))
            ],
          );
        });
  }
}
