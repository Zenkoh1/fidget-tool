import 'package:flutter/material.dart';

import 'package:fidget_tool/data/emotions.dart';

class WeeklyData {
  double timeInMins;
  final DateTime dateTime;
  Emotions emotions;

  WeeklyData({
    this.timeInMins,
    @required this.dateTime,
    this.emotions,
  });
}
