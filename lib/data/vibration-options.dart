import 'package:flutter/foundation.dart';

import 'package:vibration/vibration.dart';

enum VibrationOptions { Soft, Light, Normal, Heavy }

extension ParseToString on VibrationOptions {
  String toShortString() {
    return describeEnum(this);
  }
}

extension ParsetoEnum on String {
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
        return 10;
        break;
      case VibrationOptions.Light:
        return 20;
        break;
      case VibrationOptions.Normal:
        return 35;
        break;
      case VibrationOptions.Heavy:
        return 50;
        break;

      default:
        throw Exception("Invalid vibration option");
    }
  }
}
