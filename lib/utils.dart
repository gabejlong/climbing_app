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
  if (grade < 2) {
    return Colors.amber;
  } else if (grade < 4) {
    return Colors.orange;
  } else if (grade < 6) {
    return Colors.pink;
  } else if (grade < 8) {
    return Colors.blue;
  } else if (grade < 9) {
    return Colors.purple;
  } else {
    return Colors.black;
  }
}

Color setRopesColor(double grade) {
  if (grade < 8) {
    return Colors.green;
  } else if (grade <= 9) {
    return Colors.amber;
  } else if (grade <= 10.5) {
    return Colors.orange;
  } else if (grade <= 11.5) {
    return Colors.pink;
  } else if (grade <= 12.5) {
    return Colors.blue;
  } else {
    return Colors.purple;
  }
}
