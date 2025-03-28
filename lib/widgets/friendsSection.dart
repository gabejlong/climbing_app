import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import "package:climbing_app/models/lists_model.dart";

class friendsSection extends StatefulWidget {
  final selectedFriends;
  final Function(String) onFriendChanged;
  friendsSection(
      {required this.selectedFriends, required this.onFriendChanged});

  @override
  State<friendsSection> createState() => _friendState();
}

class _friendState extends State<friendsSection> {
  TextEditingController _dateController = TextEditingController();
  final DateFormat outputFormat = DateFormat('EEEE, MMMM d, yyyy');
  late DateTime selectedDateDT;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Autocomplete<String>(
          // initialValue: TextEditingValue(text: widget.selectedLocation ?? ''),
          optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return friendsOptions.where((String option) {
          option = option.toLowerCase();
          return option.contains(textEditingValue.text.toLowerCase());
        });
      }, onSelected: (String selection) {
        // setLocation(selection);
      }, fieldViewBuilder:
              (context, _locationController, focusNode, onEditingComplete) {
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
                  controller: _locationController,
                  focusNode: focusNode,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                  onEditingComplete: onEditingComplete,
                  decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: Icon(
                        CupertinoIcons.person_fill,
                        color: Colors.black,
                      ),
                      filled: false,
                      contentPadding: EdgeInsets.all(0),
                      labelText: 'Friends (optional)',
                      labelStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
                      hintText: 'long.climber',
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black))),
                )));
      })
    ]);
  }
}
