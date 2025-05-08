import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:climbing_app/models/lists_model.dart';

class PasswordTextfield extends StatefulWidget {
  final String? initialValue;
  final String label;
  //final String? hintText;
  final void Function(String) onChanged;

  const PasswordTextfield({
    Key? key,
    required this.label,
    this.initialValue,
    //this.hintText,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<PasswordTextfield> createState() => _textFieldFocusState();
}

class _textFieldFocusState extends State<PasswordTextfield> {
  late TextEditingController _controller;
  bool hidden = true;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        FocusManager.instance.primaryFocus?.unfocus();
        widget.onChanged(_controller.text); // Save on focus loss
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
        /*focusNode: _focusNode,
        onFocusChange: (hasFocus) {
          if (hasFocus == false) {
            FocusManager.instance.primaryFocus?.unfocus();
            widget.onChanged(_controller.text);
            print(
          } else if (hasFocus == true) {
            print("NONONONON");
          }
        },*/
        child: TextField(
      obscureText: hidden,

      controller: _controller,
      onChanged: (text) {
        setState(() {
          widget.onChanged(text);
        });
      },
      //focusNode: _focusNode,
      decoration: InputDecoration(
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                hidden = !hidden;
              });
            },
            icon: Icon(hidden ? CupertinoIcons.eye : CupertinoIcons.eye_slash)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: false,
        contentPadding: EdgeInsets.all(0),
        labelText: widget.label,
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        hintText: '•••••••••',
        hintStyle: TextStyle(
            color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w600),
        border:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      ),
    ));
  }
}
