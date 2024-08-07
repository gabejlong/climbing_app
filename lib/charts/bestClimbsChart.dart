import "package:flutter/material.dart";
import 'package:fl_chart/fl_chart.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:climbing_app/widgets/myDropDown.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:climbing_app/pages/database.dart';
import 'package:climbing_app/models/lists_model.dart';
import 'package:climbing_app/utils.dart';

class bestClimbsChart extends StatefulWidget {
  bestClimbsChart({super.key});

  @override
  State<bestClimbsChart> createState() => _bestClimbsChartState();
}

class _bestClimbsChartState extends State<bestClimbsChart> {
  List<int> best = [];
  late DB db;
  String style = 'Bouldering';

  @override
  void initState() {
    super.initState();
    db = DB();
    getBest();
  }

  Future<void> getBest() async {
    //best = await db.getBest(style);
    setState(() {});
  }

  void onStyleChanged(string) async {
    style = string;
    await getBest();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return best.isNotEmpty ? bestClimbContainer() : SizedBox();
  }

  Column bestClimbContainer() {
    return Column(
      children: [
        myDropDown(
          list: styleList,
          onDropDownChanged: onStyleChanged,
          initial: 'Bouldering',
          hint: '',
        ),
        Container(
          padding: EdgeInsets.all(30),
          height: 500,
          width: 500,
          child: LineChart(LineChartData(
              borderData: FlBorderData(show: false),
              gridData: FlGridData(drawVerticalLine: false),
              //minY: MaxChartStyle == 'Bouldering' ? 0 : 6,
              lineTouchData: LineTouchData(
                  touchSpotThreshold: 15,
                  /*getTouchLineEnd: (LineChartBarData barData, int spotIndex) {
                    return 0;
                  },*/
                  touchTooltipData: LineTouchTooltipData(
                      tooltipRoundedRadius: 10,
                      fitInsideVertically: true,
                      getTooltipColor: (group) {
                        return Color.fromARGB(255, 160, 160, 160);
                      },
                      getTooltipItems: (List<LineBarSpot> spots) {
                        return spots.map((spot) {
                          return LineTooltipItem(
                              style == 'Bouldering'
                                  ? spot.y == 0
                                      ? '0'
                                      : 'V' + spot.y.toStringAsFixed(0)
                                  : spot.y == 0
                                      ? '0'
                                      : setRopesGradeText(spot.y),
                              TextStyle(color: Colors.white));
                        }).toList();
                      })),
              titlesData: FlTitlesData(
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                          getTitlesWidget: (value, meta) {
                            return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Container(
                                    width: 30,
                                    height: 22,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color: value == 12
                                            ? Colors.blue
                                            : Colors.white),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      DateFormat('MMM').format(DateTime(
                                          2024,
                                          (DateTime.now().month + value.toInt())
                                              .remainder(12))),
                                      style: TextStyle(
                                          color: value == 12
                                              ? Colors.white
                                              : Colors.black),
                                    )));
                          },
                          showTitles: true,
                          interval: 1,
                          reservedSize: 40)),
                  leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                          interval: 1,
                          reservedSize: 35,
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return SideTitleWidget(
                                child: Text(style == 'Bouldering'
                                    ? 'V' + value.toStringAsFixed(0)
                                    : value == 0
                                        ? '5'
                                        : setRopesGradeText(value)),
                                axisSide: meta.axisSide);
                          }))),
              lineBarsData: [
                LineChartBarData(
                    color: Colors.blue,
                    spots: List.generate(best.length, (index) {
                      return FlSpot(
                          index.toDouble() + 1, best[index].toDouble());
                    }))
              ])),
        )
      ],
    );
  }
}
