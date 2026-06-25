import 'dart:ui';

import '../constants/colors.dart';

Color pColor(double percentageValue) {
  if (percentageValue > 70) {
    return CustomColor.primaryColor;
  } else if (percentageValue < 40) {
    return CustomColor.colorRedAccent;
  } else {
    return CustomColor.barYellow;
  }
}