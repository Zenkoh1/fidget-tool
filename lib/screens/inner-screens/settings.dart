import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fidget_tool/models/settings-model.dart';

import 'package:fidget_tool/data/vibration-options.dart';

import 'package:fidget_tool/widgets/widgets.dart';

class Settings extends StatefulWidget {
  Settings({
    Key key,
  }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final List<VibrationOptions> vibrationOptions = VibrationOptions.values;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final settingsModel = context.read<SettingsModel>();
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.025),
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
                'Settings',
                style: TextStyle(
                  fontSize: size.height * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SettingsOption(
              label: 'Vibration',
              child: DropdownButton<VibrationOptions>(
                dropdownColor: Colors.blueGrey,
                value: settingsModel.vibration,
                items: vibrationOptions.map(buildMenuItem).toList(),
                onChanged: (value) {
                  setState(() {
                    settingsModel.vibration = value;
                  });
                },
              ),
            ),
            SettingsOption(
              label: 'Light Bulb Active',
              child: Checkbox(
                side: const BorderSide(
                  color: Colors.white,
                ),
                checkColor: Colors.red,
                activeColor: Colors.white,
                onChanged: (bool value) {
                  setState(() {
                    settingsModel.hasBulb = value;
                  });
                },
                value: settingsModel.hasBulb,
              ),
            )
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<VibrationOptions> buildMenuItem(VibrationOptions item) =>
      DropdownMenuItem(
        value: item,
        child: Text(
          item.toShortString(),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
}
