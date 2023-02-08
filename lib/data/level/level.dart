import 'package:json_annotation/json_annotation.dart';

part 'level.g.dart';

@JsonEnum(alwaysCreate: true)
enum Level {
  @JsonValue(0)
  undergraduate,
  @JsonValue(1)
  latoSensu,
  @JsonValue(2)
  strictoSensu;

  static Level fromInt(int value) => $enumDecode(_$LevelEnumMap, value);

  int toInt() => _$LevelEnumMap[this]!;
}
