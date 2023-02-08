extension DurationIntExtensions on int {
  Duration get days => Duration(days: this);
}

extension DateTimeDurationExtension on Duration {
  DateTime get ago => DateTime.now().subtract(this);
}