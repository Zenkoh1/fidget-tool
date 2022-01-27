import 'package:shared_preferences/shared_preferences.dart';

import 'package:fidget_tool/data/vibration-options.dart';
import 'package:fidget_tool/data/emotions.dart';

class StoredData {
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
      VibrationtoEnum(_preferences.getString(_vibrationKey)).toEnum() ??
      VibrationOptions.Light;

  static Future setBulbOption(bool hasBulb) async {
    await _preferences.setBool(_bulbKey, hasBulb);
  }

  static bool getBulbOption() => _preferences.getBool(_bulbKey) ?? true;

  static Future setTimeTrackerOption(int time, DateTime dateTime) async {
    var key = dateTime.day + dateTime.month + dateTime.year;
    await _preferences.setInt(key.toString(), time);
  }

  static int getTimeTrackerOption(DateTime dateTime) {
    var key = dateTime.day + dateTime.month + dateTime.year;
    return _preferences.getInt(key.toString()) ?? 0;
  }

  static Future setEmotion(DateTime dateTime, Emotions emotions) async {
    var key = dateTime.day + dateTime.month + dateTime.year;
    await _preferences.setString('{$key emotion}', emotions.toShortString());
  }

  static Emotions getEmotion(DateTime dateTime) {
    var key = dateTime.day + dateTime.month + dateTime.year;
    return EmotionstoEnum(_preferences.getString('{$key emotion}')).toEnum();
  }
}
