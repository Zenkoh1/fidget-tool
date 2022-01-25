import 'package:shared_preferences/shared_preferences.dart';

import 'package:fidget_tool/data/vibration-options.dart';

class SettingsPreferences {
  static SharedPreferences _preferences;

  static const _vibrationKey = 'vibration';

  static const _bulbKey = 'bulb';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setVibrationOption(VibrationOptions vibrationOptions) async {
    await _preferences.setString(
        _vibrationKey, vibrationOptions.toShortString());
  }

  static VibrationOptions getVibrationOption() =>
      _preferences.getString(_vibrationKey).toEnum() ?? VibrationOptions.Light;

  static Future setBulbOption(bool hasBulb) async {
    await _preferences.setBool(_bulbKey, hasBulb);
  }

  static bool getBulbOption() => _preferences.getBool(_bulbKey) ?? true;
}
