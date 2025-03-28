import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class dateSection extends StatefulWidget {
  final selectedDateString;
  final Function(DateTime) onDateChanged;
  dateSection({required this.selectedDateString, required this.onDateChanged});

  @override
  State<dateSection> createState() => _dateState();
}

class _dateState extends State<dateSection> {
  TextEditingController _dateController = TextEditingController();
  final DateFormat outputFormat = DateFormat('EEEE, MMMM d, yyyy');
  late DateTime selectedDateDT;

  @override
  void initState() {
    super.initState();
    selectedDateDT = DateTime.parse(widget.selectedDateString!);
    _dateController.text = selectedDateDT.year == DateTime.now().year &&
            selectedDateDT.month == DateTime.now().month &&
            selectedDateDT.day == DateTime.now().day
        ? "Today"
        : outputFormat.format(selectedDateDT);
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
        initialDate: selectedDateDT, // TODO change to be the preselected date
        firstDate: DateTime(2010),
        lastDate: DateTime(2100));

    if (_picked != null) {
      selectedDateDT = _picked;
      setState(() {
        _dateController.text = _picked.year == DateTime.now().year &&
                _picked.month == DateTime.now().month &&
                _picked.day == DateTime.now().day
            ? 'Today'
            : outputFormat.format(_picked);
        widget.onDateChanged(selectedDateDT);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 45,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Color(0xff1D1617).withOpacity(0.11),
              blurRadius: 40,
              spreadRadius: 0.0)
        ]),
        child: TextField(
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
          controller: _dateController,
          decoration: InputDecoration(
              suffixIcon: Icon(
                CupertinoIcons.calendar,
                color: Colors.black,
              ),
              filled: false,
              labelText: 'Date',
              labelStyle: TextStyle(fontWeight: FontWeight.w600),
              contentPadding: EdgeInsets.all(0),
              hintStyle: TextStyle(color: Colors.white, fontSize: 18),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black))),
          readOnly: true,
          onTap: () {
            _selectDate(context);
          },
        ));
  }
}
