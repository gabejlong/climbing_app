import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import "package:climbing_app/models/lists_model.dart";

class MultiSelect extends StatefulWidget {
  final Set<String> selected;
  final List<String> items;
  final Function(Set<String>) onItemPressed;
  MultiSelect(
      {required this.selected,
      required this.items,
      required this.onItemPressed});

  @override
  State<MultiSelect> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: List.generate(
        widget.items.length,
        (index) {
          return Column(
            children: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      if (widget.selected.contains(widget.items[index])) {
                        widget.selected.remove(widget.items[index]);
                      } else {
                        widget.selected.add(widget.items[index]);
                      }
                      widget.onItemPressed(widget.selected);
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        widget.selected.contains(widget.items[index])
                            ? Colors.black
                            : Color(0xfff0f0f0)),
                    overlayColor: MaterialStateProperty.all(
                        Colors.white.withOpacity(0.1)),
                  ),
                  child: Text(
                    widget.items[index],
                    style: TextStyle(
                      color: widget.selected.contains(widget.items[index])
                          ? Color(0xfff0f0f0)
                          : Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ))
            ],
          );
        },
      ),
    );
  }
}
