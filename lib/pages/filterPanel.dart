import 'package:climbing_app/models/filtersModels.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import "package:climbing_app/models/lists_model.dart";
import "package:climbing_app/widgets/allWidgets.dart";

class FilterPanel extends StatefulWidget {
  final BaseFilters filters;
  final Function(BaseFilters) onPanelChanged;
  FilterPanel({required this.filters, required this.onPanelChanged});

  @override
  State<FilterPanel> createState() => _filterPanelState();
}

class _filterPanelState extends State<FilterPanel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              selected: widget.filters.selectedTypeFilters,
              items: typeList,
              onItemPressed: (filterSet) => {
                    setState(() {
                      widget.filters.selectedTypeFilters = filterSet;
                    })
                  }),
          SizedBox(height: 20),
          if (widget.filters is ClimbFilters)
            Builder(builder: (context) {
              final climbFilters = widget.filters as ClimbFilters;
              RangeValues activeGradeFilter =
                  RangeValues(climbFilters.lowGrade, climbFilters.highGrade);
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
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
                    Text(
                      'Location',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MultiSelect(
                        selected: climbFilters.selectedLocationFilters,
                        items: locationOptions,
                        onItemPressed: (filterSet) {
                          climbFilters.selectedLocationFilters = filterSet;
                        }),
                    Text(
                      'Tags',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MultiSelect(
                        selected: climbFilters.selectedTagsFilters,
                        items: tagsList,
                        onItemPressed: (filterSet) {
                          climbFilters.selectedTagsFilters = filterSet;
                        })
                  ]);
            })
        ],
      ),
    );
  }
}
