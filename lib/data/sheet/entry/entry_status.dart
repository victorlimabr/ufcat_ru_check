import 'package:json_annotation/json_annotation.dart';

part 'entry_status.g.dart';

@JsonEnum(alwaysCreate: true)
enum EntryStatus {
  @JsonValue(0)
  permitted,
  @JsonValue(1)
  denied;

  static EntryStatus fromInt(int value) => $enumDecode(_$EntryStatusEnumMap, value);

  int toInt() => _$EntryStatusEnumMap[this]!;
}
