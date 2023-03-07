import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ufcat_ru_check/data/entity.dart';
import 'package:ufcat_ru_check/data/auto_id_generator.dart';
import 'package:ufcat_ru_check/utils/firestore_utils.dart';

part 'report_settings.g.dart';

@JsonSerializable()
class ReportSettings extends Entity<ReportSettings> {
  final int studentUpdateTimeoutInDays;
  final bool notFoundAlert;
  final bool irregularAlert;
  final bool outOfRangeAlert;

  const ReportSettings({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    this.studentUpdateTimeoutInDays = 180,
    this.notFoundAlert = true,
    this.irregularAlert = true,
    this.outOfRangeAlert = true,
  });

  factory ReportSettings.build({
    int studentUpdateTimeoutInDays = 180,
    bool notFoundAlert = true,
    bool irregularAlert = true,
    bool outOfRangeAlert = true,
  }) {
    final now = DateTime.now();
    return ReportSettings(
      id: AutoIdGenerator.autoId(),
      createdAt: now,
      updatedAt: now,
      studentUpdateTimeoutInDays: studentUpdateTimeoutInDays,
      notFoundAlert: notFoundAlert,
      irregularAlert: irregularAlert,
      outOfRangeAlert: outOfRangeAlert,
    );
  }

  factory ReportSettings.empty() => ReportSettings.build();

  @override
  ReportSettings copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    int? studentUpdateTimeoutInDays,
    bool? notFoundAlert,
    bool? irregularAlert,
    bool? outOfRangeAlert,
  }) {
    return ReportSettings(
      id: id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      studentUpdateTimeoutInDays: studentUpdateTimeoutInDays ?? this.studentUpdateTimeoutInDays,
      notFoundAlert: notFoundAlert ?? this.notFoundAlert,
      irregularAlert: irregularAlert ?? this.irregularAlert,
      outOfRangeAlert: outOfRangeAlert ?? this.outOfRangeAlert,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        studentUpdateTimeoutInDays,
        notFoundAlert,
        irregularAlert,
        outOfRangeAlert,
      ];

  @override
  Map<String, dynamic> toJson() => _$ReportSettingsToJson(this);

  factory ReportSettings.fromJson(Map<String, dynamic> json) =>
      _$ReportSettingsFromJson(json);
}
