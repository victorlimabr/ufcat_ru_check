import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ufcat_ru_check/data/category/category.dart';
import 'package:ufcat_ru_check/data/entity.dart';
import 'package:ufcat_ru_check/data/level/level.dart';
import 'package:ufcat_ru_check/data/meal/meal.dart';
import 'package:ufcat_ru_check/db/auto_id_generator.dart';
import 'package:ufcat_ru_check/db/dao.dart';
import 'package:ufcat_ru_check/utils/firestore_utils.dart';

part 'sheet.g.dart';

@JsonSerializable()
class Sheet extends Entity<Sheet> with Dao<Sheet> {
  final String employeeId;
  final Meal meal;
  final Level level;
  final Category category;

  const Sheet({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.employeeId,
    required this.meal,
    required this.level,
    required this.category,
  });

  factory Sheet.build({
    DateTime? at,
    required String employeeId,
    required Meal meal,
    required Level level,
    required Category category,
  }) {
    final now = at ?? DateTime.now();
    return Sheet(
      id: AutoIdGenerator.autoId(),
      createdAt: now,
      updatedAt: now,
      employeeId: employeeId,
      meal: meal,
      level: level,
      category: category,
    );
  }

  @override
  Map<String, dynamic> toJson() => _$SheetToJson(this);

  @override
  Sheet copyWith({DateTime? createdAt, DateTime? updatedAt}) {
    return Sheet(
      id: id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.createdAt,
      employeeId: employeeId,
      meal: meal,
      level: level,
      category: category,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        employeeId,
        meal,
        level,
        category,
      ];
}

extension SheetFromJson on Map<String, dynamic> {
  Sheet toSheet() => _$SheetFromJson(this);
}
