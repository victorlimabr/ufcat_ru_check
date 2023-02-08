import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  @override
  DateTime fromJson(dynamic timestamp) {
    return (timestamp as Timestamp).toDate();
  }

  @override
  dynamic toJson(DateTime date) => Timestamp.fromDate(date);
}
