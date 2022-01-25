import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fidget_tool/models/settings-model.dart';

class BlackCover extends StatelessWidget {
  final bool isCoverVisible;

  const BlackCover({
    Key key,
    @required this.isCoverVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedOpacity(
          opacity: checkVisible(context, isCoverVisible) ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: Container(
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  bool checkVisible(BuildContext context, bool isCoverVisible) {
    if (!context.read<SettingsModel>().hasBulb) {
      return false;
    }

    return isCoverVisible;
  }
}
