import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ufcat_ru_check/data/entity.dart';
import 'package:ufcat_ru_check/data/auto_id_generator.dart';
import 'package:ufcat_ru_check/utils/firestore_utils.dart';

part 'income_range_settings.g.dart';

@JsonSerializable()
class IncomeRangeSettings extends Entity<IncomeRangeSettings> {
  final Decimal freeLimit; // ex: no máximo R$ 1000
  final Decimal highLimit; // R$ 2000
  final Decimal lowLimit; // R$ 2500

  const IncomeRangeSettings({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.freeLimit,
    required this.lowLimit,
    required this.highLimit,
  });

  factory IncomeRangeSettings.build({
    required Decimal freeLimit,
    required Decimal lowLimit,
    required Decimal highLimit,
  }) {
    final now = DateTime.now();
    return IncomeRangeSettings(
      id: AutoIdGenerator.autoId(),
      createdAt: now,
      updatedAt: now,
      freeLimit: freeLimit,
      lowLimit: lowLimit,
      highLimit: highLimit,
    );
  }

  factory IncomeRangeSettings.empty() => IncomeRangeSettings.build(
        freeLimit: Decimal.fromInt(1000),
        lowLimit: Decimal.fromInt(1500),
        highLimit: Decimal.fromInt(2000),
      );

  @override
  IncomeRangeSettings copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    Decimal? freeLimit,
    Decimal? lowLimit,
    Decimal? highLimit,
  }) {
    return IncomeRangeSettings(
      id: id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      freeLimit: freeLimit ?? this.freeLimit,
      lowLimit: lowLimit ?? this.lowLimit,
      highLimit: highLimit ?? this.highLimit,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        freeLimit,
        lowLimit,
        highLimit,
      ];

  @override
  Map<String, dynamic> toJson() => _$IncomeRangeSettingsToJson(this);

  factory IncomeRangeSettings.fromJson(Map<String, dynamic> json) =>
      _$IncomeRangeSettingsFromJson(json);
}
