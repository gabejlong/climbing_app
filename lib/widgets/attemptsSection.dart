import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:climbing_app/models/lists_model.dart';

class attemptsSection extends StatefulWidget {
  final selectedAttempts;
  final Function(String) onAttemptsChanged;
  const attemptsSection(
      {required this.selectedAttempts, required this.onAttemptsChanged});

  @override
  State<attemptsSection> createState() => _attemptsState();
}

class _attemptsState extends State<attemptsSection> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Attempts',
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      SizedBox(
        height: 10,
      ),
      Row(
        children: List.generate(
          attemptsList.length,
          (index) {
            return Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        widget.onAttemptsChanged(attemptsList[index]);
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          widget.selectedAttempts == attemptsList[index]
                              ? Colors.black
                              : Color(0xfff0f0f0)),
                      overlayColor: MaterialStateProperty.all(
                          Colors.white.withOpacity(0.1)),
                    ),
                    child: Text(
                      attemptsList[index],
                      style: TextStyle(
                        color: widget.selectedAttempts == attemptsList[index]
                            ? Color(0xfff0f0f0)
                            : Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    )));
          },
        ),
      )
    ]);
  }
}
