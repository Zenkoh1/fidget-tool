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
  ValueNotifier<List<double>> valueListener = ValueNotifier([.5, .5]);

  bool _isCoverVisible = false;

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final settingsModel = context.read<SettingsModel>();
    return SafeArea(
      child: Stack(
        children: [
          Container(
            child: Icon(
              FontAwesomeIcons.plus,
              size: size.width * 0.8,
              color: Colors.white,
            ),
            alignment: Alignment.center,
            // because the plus icon isnt entirely in the center
            padding: EdgeInsets.only(
              bottom: size.width * 0.8 * 0.09,
            ),
          ),
          Builder(
            builder: (context) {
              final handle = GestureDetector(
                onVerticalDragUpdate: (details) {
                  valueListener.value[0] = (valueListener.value[0] +
                          details.delta.dy / context.size.height)
                      .clamp(.3275, .6725);
                  valueListener.value = List.from(valueListener.value);
                },
                onHorizontalDragUpdate: (details) {
                  valueListener.value[1] = (valueListener.value[1] +
                          details.delta.dx / context.size.width)
                      .clamp(.185, .815);
                  valueListener.value = List.from(valueListener.value);
                },
                onHorizontalDragEnd: (_) {
                  valueListener.value[1] = .5;
                  valueListener.value = List.from(valueListener.value);

                  Vibration.vibrate(
                      duration: 50,
                      amplitude: settingsModel.vibration.getAmplitude());
                },
                onVerticalDragEnd: (_) {
                  valueListener.value[0] = .5;
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
                  return Align(
                    alignment: Alignment(valueListener.value[1] * 2 - 1,
                        valueListener.value[0] * 2 - 1),
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
              initialOffset: Offset.zero,
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
