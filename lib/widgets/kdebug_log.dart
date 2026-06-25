import 'package:flutter/foundation.dart';
import 'dart:developer';

void l(String message) {
  if (kDebugMode) {
    log(message);
  }
}
