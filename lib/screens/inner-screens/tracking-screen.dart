import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:fidget_tool/services/stored-data.dart';

import 'package:fidget_tool/widgets/widgets.dart';

import 'package:fidget_tool/data/emotions.dart';

import 'package:fidget_tool/models/weekly-data-model.dart';

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
    var now = DateTime.now();
    _selectedData = WeeklyData(
      dateTime: now,
      emotions: StoredData.getEmotion(now),
    );
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
      await StoredData.setTimeTracker(
          StoredData.getTimeTracker(startTime) + pastUsageTime.inMilliseconds,
          startTime);
      print('test');
    } else {
      currentUsageTime = dateNow.difference(startTime);
    }
    print(currentUsageTime);
    await StoredData.setTimeTracker(
        StoredData.getTimeTracker(dateNow) + currentUsageTime.inMilliseconds,
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
    var minutesDouble = x;
    //x /= 60;
    //var hoursDouble = x % 24;

    //int hours = hoursDouble.;

    return minutesDouble;
  }

  Map<String, dynamic> dataBuilder(int week) {
    var dateNow = DateTime.now();
    var weekDay = dateNow.weekday;
    var firstDayOfWeek = dateNow
        .subtract(Duration(days: weekDay - 1))
        .subtract(Duration(days: week * 7));

    List<WeeklyData> timeDataList = [];

    double max = 0;

    for (var i = 0; i < 7; i++) {
      var iterDay = firstDayOfWeek.add(Duration(days: i));

      var timeInMins = getReadableTimeFromMillisecond(
          StoredData.getTimeTracker(iterDay) ?? 0);

      var emotion = StoredData.getEmotion(iterDay);
      timeDataList.add(WeeklyData(
        timeInMins: timeInMins,
        dateTime: iterDay,
        emotions: emotion,
      ));

      max = timeInMins > max ? timeInMins : max;
    }

    return {'max': max, 'data': timeDataList};
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
              final dataDict = dataBuilder(i);
              return TimeBarChart(
                weeklyData: dataDict['data'],
                refreshTime: refreshTime,
                changeSelectedDate: changeSelectedDate,
                max: dataDict['max'],
              );
            }).toList(),
          ),
          Text(
            DateFormat('dd MMM yyyy (EEE)').format(_selectedData.dateTime),
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: size.height * 0.03,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Emotion:',
                style: TextStyle(
                  fontSize: size.height * 0.025,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: size.width * 0.3,
                child: DropdownButtonFormField<Emotions>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.tealAccent[400],
                      ),
                      borderRadius: BorderRadius.circular(size.width * 0.05),
                    ),
                    //filled: true,
                    fillColor: Colors.tealAccent[400].withOpacity(0.8),
                  ),
                  value: _selectedData.emotions,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.height * 0.025,
                  ),
                  dropdownColor: Colors.tealAccent[400],
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
                        style: TextStyle(
                          color: value.getActiveColour(),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
