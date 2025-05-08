import 'package:climbing_app/models/filtersModels.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import "package:climbing_app/models/lists_model.dart";

class SortPanel extends StatefulWidget {
  String selectedSort;
  bool isClimb;
  final Function(String) onPanelChanged;
  SortPanel(
      {required this.selectedSort,
      required this.isClimb,
      required this.onPanelChanged});

  @override
  State<SortPanel> createState() => _sortPanelState();
}

class _sortPanelState extends State<SortPanel> {
  late List<String> options;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    options = widget.isClimb ? climbSortOptions : sessionSortOptions;

    /*print(widget.isClimb.toString() + " is?");
    print(options.length.toString() + " length");*/
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
            children: List.generate(options.length, (index) {
              return Column(children: [
                Row(children: [
                  Container(
                    width: 15,
                    height: 15,
                    child: TextButton(
                      child: Text(''),
                      onPressed: () {
                        setState(() {
                          widget.selectedSort = options[index];
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            widget.selectedSort == options[index]
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
                    options[index],
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
}
