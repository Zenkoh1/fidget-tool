import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';

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

  static final DateFormat dateFormat = DateFormat("ddMMyyyy");

  static Future setTimeTracker(int time, DateTime dateTime) async {
    await _preferences.setInt(dateFormat.format(dateTime), time);
  }

  static int getTimeTracker(DateTime dateTime) {
    return _preferences.getInt(dateFormat.format(dateTime)) ?? 0;
  }

  static Future setEmotion(DateTime dateTime, Emotions emotions) async {
    await _preferences.setString(
        '${dateFormat.format(dateTime)} emotion', emotions.toShortString());
  }

  static Emotions getEmotion(DateTime dateTime) {
    return EmotionstoEnum(
            _preferences.getString('${dateFormat.format(dateTime)} emotion'))
        .toEnum();
  }
}
