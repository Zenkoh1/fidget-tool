import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum Emotions { Happy, Neutral, Upset }

extension ParseToString on Emotions {
  String toShortString() {
    return describeEnum(this);
  }
}

extension EmotionstoEnum on String {
  Emotions toEnum() {
    return Emotions.values.firstWhere(
      (element) => describeEnum(element) == this,
      orElse: () => null,
    );
  }
}

extension GraphColour on Emotions {
  Color getColour() {
    switch (this) {
      case Emotions.Happy:
        return Colors.amber[400];
        break;

      case Emotions.Neutral:
        return Colors.white;
        break;

      case Emotions.Upset:
        return Colors.blue;
        break;

      default:
        return Colors.grey.withOpacity(0.5);
    }
  }

  Color getActiveColour() {
    switch (this) {
      case Emotions.Happy:
        return Colors.amber[700];
        break;

      case Emotions.Neutral:
        return Colors.grey[200];
        break;

      case Emotions.Upset:
        return Colors.blue[800];
        break;
      default:
        return Colors.grey.withOpacity(0.5);
    }
  }
}
