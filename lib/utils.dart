import "package:flutter/material.dart";

double setRopesGradeNum(String grade) {
  final modifier = grade.substring(grade.length - 1);
  grade = grade.substring(2);

  switch (modifier) {
    case '+':
      return (double.parse(grade.substring(0, grade.length - 1)) + 0.1);
    case '-':
      return (double.parse(grade.substring(0, grade.length - 1)) - 0.1);
    default:
      return double.parse(grade);
  }
}

String setRopesGradeText(double grade) {
  double modifier = (grade - grade.toInt());
  String symbol = '';
  if (modifier > 0.8) {
    symbol = '-';
  } else if (modifier > 0.08) {
    symbol = '+';
  }
  return '5.' + (grade.round()).toString() + symbol;
}

Color setBoulderingColor(double grade) {
  if (grade == 0) {
    return Color(0xffEB56C8);
  } else if (grade == 1) {
    return Color(0xffC0229B);
  } else if (grade == 2) {
    return Color(0xff921174);
  } else if (grade == 3) {
    return Color(0xff9E56EB);
  } else if (grade == 4) {
    return Color(0xff8A3FDA);
  } else if (grade == 5) {
    return Color(0xff6019AA);
  } else if (grade == 6) {
    return Color(0xff1692F4);
  } else if (grade == 7) {
    return Color(0xff0070C9);
  } else if (grade == 8) {
    return Color(0xff02518F);
  } else if (grade == 9) {
    return Color(0xff38C4CE);
  } else if (grade == 10) {
    return Color(0xff259CA4);
  } else if (grade == 11) {
    return Color(0xff0B7980);
  } else if (grade == 12) {
    return Color(0xff2CBE4A);
  } else if (grade == 13) {
    return Color(0xff29A742);
  } else if (grade == 14) {
    return Color(0xff128B2A);
  } else if (grade == 15) {
    return Color(0xffE98B2D);
  } else if (grade == 16) {
    return Color(0xffD87818);
  } else if (grade == 17) {
    return Color(0xffA85502);
  } else {
    return Colors.black;
  }
}

Color setRopesColor(double grade) {
  if (grade == 6) {
    return Color(0xffEB56C8);
  } else if (grade == 7) {
    return Color(0xffC0229B);
  } else if (grade == 8) {
    return Color(0xff921174);
  } else if (grade == 9) {
    return Color(0xff9E56EB);
  } else if (grade == 9.9) {
    return Color(0xff8A3FDA);
  } else if (grade == 10) {
    return Color(0xff6019AA);
  } else if (grade == 10.1) {
    return Color(0xff1692F4);
  } else if (grade == 10.9) {
    return Color(0xff0070C9);
  } else if (grade == 11) {
    return Color(0xff02518F);
  } else if (grade == 11.1) {
    return Color(0xff38C4CE);
  } else if (grade == 11.9) {
    return Color(0xff259CA4);
  } else if (grade == 12) {
    return Color(0xff0B7980);
  } else if (grade == 12.1) {
    return Color(0xff2CBE4A);
  } else if (grade == 12.9) {
    return Color(0xff29A742);
  } else if (grade == 13) {
    return Color(0xff128B2A);
  } else if (grade == 13.1) {
    return Color(0xffE98B2D);
  } else if (grade == 13.9) {
    return Color(0xffD87818);
  } else if (grade == 14) {
    return Color(0xffA85502);
  } else {
    return Colors.black;
  }
}
