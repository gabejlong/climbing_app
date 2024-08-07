import 'package:auto_size_text/auto_size_text.dart';
import "package:flutter/material.dart";
import 'package:fl_chart/fl_chart.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:climbing_app/widgets/myDropDown.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:climbing_app/pages/database.dart';
import 'package:climbing_app/models/lists_model.dart';
import 'package:climbing_app/utils.dart';

class countClimbsChart extends StatefulWidget {
  final String output;
  countClimbsChart({required this.output});

  @override
  State<countClimbsChart> createState() => _countClimbsChartState();
}

class _countClimbsChartState extends State<countClimbsChart> {
  final controller = CarouselController();
  late DB db;
  List<int> count = [];
  List<String> dateRange = [];
  late String currentDate;
  String style = 'Bouldering';
  String timeFilter = 'Year';
  int dateRangeIndex = 0;
  List<String> timeFilterList = <String>['Month', 'Year', 'Lifetime'];
  String location = '';
  String attempts = '';

  @override
  void initState() {
    super.initState();
    db = DB();
    getLists();
  }

  Future<void> getLists() async {
    await getDateRangeList(timeFilter);
    await getCount(timeFilter, DateTime.now().year.toString());
    setState(() {});
  }

  Future<void> getDateRangeList(timeFilterTemp) async {
    dateRange = await db.getDateRangeList(
        timeFilterTemp, setFilterDateRange(timeFilterTemp));
    dateRangeIndex = dateRange.length - 1;
  }

  Future<void> getCount(timeFilterTemp, date) async {
    if (timeFilterTemp == 'Year') {
      count = await db.getMonthlyCountByYear(
          setFilterCount(timeFilterTemp), date, widget.output);
    } else if (timeFilterTemp == 'Lifetime') {
      count = await db.getYearlyCountByLifetime(
          setFilterCount(timeFilterTemp), widget.output);
    } else if (timeFilterTemp == 'Month') {
      count = await db.getDailyCountByMonth(
          setFilterCount(timeFilterTemp), date, widget.output);
    }
  }

  void onStyleChanged(newStyle) async {
    style = newStyle;
    await getDateRangeList(timeFilter);
    await getCount(timeFilter, timeFilter == 'Lifetime' ? '' : dateRange.last);
    if (timeFilter != 'Lifetime' && dateRange.isNotEmpty) {
      controller.jumpToPage(dateRange.length);
    }
    setState(() {});
  }

  void onTimeFilterChanged(timeFilterTemp) async {
    await getDateRangeList(timeFilterTemp);
    await getCount(
        timeFilterTemp, timeFilterTemp == 'Lifetime' ? '' : dateRange.last);

    if (timeFilter != 'Lifetime') {
      controller.jumpToPage(dateRange.length);
    }
    timeFilter = timeFilterTemp;
    setState(() {});
  }

  String setFilterDateRange(timeFilterTemp) {
    List<String> conditions = [];
    conditions.add("style = '$style'");
    if (location != '') {
      conditions.add("location = '$location'");
    }
    if (attempts != '') {
      conditions.add("attempts = '$attempts'");
    }
    if (timeFilterTemp == 'Month' || timeFilterTemp == 'Year') {
      return ' WHERE ' + conditions.join(' AND ');
    }
    return '';
  }

  String setFilterCount(timeFilterTemp) {
    List<String> conditions = [];
    conditions.add("style = '$style'");
    if (location != '') {
      conditions.add("location = '$location'");
    }
    if (attempts != '') {
      conditions.add("attempts = '$attempts'");
    }
    if (timeFilterTemp == 'Lifetime') {
      return ' WHERE ' + conditions.join(' AND ');
    }
    return ' AND ' + conditions.join(' AND ');
  }

  void onLocationChanged(newLocation) async {
    location = newLocation;
    await getDateRangeList(timeFilter);
    await getCount(timeFilter, timeFilter == 'Lifetime' ? '' : dateRange.last);
    if (timeFilter != 'Lifetime' && dateRange.isNotEmpty) {
      print(dateRange.length);
      controller.jumpToPage(dateRange.length);
    }
    setState(() {});
  }

