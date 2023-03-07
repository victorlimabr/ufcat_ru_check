import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ufcat_ru_check/data/entity.dart';
import 'package:ufcat_ru_check/data/setting/income_range_settings.dart';
import 'package:ufcat_ru_check/data/setting/report_settings.dart';
import 'package:ufcat_ru_check/data/setting/sheet_settings.dart';
import 'package:ufcat_ru_check/data/setting/subsidy_settings.dart';
import 'package:ufcat_ru_check/data/auto_id_generator.dart';
import 'package:ufcat_ru_check/utils/firestore_utils.dart';

part 'app_settings.g.dart';

@JsonSerializable()
class AppSettings extends Entity<AppSettings> {
  final IncomeRangeSettings incomeSettings;
  final ReportSettings reportSettings;
  final SheetSettings sheetSettings;
  final SubsidySettings subsidySettings;

  const AppSettings({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.incomeSettings,
    required this.reportSettings,
    required this.sheetSettings,
    required this.subsidySettings,
  });

  factory AppSettings.build({
    required IncomeRangeSettings incomeSettings,
    required ReportSettings reportSettings,
    required SheetSettings sheetSettings,
    required SubsidySettings subsidySettings,
  }) {
    final now = DateTime.now();
    return AppSettings(
      id: AutoIdGenerator.autoId(),
      createdAt: now,
      updatedAt: now,
      incomeSettings: incomeSettings,
      reportSettings: reportSettings,
      sheetSettings: sheetSettings,
      subsidySettings: subsidySettings,
    );
  }

  factory AppSettings.empty() => AppSettings.build(
        incomeSettings: IncomeRangeSettings.empty(),
        reportSettings: ReportSettings.empty(),
        sheetSettings: SheetSettings.empty(),
        subsidySettings: SubsidySettings.empty(),
      );

  @override
  AppSettings copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    IncomeRangeSettings? incomeSettings,
    ReportSettings? reportSettings,
    SheetSettings? sheetSettings,
    SubsidySettings? subsidySettings,
  }) {
    return AppSettings(
      id: id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      incomeSettings: incomeSettings ?? this.incomeSettings,
      reportSettings: reportSettings ?? this.reportSettings,
      sheetSettings: sheetSettings ?? this.sheetSettings,
      subsidySettings: subsidySettings ?? this.subsidySettings,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        incomeSettings,
        reportSettings,
        sheetSettings,
        subsidySettings,
      ];

  @override
  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);
}

extension AppSettingsSerializer on Map<String, dynamic> {
  AppSettings toAppSettings() => _$AppSettingsFromJson(this);
}
