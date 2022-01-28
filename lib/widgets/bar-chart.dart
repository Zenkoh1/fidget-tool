import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'package:fidget_tool/models/weekly-data-model.dart';
import 'package:fidget_tool/data/emotions.dart';

class TimeBarChart extends StatefulWidget {
  final List<WeeklyData> weeklyData;
  final num max;

  final VoidCallback refreshTime;
  final Function(WeeklyData) changeSelectedDate;

  TimeBarChart(
      {Key key,
      @required this.weeklyData,
      @required this.refreshTime,
      @required this.changeSelectedDate,
      @required max})
      : this.max = max > 180 ? max : 180,
        super(key: key);

  @override
  State<TimeBarChart> createState() => _TimeBarChartState();
}

class _TimeBarChartState extends State<TimeBarChart> {
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool showToolTip = false;

  String getSubTitle(List<WeeklyData> weeklyData) {
    final firstPart = DateFormat('dd MMM').format(weeklyData.first.dateTime);
    final lastPart = DateFormat('dd MMM').format(weeklyData.last.dateTime);

    return "$firstPart - $lastPart";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.03),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          color: const Color(0xff81e5cd),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      'Time Usage (Min)',
                      style: TextStyle(
                          color: Color(0xff0f4a3c),
                          fontSize: size.height * 0.035,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: size.height * 0.005,
                    ),
                    Text(
                      getSubTitle(widget.weeklyData),
                      style: TextStyle(
                          color: Color(0xff379982),
                          fontSize: size.height * 0.0225,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: BarChart(
                          mainBarData(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(size.width * 0.03),
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.refresh,
                      color: const Color(0xff0f4a3c),
                    ),
                    onPressed: () {
                      setState(() {
                        widget.refreshTime();
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    WeeklyData y, {
    bool isTouched = false,
    List<int> showTooltips = const [],
  }) {
    final size = MediaQuery.of(context).size;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          y: isTouched ? y.timeInMins + 1 : y.timeInMins,
          colors: isTouched
              ? [y.emotions.getActiveColour()]
              : [y.emotions.getColour()],
          width: size.width * 0.06,
          borderSide: isTouched
              ? BorderSide(color: y.emotions.getActiveColour(), width: 1)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 180,
            colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() {
    return widget.weeklyData
        .mapIndexed((index, timeData) =>
            makeGroupData(index, timeData, isTouched: index == touchedIndex))
        .toList();
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        handleBuiltInTouches: showToolTip,
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Monday';
                  break;
                case 1:
                  weekDay = 'Tuesday';
                  break;
                case 2:
                  weekDay = 'Wednesday';
                  break;
                case 3:
                  weekDay = 'Thursday';
                  break;
                case 4:
                  weekDay = 'Friday';
                  break;
                case 5:
                  weekDay = 'Saturday';
                  break;
                case 6:
                  weekDay = 'Sunday';
                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                weekDay + '\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.y - 1).toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              showToolTip = false;

              return;
            }

            if (barTouchResponse.spot.touchedRodData.y == 0.0) return;
            setState(() {
              showToolTip = true;
            });
            widget.changeSelectedDate(
                widget.weeklyData[barTouchResponse.spot.touchedBarGroupIndex]);

            touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }
}
