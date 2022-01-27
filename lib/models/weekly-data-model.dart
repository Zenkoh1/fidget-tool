import 'package:flutter/material.dart';

import 'package:fidget_tool/data/emotions.dart';

class WeeklyData {
  double timeInHours;
  final DateTime dateTime;
  Emotions emotions;

  WeeklyData({
    this.timeInHours,
    @required this.dateTime,
    this.emotions,
  });
}
