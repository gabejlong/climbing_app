import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import "package:flutter/material.dart";
import 'package:dropdown_button2/dropdown_button2.dart';

class myDropDown extends StatefulWidget {
  final List<String> list;
  final void Function(String) onDropDownChanged;
  final String initial;
  final String hint;

  myDropDown(
      {required this.list,
      required this.hint,
      required this.onDropDownChanged,
      required this.initial});
  @override
  State<myDropDown> createState() => _myDropDownState();
}

class _myDropDownState extends State<myDropDown> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: DropdownButton2(
      buttonStyleData: ButtonStyleData(
          //width: 100,
          padding: EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10))),
      dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10))),
      value: dropdownValue,
      hint: Text(widget.hint),
      onChanged: (value) {
        setState(() {
          dropdownValue = value!;
          widget.onDropDownChanged(value);
        });
      },
      items: widget.list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        );
      }).toList(),
    ));
  }
}
