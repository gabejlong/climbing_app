import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class dateSection extends StatefulWidget {
  final selectedDate;
  final Function(String) onDateChanged;
  dateSection({required this.selectedDate, required this.onDateChanged});

  @override
  State<dateSection> createState() => _dateState();
}

class _dateState extends State<dateSection> {
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = widget.selectedDate!;
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? _picked = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                surfaceTint: Colors.white,
                primary: Colors.blue, // header background color
                surface: Colors.white,
                onSurface: Colors.black, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2010),
        lastDate: DateTime(2100));

    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
        widget.onDateChanged(_dateController.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 45,
        margin: EdgeInsets.only(top: 10, left: 20, right: 20),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Color(0xff1D1617).withOpacity(0.11),
              blurRadius: 40,
              spreadRadius: 0.0)
        ]),
        child: TextField(
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          controller: _dateController,
          decoration: InputDecoration(
              prefixIcon: Icon(
                CupertinoIcons.calendar,
                color: Colors.white,
              ),
              filled: true,
              fillColor: Colors.blue,
              contentPadding: EdgeInsets.all(0),
              hintText: 'Date',
              hintStyle: TextStyle(color: Colors.white, fontSize: 18),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none)),
          readOnly: true,
          onTap: () {
            _selectDate(context);
          },
        ));
  }
}
