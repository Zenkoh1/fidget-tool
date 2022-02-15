import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:fidget_tool/models/settings-model.dart';

import 'package:fidget_tool/widgets/widgets.dart';

import 'package:fidget_tool/data/vibration-options.dart';

class FidgetButton extends StatefulWidget {
  const FidgetButton({Key key}) : super(key: key);

  @override
  _FidgetButtonState createState() => _FidgetButtonState();
}

class _FidgetButtonState extends State<FidgetButton> {
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
          Center(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(size.width * 0.05),
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(size.width * 0.1),
              ),
              width: size.width * 0.8,
              height: size.width * 0.8,
              child: GridView.count(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                children: [
                  for (int i = 0; i < 9; i++)
                    Center(
                      child: Button3d(
                        style: Button3dStyle(
                          topColor: Colors.red,
                          backColor: Colors.red[900],
                          borderRadius:
                              BorderRadius.circular(size.width * 0.16),
                        ),
                        onPressed: () {
                          print('test');
                          Vibration.vibrate(
                              duration: 50,
                              amplitude:
                                  settingsModel.vibration.getAmplitude());
                        },
                        child: Container(),
                        width: size.width * 0.16,
                        height: size.width * 0.16,
                      ),
                    ),
                ],
              ),
            ),
          ),
          /*   BlackCover(
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
