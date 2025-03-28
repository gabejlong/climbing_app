import 'package:flutter/material.dart';
import 'package:climbing_app/utils.dart' as utils;
import 'package:climbing_app/models/lists_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import 'dart:math';

class gradesSection extends StatefulWidget {
  bool isBoulder;
  double? selectedGrade;
  final Function(double) onGradeChanged;

  gradesSection(
      {required this.isBoulder,
      this.selectedGrade,
      required this.onGradeChanged});

  @override
  State<gradesSection> createState() => _gradesState();
}

class _gradesState extends State<gradesSection> {
  late int gradesIndex;
  @override
  void initState() {
    gradesIndex = widget.isBoulder
        ? boulderingGradeList.indexOf(widget.selectedGrade!)
        : ropesGradeList.indexOf(widget.selectedGrade!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        width: double.infinity,
        //color: const Color.fromARGB(26, 150, 150, 150),
        //child: Expanded(
        child: Padding(
          padding: EdgeInsets.only(),
          child: ScrollSnapList(
              initialIndex: gradesIndex.toDouble(),
              dynamicSizeEquation: (distance) {
                //default equation
                return 1 - min(distance.abs() / 300, 0.3);
              },
              dynamicItemSize: true,
              onItemFocus: (index) {
                setState(() {
                  gradesIndex = index;
                  double grade = widget.isBoulder
                      ? boulderingGradeList[gradesIndex]
                      : ropesGradeList[gradesIndex];
                  widget.onGradeChanged(grade);
                });
              },
              itemSize: 90,
              itemCount: (widget.isBoulder
                  ? boulderingGradeList.length
                  : ropesGradeList.length),
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(top: 5, bottom: 5),
              itemBuilder: (context, gradesIndex) {
                return Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(70), // Optional rounded corners
                      color: Colors.white,
                      border: Border.all(
                          color: widget.isBoulder
                              ? utils.setBoulderingColor(
                                  boulderingGradeList[gradesIndex])
                              : utils
                                  .setRopesColor(ropesGradeList[gradesIndex]),
                          width: 8),
                    ),
                    child: Container(
                      height: 60,
                      width: 50,
                      child: Align(
                        child: AutoSizeText(
                          minFontSize: 10,
                          maxLines: 1,
                          //overflow: TextOverflow.ellipsis,
                          widget.isBoulder
                              ? 'V' +
                                  (boulderingGradeList[gradesIndex])
                                      .toStringAsFixed(0)
                              : utils.setRopesGradeText(
                                  ropesGradeList[gradesIndex]),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 38,
                              fontWeight: FontWeight.w900 // .w900,
                              ),
                        ),
                      ),
                    ));
              }),
        )); //);
  }
}
