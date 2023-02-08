import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal.g.dart';

@JsonEnum(alwaysCreate: true)
enum Meal {
  @JsonValue(0)
  lunch,
  @JsonValue(1)
  dinner;

  static Meal fromInt(int value) => $enumDecode(_$MealEnumMap, value);

  int toInt() => _$MealEnumMap[this]!;
}
