import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import "package:climbing_app/models/lists_model.dart";

class notesSection extends StatefulWidget {
  final selectedNotes;
  final Function(String) onNotesChanged;
  notesSection({required this.selectedNotes, required this.onNotesChanged});

  @override
  State<notesSection> createState() => _notesState();
}

class _notesState extends State<notesSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        //height: 45,
        child: Focus(
            onFocusChange: (hasFocus) {
              if (hasFocus == false) {
                FocusManager.instance.primaryFocus?.unfocus();
                // setLocation(_locationController.text);
              }
            },
            child: TextField(
              cursorErrorColor: Colors.black,
              cursorColor: Colors.black,
              // controller: _locationController,
              // focusNode: focusNode,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
              // onEditingComplete: onEditingComplete,
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  /* suffixIcon: Icon(
                    CupertinoIcons.person_fill,
                    color: Colors.black,
                  ),*/
                  filled: false,
                  contentPadding: EdgeInsets.all(0),
                  labelText: 'Notes (optional)',
                  labelStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                  hintText: 'Endurance session today...',
                  hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black))),
            )));
  }
}
