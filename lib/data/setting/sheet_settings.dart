import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ufcat_ru_check/data/entity.dart';
import 'package:ufcat_ru_check/data/auto_id_generator.dart';
import 'package:ufcat_ru_check/utils/firestore_utils.dart';

part 'sheet_settings.g.dart';

@JsonSerializable()
class SheetSettings extends Entity<SheetSettings> {
  final int registerColumn;
  final int nameColumn;
  final int statusColumn;
  final int timeColumn;
  final int firstEntryLine;
  final int footerLineCount;

  const SheetSettings({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    this.registerColumn = 0,
    this.nameColumn = 1,
    this.timeColumn = 2,
    this.statusColumn = 4,
    this.firstEntryLine = 3,
    this.footerLineCount = 1,
  });

  factory SheetSettings.build({
    int registerColumn = 0,
    int nameColumn = 1,
    int timeColumn = 2,
    int statusColumn = 4,
    int firstEntryLine = 3,
    int footerLineCount = 1,
  }) {
    final now = DateTime.now();
    return SheetSettings(
      id: AutoIdGenerator.autoId(),
      createdAt: now,
      updatedAt: now,
      registerColumn: registerColumn,
      nameColumn: nameColumn,
      timeColumn: timeColumn,
      statusColumn: statusColumn,
      firstEntryLine: firstEntryLine,
      footerLineCount: footerLineCount,
    );
  }

  factory SheetSettings.empty() => SheetSettings.build();

  @override
  SheetSettings copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    int? registerColumn,
    int? nameColumn,
    int? timeColumn,
    int? statusColumn,
    int? firstEntryLine,
    int? footerLineCount,
  }) {
    return SheetSettings(
      id: id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      registerColumn: registerColumn ?? this.registerColumn,
      nameColumn: nameColumn ?? this.nameColumn,
      timeColumn: timeColumn ?? this.timeColumn,
      statusColumn: statusColumn ?? this.statusColumn,
      firstEntryLine: firstEntryLine ?? this.firstEntryLine,
      footerLineCount: footerLineCount ?? this.footerLineCount,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        registerColumn,
        nameColumn,
        timeColumn,
        statusColumn,
        firstEntryLine,
        footerLineCount,
      ];

  @override
  Map<String, dynamic> toJson() => _$SheetSettingsToJson(this);

  factory SheetSettings.fromJson(Map<String, dynamic> json) =>
      _$SheetSettingsFromJson(json);
}
