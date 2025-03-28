import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import "package:climbing_app/models/lists_model.dart";

class nameSection extends StatefulWidget {
  final String? selectedName;
  final Function(String) onNameChanged;
  nameSection({this.selectedName, required this.onNameChanged});

  @override
  State<nameSection> createState() => _nameState();
}

class _nameState extends State<nameSection> {
  TextEditingController nameController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    nameController.text = widget.selectedName ?? "";
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    nameController.dispose();
    super.dispose();
  }

  setName(text) {
    setState(() {
      if (text != '') {
        widget.onNameChanged(text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Focus(
            onFocusChange: (hasFocus) {
              if (hasFocus == false) {
                FocusManager.instance.primaryFocus?.unfocus();
                setName(nameController.text);
              }
            },
            child: TextField(
              controller: nameController,
              focusNode: focusNode,
              cursorErrorColor: Colors.black,
              cursorColor: Colors.black,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
              // onEditingComplete: onEditingComplete,
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  filled: false,
                  contentPadding: EdgeInsets.all(0),
                  labelText: 'Name (optional)',
                  labelStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                  hintText: 'Burden of Dreams',
                  hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black))),
            )));
  }
}
