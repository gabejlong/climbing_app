import "package:flutter/material.dart";
import 'package:climbing_app/charts/bestClimbsChart.dart';
import 'package:climbing_app/charts/gradePyramidChart.dart';
import 'package:climbing_app/models/lists_model.dart';
import 'package:climbing_app/utils.dart';
import "package:climbing_app/widgets/navDrawer.dart";
import 'package:climbing_app/pages/newSessionPage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:climbing_app/widgets/myDropDown.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:climbing_app/charts/countClimbsChart.dart';
import 'package:climbing_app/models/allModels.dart';

class statsPage extends StatefulWidget {
  statsPage({super.key});

  @override
  State<statsPage> createState() => _statsPageState();
}

class _statsPageState extends State<statsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<SessionPreviewItem> sessionList = [];
  List<ClimbPreviewItem> climbPreviewList = [];
  int activeIndex = 0;

//  late DB db;
  late List<Widget> graphs = [];
  final DateFormat outputFormat = DateFormat('MMMM d, yyyy');

  @override
  void initState() {
    super.initState();
    //   db = DB();
    //   getSessionList();
    getGraph();
  }

  Future<void> getGraph() async {
    graphs = await [
      gradePyramidChart(),
      countClimbsChart(output: "COUNT"),
      countClimbsChart(output: "MAX"),
      countClimbsChart(output: "AVG")
    ];
  }

/*  void getSessionList() async {
    sessionList = await db.getSessionList();
    setState(() {});
  }

  void getClimbPreview(int sessionId) async {
    climbPreviewList = await db.getClimbPreview(sessionId);
    setState(() {});
  }

  void deletePreview(int sessionId) async {
    db.deletePreview(sessionId);
  }

  void deleteSession(int sessionId) async {
    db.deleteSession(sessionId);
  }*/

  Column sessionListSection() {
    return Column(
      children: [
        Text(
          'Your in-progress sessions',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        Container(
          height: 85,
          width: 500,
          child: Align(
            child: ListView.separated(
                shrinkWrap: true,
                itemCount: sessionList.length,
                scrollDirection: Axis.horizontal,
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                itemBuilder: ((context, index) {
                  return TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      foregroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 212, 212, 212)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                    ),
                    onPressed: () async {
                      /*getClimbPreview(sessionList[index].sessionId!);
                      deletePreview(sessionList[index].sessionId!);
                      deleteSession(sessionList[index].sessionId!);*/
                      await Future.delayed(const Duration(milliseconds: 100));
                      /*if (climbPreviewList.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => newSessionPage(
                              climbPreview: climbPreviewList,
                              selectedLocation: sessionList[index].location,
                              selectedDate: sessionList[index].date,
                            ),
                          ),
                        );
                      }*/
                    },
                    child: Column(children: [
                      Text(
                        outputFormat
                            .format(DateTime.parse(sessionList[index].date)),
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      /*Text(
                        sessionList[index].location,
                        style: TextStyle(color: Colors.white),
                      )*/
                    ]),
                  );
                }),
                separatorBuilder: ((context, index) => (SizedBox(
                      width: 20,
                    )))),
          ),
        ),
      ],
    );
  }

  void delay() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Widget build(BuildContext context) {
    delay();
    return Scaffold(
        bottomNavigationBar: NavBottomBar(),
        key: _scaffoldKey,
        // drawer: NavDrawer(),
        body: Container(
            padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Text(
                    'Your Stats',
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
                  )
                ],
              ),
              SingleChildScrollView(
                  child: Column(children: [
                sessionList.isNotEmpty ? sessionListSection() : SizedBox(),
                Column(children: [
                  graphs.isNotEmpty
                      ? CarouselSlider.builder(
                          itemCount: graphs.length,
                          options: CarouselOptions(
                              onPageChanged: (index, reason) =>
                                  setState(() => activeIndex = index),
                              viewportFraction: 1,
                              //enlargeCenterPage: true,
                              pageSnapping: true,
                              height: 632),
                          itemBuilder: (context, index, realIndex) {
                            return graphs[index];
                          },
                        )
                      : SizedBox(),
                  graphs.isNotEmpty ? buildIndicator() : SizedBox(),
                  SizedBox(
                    height: 10,
                  )
                ])
              ]))
            ])));
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
      effect: JumpingDotEffect(
          dotWidth: 10, dotHeight: 10, activeDotColor: Colors.blue),
      activeIndex: activeIndex,
      count: graphs.length);
}
