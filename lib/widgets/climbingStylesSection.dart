import 'package:flutter/material.dart';
import 'package:climbing_app/custom_icons_icons.dart';
import 'package:climbing_app/models/lists_model.dart';

class climbingStylesSection extends StatefulWidget {
  final String selectedStyle;
  final Function(String) onStyleChanged;
  const climbingStylesSection(
      {required this.selectedStyle, required this.onStyleChanged});

  @override
  State<climbingStylesSection> createState() => _climbingStylesState();
}

class _climbingStylesState extends State<climbingStylesSection> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      /*(Text(
        'Style',
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),*/
      SizedBox(
        height: 5,
      ),
      Container(
        height: 110,
        //child: Center(
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: typeList.length,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: 20, right: 20),
          separatorBuilder: (context, index) => SizedBox(
            width: 0,
          ),
          itemBuilder: (context, index) {
            return Container(
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        widget.onStyleChanged(typeList[index]);
                      });
                    },
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.white.withOpacity(0.1)),
                      backgroundColor: MaterialStateProperty.all(
                          widget.selectedStyle == typeList[index]
                              ? Colors.blue
                              : Colors.grey),
                      shape: MaterialStateProperty.all(CircleBorder()),
                    ),
                    child: Container(
                      height: 60,
                      width: 60,
                      child: typeList[index] == 'Top Rope'
                          ? Icon(
                              CustomIcons.rope,
                              size: 50,
                              color: Colors.white.withOpacity(0.9),
                            )
                          : typeList[index] == 'Bouldering'
                              ? Icon(
                                  CustomIcons.rock,
                                  size: 50,
                                  color: Colors.white.withOpacity(0.9),
                                )
                              : Icon(CustomIcons.lead,
                                  size: 50,
                                  color: Colors.white.withOpacity(0.9)),
                    ),
                  ),
                  Container(
                    child: Text(
                      typeList[index],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    ]);
  }
}
