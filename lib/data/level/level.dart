import 'package:json_annotation/json_annotation.dart';

part 'level.g.dart';

@JsonEnum(alwaysCreate: true)
enum Level {
  @JsonValue(0)
  undergraduate, // Graduação
  @JsonValue(1)
  latoSensu, // Pós -Graduação
  @JsonValue(2)
  strictoSensu; // Mestrado

  static Level fromInt(int value) => $enumDecode(_$LevelEnumMap, value);

  int toInt() => _$LevelEnumMap[this]!;
}