  void onAttemptsChanged(newAttempts) async {
    attempts = newAttempts;
    await getDateRangeList(timeFilter);
    await getCount(timeFilter, timeFilter == 'Lifetime' ? '' : dateRange.last);
    if (timeFilter != 'Lifetime' && dateRange.isNotEmpty) {
      print(dateRange.length);
      controller.jumpToPage(dateRange.length);
    }
    setState(() {});
  }

  void next(index) async {
    await getCount(timeFilter, dateRange[index]);
    setState(() {
      controller.nextPage();
    });
  }

  void previous(index) async {
    await getCount(timeFilter, dateRange[index]);
    setState(() {
      controller.previousPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return count.isNotEmpty ? CountLineChartContainer() : SizedBox();
  }

  Stack timeLineCarousel() {
    return Stack(
      children: [
        CarouselSlider.builder(
            carouselController: controller,
            itemCount: dateRange.length,
            options: CarouselOptions(
                enableInfiniteScroll: false,
                initialPage: dateRange.length,
                onPageChanged: (index, reason) => setState(() {
                      dateRangeIndex = index;
                    }),
                viewportFraction: 1,
                pageSnapping: true,
                height: 25),
            itemBuilder: (context, index, realIndex) {
              return Text(
                dateRange[0] == 'null'
                    ? 'There is no available data'
                    : timeFilter == 'Month'
                        ? DateFormat('MMMM yyyy')
                            .format(DateTime.parse(dateRange[index]))
                        : DateFormat('yyyy')
                            .format(DateTime(int.parse(dateRange[index]))),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              );
            }),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            dateRangeIndex != 0 && dateRange[0] != 'null'
                ? IconButton(
                    onPressed: () {
                      previous(dateRangeIndex - 1);
                    },
                    icon: Icon(
                      CupertinoIcons.chevron_left,
                      weight: 20,
                      color: Colors.black,
                      size: 20,
                    ))
                : SizedBox(
                    width: 40,
                  ),
            SizedBox(
              width: 140,
            ),
            dateRangeIndex != dateRange.length - 1 && dateRange[0] != 'null'
                ? IconButton(
                    onPressed: () {
                      next(dateRangeIndex + 1);
                    },
                    icon: Icon(
                      CupertinoIcons.chevron_right,
                      weight: 20,
                      color: Colors.black,
                      size: 20,
                    ),
                  )
                : SizedBox(
                    width: 40,
                  )
          ],
        )
      ],
    );
  }

