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
    return Column(children: [
      /*Text(
        'Attempts',
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),*/
      SizedBox(
        height: 5,
      ),
      Container(
        height: 110,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: attemptsList.length,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: 20, right: 20),
          separatorBuilder: (context, index) => SizedBox(
            width: 0,
          ),
          itemBuilder: (context, index) {
            return Column(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      widget.onAttemptsChanged(attemptsList[index]);
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        widget.selectedAttempts == attemptsList[index]
                            ? Colors.blue
                            : Colors.grey),
                    overlayColor: MaterialStateProperty.all(
                        Colors.white.withOpacity(0.1)),
                    shape: MaterialStateProperty.all(CircleBorder()),
                  ),
                  child: Container(
                    height: 60,
                    width: 60,
                    child: attemptsList[index] == 'Flash'
                        ? Icon(
                            CupertinoIcons.bolt_fill,
                            color:
                                widget.selectedAttempts == attemptsList[index]
                                    ? Colors.amber
                                    : Color.fromARGB(255, 190, 190, 190),
                            size: 50,
                          )
                        : Icon(
                            CupertinoIcons.circle_fill,
                            color:
                                widget.selectedAttempts == attemptsList[index]
                                    ? Colors.red
                                    : const Color.fromARGB(255, 118, 118, 118),
                            size: 50,
                          ),
                  ),
                ),
                Text(
                  attemptsList[index],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            );
          },
        ),
      ),
    ]);
  }
}
