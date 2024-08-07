import 'package:auto_size_text/auto_size_text.dart';
import "package:flutter/material.dart";
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:climbing_app/widgets/navDrawer.dart';
import 'package:climbing_app/pages/database.dart';

import 'package:climbing_app/widgets/myDropDown.dart';
//import 'package:sqflite/sqflite.dart';
import 'package:flutter/cupertino.dart';

import 'package:climbing_app/utils.dart' as utils;
import 'package:intl/intl.dart';

import 'package:climbing_app/models/lists_model.dart';

class listClimbsPage extends StatefulWidget {
  listClimbsPage({super.key});

  @override
  State<listClimbsPage> createState() => _listClimbsPageState();
}

class _listClimbsPageState extends State<listClimbsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<ClimbItem> climbs = [];
  late DB db;

  @override
  void initState() {
    super.initState();
    db = DB();
    getData();
    filtList = getList(filterType);
  }

  void getData() async {
    climbs = await db.getData();
    setState(() {});
  }

  void delete(index) async {
    db.delete(climbs[index].id!);
    setState(() {
      climbs.removeAt(index);
    });
  }

  List<String> getList(string) {
    switch (string) {
      case 'Style':
        return styleList;
      case 'Grade':
        return gradeList;
      case 'Attempts':
        return attemptsList;
      default:
        return [];
    }
  }

  void changeFilterType(string) {
    setState(() {
      filtList = getList(string);
      selectedFilter = null;
      filterType = string;
      changeSortType(sortBy);
    });
  }

  void changeSortType(string) async {
    if (selectedFilter == null) {
      climbs = await db.sortBy(string.toLowerCase());
    }

    setState(() {
      sortBy = string;
      if (selectedFilter != null) {
        filterSort();
      }
    });
  }

  void filterSort() async {
    climbs = await db.filterSort(
        filterType.toLowerCase(),
        filtList[selectedFilter!],
        sortBy.toLowerCase(),
        filterType != 'Grade' ? null : selectedFilter! > 10);
    setState(() {});
  }

  String filterType = 'Style';
  late List<String> filtList;
  String sortBy = 'Date';
  int? selectedFilter;
  final DateFormat outputFormat = DateFormat('MMMM d, yyyy');
  int? selectedClimb;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: NavDrawer(),
        appBar: appBar(_scaffoldKey),
        floatingActionButton: FloatingActionButton(
          onPressed: selectedClimb != null
              ? () => (setState(() {
                    delete(selectedClimb);
                    selectedClimb = null;
                  }))
              : null,
          backgroundColor: selectedClimb != null ? Colors.red : Colors.grey,
          child: Icon(
            CupertinoIcons.trash,
            size: 20,
            color: Colors.white,
          ),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            height: 5,
          ),
          filterSortBar(context),
          Expanded(child: climbsList())
        ]));
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
        'Your Climbs',
        style: TextStyle(
            color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.blue,
      elevation: 0.0,
      centerTitle: true,
    );
  }

  Column filterSortBar(context) {
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              SizedBox(width: 10),
              Icon(
                CupertinoIcons.arrow_up_arrow_down,
                color: Colors.black,
                size: 22,
              ),
              SizedBox(width: 8),
              Text('Sort by ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
              myDropDown(
                list: sortByList,
                onDropDownChanged: changeSortType,
                initial: sortBy,
                hint: '',
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Icon(
                    CupertinoIcons.line_horizontal_3_decrease,
                    color: Colors.black,
                    size: 25,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Filter by ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  myDropDown(
                    list: filterList,
                    onDropDownChanged: changeFilterType,
                    initial: filterType,
                    hint: '',
                  ),
                  SizedBox(
                    width: 5,
                  )
                ],
              ),
            ),
          ],
        ),
        Container(
          height: 55,
          color: Color.fromARGB(255, 236, 236, 236),
          width: double.infinity,
          child: ListView.separated(
              shrinkWrap: true,
              itemCount: filtList.length,
              scrollDirection: Axis.horizontal,
              padding:
                  EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
              itemBuilder: ((context, index) {
                if (index == 10) {
                  return Row(
                    children: [
                      SizedBox(width: 5),
                      Container(
                        height: 10,
                        width: 2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.grey),
                      ),
                      SizedBox(
                        width: 5,
                      )
                    ],
                  );
                } else {
                  return SizedBox(
                      height: 1,
                      child: TextButton(
                        style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                Colors.white.withOpacity(0.1)),
                            backgroundColor: selectedFilter == index
                                ? MaterialStateProperty.all(Colors.blue)
                                : MaterialStateProperty.all(Colors.grey)),
                        onPressed: () {
                          setState(() {
                            if (selectedFilter == index) {
                              selectedFilter = null;
                              changeSortType(sortBy);
                            } else {
                              selectedFilter = index;
                              filterSort();
                            }
                          });
                        },
                        child: Text(
                          filterType == 'Grade'
                              ? index > 10
                                  ? utils.setRopesGradeText(
                                      double.parse(filtList[index]))
                                  : 'V' + filtList[index]
                              : filtList[index],
                          style: TextStyle(color: Colors.white),
                        ),
                      ));
                }
              }),
              separatorBuilder: ((context, index) => (SizedBox(
                    width: 5,
                  )))),
        )
      ],
    );
  }

  ListView climbsList() {
    return ListView.separated(
        shrinkWrap: true,
        itemCount: climbs.length,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.only(left: 10, right: 10, top: 5),
        separatorBuilder: (context, index) => Column(
              children: [],
            ),
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                setState(() {
                  if (selectedClimb == index) {
                    selectedClimb = null;
                  } else {
                    selectedClimb = index;
                  }
                });
              },
              child: Card(
                  elevation: 0,
                  margin: EdgeInsets.all(2),
                  color: selectedClimb == index
                      ? Color.fromARGB(255, 235, 235, 235)
                      : Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 5),
                      Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            color: climbs[index].style != 'Bouldering'
                                ? utils.setRopesColor(climbs[index].grade)
                                : utils.setBoulderingColor(climbs[index].grade),
                            shape: BoxShape.circle),
                      ),
                      SizedBox(width: 5),
                      Container(
                          width: 45,
                          child: AutoSizeText(
                            maxLines: 1,
                            climbs[index].style != 'Bouldering'
                                ? utils.setRopesGradeText(climbs[index].grade)
                                : 'V' + climbs[index].grade.toStringAsFixed(0),
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.w900),
                          )),
                      SizedBox(width: 5),
                      Container(
                          width: 70,
                          child: Text(
                            climbs[index].attempts,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          )),
                      SizedBox(width: 5),
                      Container(
                          width: 140,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              AutoSizeText(
                                maxLines: 1,
                                outputFormat
                                    .format(DateTime.parse(climbs[index].date)),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              AutoSizeText(
                                maxLines: 1,
                                minFontSize: 8,
                                overflow: TextOverflow.ellipsis,
                                climbs[index].location,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ))
                    ],
                  )));
        });
  }
}
