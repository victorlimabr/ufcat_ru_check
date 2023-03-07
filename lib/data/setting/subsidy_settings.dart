import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ufcat_ru_check/data/entity.dart';
import 'package:ufcat_ru_check/data/auto_id_generator.dart';
import 'package:ufcat_ru_check/utils/firestore_utils.dart';

part 'subsidy_settings.g.dart';

@JsonSerializable()
class SubsidySettings extends Entity<SubsidySettings> {
  final Decimal fullCost; // Refeição completa
  final Decimal lowSubsidy; // 6,40
  final Decimal highSubsidy; // 4,00

  const SubsidySettings({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.fullCost,
    required this.lowSubsidy,
    required this.highSubsidy,
  });

  factory SubsidySettings.build({
    required Decimal fullCost,
    required Decimal lowSubsidy,
    required Decimal highSubsidy,
  }) {
    final now = DateTime.now();
    return SubsidySettings(
      id: AutoIdGenerator.autoId(),
      createdAt: now,
      updatedAt: now,
      fullCost: fullCost,
      lowSubsidy: lowSubsidy,
      highSubsidy: highSubsidy,
    );
  }

  factory SubsidySettings.empty() => SubsidySettings.build(
        fullCost: Decimal.parse('16.27'),
        lowSubsidy: Decimal.parse('6.40'),
        highSubsidy: Decimal.fromInt(4),
      );

  @override
  SubsidySettings copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    Decimal? fullCost,
    Decimal? lowSubsidy,
    Decimal? highSubsidy,
  }) {
    return SubsidySettings(
      id: id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fullCost: fullCost ?? this.fullCost,
      lowSubsidy: lowSubsidy ?? this.lowSubsidy,
      highSubsidy: highSubsidy ?? this.highSubsidy,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        fullCost,
        lowSubsidy,
        highSubsidy,
      ];

  @override
  Map<String, dynamic> toJson() => _$SubsidySettingsToJson(this);

  factory SubsidySettings.fromJson(Map<String, dynamic> json) =>
      _$SubsidySettingsFromJson(json);
}
