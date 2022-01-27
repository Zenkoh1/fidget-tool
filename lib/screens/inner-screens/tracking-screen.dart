import 'dart:math';

import 'package:fidget_tool/data/emotions.dart';
import 'package:fidget_tool/models/weekly-data-model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:fidget_tool/services/data-preferences.dart';

import 'package:fidget_tool/widgets/widgets.dart';

class TrackingScreen extends StatefulWidget {
  TrackingScreen({Key key}) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen>
    with WidgetsBindingObserver {
  final DateFormat dateFormat = DateFormat("dd-MM-yyyy");

  DateTime startTime;

  WeeklyData _selectedData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    startTimer();
    _selectedData = WeeklyData(dateTime: DateTime.now());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      startTimer();
    }

    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      stopTimer();
    }
  }

  void startTimer() {
    startTime = DateTime.now();
  }

  void stopTimer() async {
    DateTime dateNow = DateTime.now();
    Duration currentUsageTime;
    if (dateNow.day != startTime.day) {
      // if u somehow use it past midnight
      currentUsageTime = dateNow
          .difference(DateTime(dateNow.year, dateNow.month, dateNow.day));
      Duration pastUsageTime =
          DateTime(dateNow.year, dateNow.month, dateNow.day)
              .difference(startTime);
      await StoredData.setTimeTrackerOption(
          StoredData.getTimeTrackerOption(startTime) +
              pastUsageTime.inMilliseconds,
          startTime);
    } else {
      currentUsageTime = dateNow.difference(startTime);
    }

    await StoredData.setTimeTrackerOption(
        StoredData.getTimeTrackerOption(dateNow) +
            currentUsageTime.inMilliseconds,
        dateNow);
    setState(() {});
  }

  void refreshTime() async {
    stopTimer();
    startTime = DateTime.now();
  }

  double getReadableTimeFromMillisecond(int timeInMillisecond) {
    var x = timeInMillisecond / 1000;
    // for now, i don't use seconds
    var seconds = x.truncate() % 60;
    x /= 60;
    var minutes = x.truncate() % 60;
    x /= 60;
    var hoursDouble = x % 24;

    //int hours = hoursDouble.;

    return hoursDouble;
  }

  List<WeeklyData> dataBuilder(int week) {
    var dateNow = DateTime.now();
    var weekDay = dateNow.weekday;
    var firstDayOfWeek = dateNow
        .subtract(Duration(days: weekDay - 1))
        .subtract(Duration(days: week * 7));

    List<WeeklyData> timeDataList = [];

    for (var i = 0; i < 7; i++) {
      var iterDay = firstDayOfWeek.add(Duration(days: i));

      var timeInHours = getReadableTimeFromMillisecond(
          StoredData.getTimeTrackerOption(iterDay) ?? 0);

      var emotion = StoredData.getEmotion(iterDay) ?? Emotions.Neutral;
      timeDataList.add(WeeklyData(
        timeInHours: timeInHours,
        dateTime: iterDay,
        emotions: emotion,
      ));
    }

    return timeDataList;
  }

  void changeSelectedDate(WeeklyData weeklyData) {
    setState(() {
      _selectedData = weeklyData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: size.height * 0.55,
              viewportFraction: 1,
              enableInfiniteScroll: false,
              reverse: true,
            ),
            items: [0, 1, 2, 3].map((i) {
              return TimeBarChart(
                weeklyData: dataBuilder(i),
                refreshTime: refreshTime,
                changeSelectedDate: changeSelectedDate,
              );
            }).toList(),
          ),
          Text(
            DateFormat('dd MMM yyyy').format(_selectedData.dateTime),
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: size.height * 0.03,
            ),
          ),
          DropdownButton<Emotions>(
            value: _selectedData.emotions,
            style: const TextStyle(color: Colors.redAccent),
            underline: Container(
              height: 2,
              color: Colors.redAccent,
            ),
            onChanged: (Emotions newValue) {
              setState(() {
                _selectedData.emotions = newValue;
                StoredData.setEmotion(_selectedData.dateTime, newValue);
              });
            },
            items: Emotions.values
                .map<DropdownMenuItem<Emotions>>((Emotions value) {
              return DropdownMenuItem<Emotions>(
                value: value,
                child: Text(
                  value.toShortString(),
                  style: TextStyle(fontSize: size.height * 0.025),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
