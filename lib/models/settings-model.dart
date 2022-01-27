import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fidget_tool/data/vibration-options.dart';
import 'package:fidget_tool/services/data-preferences.dart';

class SettingsModel {
  VibrationOptions _vibration;
  bool _hasBulb;

  VibrationOptions get vibration => this._vibration;

  set vibration(VibrationOptions value) {
    this._vibration = value;
    StoredData.setVibrationOption(value);
  }

  bool get hasBulb => this._hasBulb;

  set hasBulb(value) {
    this._hasBulb = value;
    StoredData.setBulbOption(value);
  }

  SettingsModel()
      : this._hasBulb = StoredData.getBulbOption(),
        this._vibration = StoredData.getVibrationOption();
}
