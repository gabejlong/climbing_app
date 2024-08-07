import 'package:flutter/material.dart';
import 'package:climbing_app/utils.dart' as utils;
import 'package:climbing_app/models/lists_model.dart';
import 'package:auto_size_text/auto_size_text.dart';

class gradesSection extends StatefulWidget {
  final String selectedStyle;
  final double selectedRopesGrade;
  final double selectedBoulderingGrade;
  final Function(double) onGradeChanged;

  gradesSection(
      {required this.selectedStyle,
      required this.selectedRopesGrade,
      required this.selectedBoulderingGrade,
      required this.onGradeChanged});

  @override
  State<gradesSection> createState() => _gradesState();
}

class _gradesState extends State<gradesSection> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      /*Text(
        'Grade',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),*/
      SizedBox(
        height: 5,
      ),
      Container(
        height: 70,
        width: double.infinity,
        color: const Color.fromARGB(26, 150, 150, 150),
        child: ListView.separated(
            shrinkWrap: true,
            itemCount: (widget.selectedStyle != 'Bouldering'
                ? ropesGradeList.length
                : boulderingGradeList.length),
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            separatorBuilder: (context, index) => SizedBox(
                  width: 5,
                ),
            itemBuilder: (context, index) {
              return Container(
                  height: 50,
                  width: 50,
                  child: TextButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(CircleBorder()),
                          overlayColor: MaterialStateProperty.all(
                              Colors.white.withOpacity(0.1)),
                          backgroundColor: MaterialStateProperty.all(
                            widget.selectedStyle != 'Bouldering'
                                ? (widget.selectedRopesGrade ==
                                        ropesGradeList[index]
                                    ? utils.setRopesColor(ropesGradeList[index])
                                    : Colors.grey)
                                : (widget.selectedBoulderingGrade ==
                                        boulderingGradeList[index]
                                    ? utils.setBoulderingColor(
                                        boulderingGradeList[index])
                                    : Colors.grey),
                          )),
                      onPressed: () {
                        setState(() {
                          widget.selectedStyle != 'Bouldering'
                              ? widget.onGradeChanged(ropesGradeList[index])
                              : widget
                                  .onGradeChanged(boulderingGradeList[index]);
                        });
                      },
                      child: Container(
                        height: 60,
                        width: 50,
                        child: Align(
                          child: AutoSizeText(
                            minFontSize: 10,
                            maxLines: 1,
                            //overflow: TextOverflow.ellipsis,
                            widget.selectedStyle != 'Bouldering'
                                ? utils.setRopesGradeText(ropesGradeList[index])
                                : 'V' +
                                    (boulderingGradeList[index])
                                        .toStringAsFixed(0),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )));
            }),
      )
    ]);
  }
}
