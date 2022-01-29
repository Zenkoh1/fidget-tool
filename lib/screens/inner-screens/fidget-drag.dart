import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vibration/vibration.dart';
import 'package:provider/provider.dart';

import 'package:fidget_tool/widgets/widgets.dart';
import 'package:fidget_tool/models/settings-model.dart';
import 'package:fidget_tool/data/vibration-options.dart';

class FidgetDrag extends StatefulWidget {
  const FidgetDrag({Key key}) : super(key: key);

  static const route = '/fidgetscroller';

  @override
  _FidgetDragState createState() => _FidgetDragState();
}

class _FidgetDragState extends State<FidgetDrag> {
  ValueNotifier<List<int>> valueListener;

  bool _isCoverVisible = false;
  double circleRadius;

  bool _init = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) {
      final size = MediaQuery.of(context).size;
      circleRadius = size.width * 0.07;
      valueListener = ValueNotifier([
        (size.height / 2 - circleRadius).toInt(),
        (size.width / 2 - circleRadius).toInt()
      ]);
      _init = false;
    }
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final iconSize = size.width * 0.8;
    final settingsModel = context.read<SettingsModel>();

    final topPosPlusIcon = (size.height - iconSize) / 2 - (iconSize * 0.05);
    final leftPosPlusIcon = (size.width - iconSize) / 2;
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: topPosPlusIcon,
            left: leftPosPlusIcon,

            child: Icon(
              FontAwesomeIcons.plus,
              size: iconSize,
              color: Colors.white,
            ),

            // because the plus icon isnt entirely in the center
          ),
          Builder(
            builder: (context) {
              final handle = GestureDetector(
                onVerticalDragUpdate: (details) {
                  final actualPlusSize = (iconSize * 0.785);
                  final padding = (iconSize * 0.11);

                  valueListener.value[0] =
                      (valueListener.value[0] + details.delta.dy.toInt()).clamp(
                          (topPosPlusIcon + padding).toInt(),
                          (topPosPlusIcon +
                                  actualPlusSize +
                                  padding -
                                  circleRadius)
                              .toInt());

                  valueListener.value = List.from(valueListener.value);
                },
                onHorizontalDragUpdate: (details) {
                  final actualPlusSize = (iconSize * 0.785);
                  final padding = (iconSize * 0.065);
                  valueListener.value[1] =
                      (valueListener.value[1] + details.delta.dx.toInt()).clamp(
                          (leftPosPlusIcon + padding).toInt(),
                          (leftPosPlusIcon +
                                  actualPlusSize +
                                  padding -
                                  circleRadius)
                              .toInt());
                  valueListener.value = List.from(valueListener.value);
                },
                onHorizontalDragEnd: (_) {
                  valueListener.value[1] =
                      (size.width / 2 - circleRadius).toInt();
                  valueListener.value = List.from(valueListener.value);

                  Vibration.vibrate(
                      duration: 50,
                      amplitude: settingsModel.vibration.getAmplitude());
                },
                onVerticalDragEnd: (_) {
                  valueListener.value[0] =
                      (size.height / 2 - circleRadius).toInt();
                  valueListener.value = List.from(valueListener.value);

                  Vibration.vibrate(
                      duration: 50,
                      amplitude: settingsModel.vibration.getAmplitude());
                },
                child: CircleAvatar(
                  radius: size.width * 0.07,
                  backgroundColor: Colors.red,
                ),
              );

              return AnimatedBuilder(
                animation: valueListener,
                builder: (context, child) {
                  return Positioned(
                    top: (valueListener.value[0]).toDouble(),
                    left: (valueListener.value[1]).toDouble(),
                    child: child,
                  );
                },
                child: handle,
              );
            },
          ),
          BlackCover(
            isCoverVisible: _isCoverVisible,
          ),
          // IconButton(
          //   icon: Icon(
          //     _isCoverVisible
          //         ? FontAwesomeIcons.lightbulb
          //         : FontAwesomeIcons.solidLightbulb,
          //     color: Colors.white,
          //     size: size.width * 0.1,
          //   ),
          //   onPressed: () {
          //     setState(() {
          //       _isCoverVisible = !_isCoverVisible;
          //     });
          //   },
          // ),
          Visibility(
            visible: settingsModel.hasBulb,
            child: DraggableLightBulb(
              initialOffset: Offset(10, 10),
              onPressed: () {
                setState(() {
                  _isCoverVisible = !_isCoverVisible;
                });
              },
              isLitUp: !_isCoverVisible,
            ),
          ),
        ],
      ),
    );
  }
}
