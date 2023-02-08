import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonEnum(alwaysCreate: true)
enum Category {
  @JsonValue(0)
  free,
  @JsonValue(1)
  highSubsidized,
  @JsonValue(2)
  lowSubsidized,
  @JsonValue(3)
  full;

  static Category fromInt(int value) => $enumDecode(_$CategoryEnumMap, value);

  int toInt() => _$CategoryEnumMap[this]!;
}
