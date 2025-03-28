import "package:flutter/material.dart";
import 'package:fl_chart/fl_chart.dart';
import 'package:climbing_app/widgets/myDropDown.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:climbing_app/models/lists_model.dart';
import 'package:climbing_app/utils.dart';

class gradePyramidChart extends StatefulWidget {
  gradePyramidChart({super.key});

  @override
  State<gradePyramidChart> createState() => _gradePyramidChartState();
}

class _gradePyramidChartState extends State<gradePyramidChart> {
  //late DB db;
  String style = 'Bouldering';
  List<double> flashList = [];
  List<double> redpointList = [];
  String location = '';

  @override
  void initState() {
    super.initState();
    //db = DB();
    getBoulderingGradePyramid(style);
  }

  Future<void> getBoulderingGradePyramid(newStyle) async {
    style = newStyle;
    if (style == 'Bouldering') {
      //flashList = await db.getBoulderingFlashGradeCount(setFilter());
      //redpointList = await db.getBoulderingRedpointGradeCount(setFilter());
    } else {
      //flashList = await db.getRopesFlashGradeCount(setFilter());
      //redpointList = await db.getRopesRedpointGradeCount(setFilter());
    }
    setState(() {});
  }

  String setFilter() {
    List<String> conditions = [];
    conditions.add("style = '$style'");
    if (location != '') {
      conditions.add("location = '$location'");
    }
    return " AND " + conditions.join(" AND ");
  }

  void onLocationChanged(string) async {
    location = string;
    await getBoulderingGradePyramid(style);
    //setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return flashList.isNotEmpty && redpointList.isNotEmpty
        ? gradePyramidContainer()
        : SizedBox();
  }

  List<BarChartGroupData> generateBarChartGroupData() {
    return List.generate(flashList.length, (index) {
      return BarChartGroupData(x: index, groupVertically: true, barRods: [
        BarChartRodData(
            width: 20,
            borderRadius: BorderRadius.only(
                topRight: flashList[index] == 0
                    ? Radius.circular(6)
                    : Radius.circular(0),
                topLeft: flashList[index] == 0
                    ? Radius.circular(6)
                    : Radius.circular(0),
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6)),
            fromY: 0,
            toY: redpointList[index],
            color: Colors.blue),
        BarChartRodData(
            width: 20,
            borderRadius: BorderRadius.only(
                bottomRight: redpointList[index] == 0
                    ? Radius.circular(6)
                    : Radius.circular(0),
                bottomLeft: redpointList[index] == 0
                    ? Radius.circular(6)
                    : Radius.circular(0),
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6)),
            fromY: redpointList[index],
            toY: flashList[index] + redpointList[index],
            color: Colors.lightBlueAccent)
      ]);
    });
  }

  Column gradePyramidContainer() {
    return Column(
      children: [
        myDropDown(
          list: typeList,
          onDropDownChanged: getBoulderingGradePyramid,
          initial: 'Bouldering',
          hint: '',
        ),
        myDropDown(
          list: locationOptions,
          onDropDownChanged: onLocationChanged,
          initial: '',
          hint: 'Location',
        ),
        SizedBox(
          height: 78,
        ),
        Container(
            padding: EdgeInsets.all(20),
            height: 458,
            width: 500,
            child: BarChart(BarChartData(
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                  //horizontalInterval: 1
                ),
                titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: true, reservedSize: 30)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                            reservedSize: 40,
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Transform.rotate(
                                  angle: -45,
                                  child: SideTitleWidget(
                                      child: Text(style == 'Bouldering'
                                          ? 'V' + value.toStringAsFixed(0)
                                          : setRopesGradeText(ropesGradeList[
                                              value.toInt()])), //TODO
                                      axisSide: meta.axisSide));
                            }))),
                alignment: BarChartAlignment.center,
                groupsSpace: 20,
                barGroups: generateBarChartGroupData(),
                barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                        tooltipRoundedRadius: 10,
                        fitInsideVertically: true,
                        direction: TooltipDirection.top,
                        getTooltipColor: (group) {
                          return Color.fromARGB(255, 160, 160, 160);
                        },
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(rod.toY.toStringAsFixed(0),
                              TextStyle(color: Colors.white));
                        })))))
      ],
    );
  }
}
