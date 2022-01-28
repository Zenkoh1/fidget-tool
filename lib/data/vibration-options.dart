import 'package:flutter/foundation.dart';

enum VibrationOptions { Soft, Light, Normal, Heavy }

extension ParseToString on VibrationOptions {
  String toShortString() {
    return describeEnum(this);
  }
}

extension VibrationtoEnum on String {
  VibrationOptions toEnum() {
    return VibrationOptions.values.firstWhere(
      (element) => describeEnum(element) == this,
      orElse: () => null,
    );
  }
}

extension Amplitude on VibrationOptions {
  int getAmplitude() {
    switch (this) {
      case VibrationOptions.Soft:
        return 20;
        break;
      case VibrationOptions.Light:
        return 45;
        break;
      case VibrationOptions.Normal:
        return 70;
        break;
      case VibrationOptions.Heavy:
        return 100;
        break;

      default:
        throw Exception("Invalid vibration option");
    }
  }
}
