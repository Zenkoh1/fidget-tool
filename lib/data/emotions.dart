import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum Emotions { Happy, Neutral, Upset, Angry }

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
      case Emotions.Angry:
        return Colors.red[300];
        break;

      case Emotions.Happy:
        return Colors.amber[300];
        break;

      case Emotions.Neutral:
        return Colors.white;
        break;

      case Emotions.Upset:
        return Colors.blue[300];
        break;
      default:
        return Colors.white;
    }
  }

  Color getActiveColour() {
    switch (this) {
      case Emotions.Angry:
        return Colors.red;
        break;

      case Emotions.Happy:
        return Colors.amber;
        break;

      case Emotions.Neutral:
        return Colors.grey[200];
        break;

      case Emotions.Upset:
        return Colors.blue;
        break;
      default:
        return Colors.white;
    }
  }
}
