import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class DecimalConverter implements JsonConverter<Decimal, String> {
  const DecimalConverter();

  @override
  Decimal fromJson(String value) {
    return Decimal.parse(value);
  }

  @override
  String toJson(Decimal date) => date.toStringAsFixed(2);
}
