import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fidget_tool/data/vibration-options.dart';
import 'package:fidget_tool/services/settings-preferences.dart';

class SettingsModel {
  VibrationOptions _vibration;
  bool _hasBulb;

  VibrationOptions get vibration => this._vibration;

  set vibration(VibrationOptions value) {
    this._vibration = value;
    SettingsPreferences.setVibrationOption(value);
  }

  bool get hasBulb => this._hasBulb;

  set hasBulb(value) {
    this._hasBulb = value;
    SettingsPreferences.setBulbOption(value);
  }

  SettingsModel()
      : this._hasBulb = SettingsPreferences.getBulbOption(),
        this._vibration = SettingsPreferences.getVibrationOption();
}
