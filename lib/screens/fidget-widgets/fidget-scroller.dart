import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:fidget_tool/models/settings-model.dart';

import 'package:fidget_tool/widgets/widgets.dart';

import 'package:fidget_tool/data/vibration-options.dart';

class FidgetScroller extends StatefulWidget {
  const FidgetScroller({Key key}) : super(key: key);

  @override
  _FidgetScrollerState createState() => _FidgetScrollerState();
}

class _FidgetScrollerState extends State<FidgetScroller> {
  bool _isCoverVisible;

  @override
  void initState() {
    super.initState();
    _isCoverVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final settingsModel = context.read<SettingsModel>();
    return SafeArea(
      child: Stack(
        children: [
          ShaderMask(
            blendMode: BlendMode.dstOut,
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [
                  Colors.grey,
                  Colors.transparent,
                ],
                stops: [0.4, 1],
                tileMode: TileMode.mirror,
              ).createShader(bounds);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.25),
              alignment: Alignment.center,
              child: ListWheelScrollView.useDelegate(
                diameterRatio: 1.3,
                physics: FixedExtentScrollPhysics(),
                onSelectedItemChanged: (_) {
                  Vibration.vibrate(
                      duration: 50,
                      amplitude: settingsModel.vibration.getAmplitude());
                },
                itemExtent: size.height * 0.02,
                squeeze: 0.4,
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, _) {
                    return Container(
                      width: size.width * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          /* BlackCover(
            isCoverVisible: _isCoverVisible,
          ),
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
          ), */
        ],
      ),
    );
  }
}
