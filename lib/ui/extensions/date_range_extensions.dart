import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeRangeExtension on DateTimeRange {
  String format(DateFormat format) {
    return '${format.format(start)} a ${format.format(end)}';
  }
}