  Column CountLineChartContainer() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          widget.output + ' climbs by ' + timeFilter,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Row(children: [
          myDropDown(
            list: locationOptions,
            onDropDownChanged: onLocationChanged,
            initial: '',
            hint: 'Location',
          ),
        ]),
        myDropDown(
          list: attemptsListWithNull,
          onDropDownChanged: onAttemptsChanged,
          initial: '',
          hint: 'Attempts',
        ),
        Row(
          children: [
            SizedBox(width: 5),
            myDropDown(
              list: styleList,
              onDropDownChanged: onStyleChanged,
              initial: 'Bouldering',
              hint: '',
            ),
            SizedBox(width: 5),
            myDropDown(
              list: timeFilterList,
              onDropDownChanged: onTimeFilterChanged,
              initial: 'Year',
              hint: '',
            ),
            SizedBox(width: 5),

            /*TextButton(
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                        Colors.white.withOpacity(0.1)),
                    backgroundColor: selectedAttempts == 'Flash'
                        ? MaterialStateProperty.all(Colors.blue)
                        : MaterialStateProperty.all(Colors.grey)),
                onPressed: () => setState(() {
                      selectedAttempts = 'Flash';
                      updateGraph();
                    }),
                child: Text('Flash', style: TextStyle(color: Colors.white))),
            SizedBox(
              width: 5,
            ),
            TextButton(
              style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all(Colors.white.withOpacity(0.1)),
                  backgroundColor: selectedAttempts == 'Redpoint'
                      ? MaterialStateProperty.all(Colors.blue)
                      : MaterialStateProperty.all(Colors.grey)),
              onPressed: () => setState(() {
                selectedAttempts = 'Redpoint';
                updateGraph();
              }),
              child: Text(
                'Redpoint',
                style: TextStyle(color: Colors.white),
              ),
            )*/
          ],
        ),
        timeFilter == 'Lifetime' || dateRange.length == 0
            ? SizedBox(height: 40)
            : timeLineCarousel(),
        Container(
          padding: EdgeInsets.all(30),
          height: 407,
          width: 500,
          child: LineChart(LineChartData(
              minY: 0,
              borderData: FlBorderData(show: false),
              gridData: FlGridData(drawVerticalLine: false),
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
                          return LineTooltipItem(spot.y.toStringAsFixed(0),
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
                                    width: timeFilter == 'Year' ? 30 : 40,
                                    height: 22,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color: timeFilter == 'Month'
                                            ? value == DateTime.now().day &&
                                                    dateRangeIndex ==
                                                        dateRange.length - 1
                                                ? Colors.blue
                                                : Colors.transparent
                                            : timeFilter == 'Lifetime'
                                                ? value == count.length
                                                    ? Colors.blue
                                                    : Colors.white
                                                        .withOpacity(0)
                                                : value ==
                                                            DateTime.now()
                                                                .month &&
                                                        dateRangeIndex ==
                                                            dateRange.length - 1
                                                    ? Colors.blue
                                                    : Colors.white
                                                        .withOpacity(0)),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      timeFilter == 'Lifetime'
                                          ? DateFormat('yyyy').format(DateTime(
                                              DateTime.now().year -
                                                  count.length +
                                                  value.toInt()))
                                          : timeFilter == 'Month'
                                              ? (value - 1) % 3 == 0 ||
                                                      value == count.length
                                                  ? DateFormat('d').format(
                                                      DateTime(
                                                          2024,
                                                          (DateTime.now()
                                                              .month),
                                                          value.toInt()))
                                                  : ''
                                              : DateFormat('MMM')
                                                  .format(DateTime(
                                                      2024, (value.toInt())))
                                                  .substring(0, 1),
                                      style: TextStyle(
                                          color: timeFilter == 'Month'
                                              ? value == DateTime.now().day
                                                  ? Colors.white
                                                  : Colors.black
                                              : timeFilter == 'Lifetime'
                                                  ? value == count.length
                                                      ? Colors.white
                                                      : Colors.black
                                                  : value ==
                                                              DateTime.now()
                                                                  .month &&
                                                          dateRangeIndex ==
                                                              dateRange.length -
                                                                  1
                                                      ? Colors.white
                                                      : Colors.black),
                                    )));
                          },
                          showTitles: true,
                          interval: 1,
                          reservedSize: 40)),
                  leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                          interval: widget.output == "COUNT" ? null : 1,
                          reservedSize: 25,
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return SideTitleWidget(
                                child: AutoSizeText(
                                  widget.output == "COUNT"
                                      ? value.toStringAsFixed(0)
                                      : style == 'Bouldering'
                                          ? 'V' + value.toStringAsFixed(0)
                                          : setRopesGradeText(
                                              ropesGradeList[value.toInt()]),
                                  maxLines: 1,
                                  minFontSize: 8,
                                ),
                                axisSide: meta.axisSide);
                          }))),
              lineBarsData: [
                LineChartBarData(
                    color: Colors.blue,
                    dotData: FlDotData(
                      checkToShowDot: (spot, barData) {
                        return spot.y != 0;
                      },
                    ),
                    spots: List.generate(count.length, (index) {
                      return FlSpot(index + 1, count[index].toDouble());
                    }))
              ])),
        )
      ],
    );
  }
}
