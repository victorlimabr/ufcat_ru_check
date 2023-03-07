import 'package:json_annotation/json_annotation.dart';
import 'package:ufcat_ru_check/data/category/category.dart';
import 'package:ufcat_ru_check/data/entity.dart';
import 'package:ufcat_ru_check/data/level/level.dart';
import 'package:ufcat_ru_check/data/meal/meal.dart';
import 'package:ufcat_ru_check/utils/date_extensions.dart';
import 'package:ufcat_ru_check/utils/firestore_utils.dart';

part 'sheet.g.dart';

@JsonSerializable()
@TimestampConverter()
class Sheet extends Entity<Sheet> {
  final String employeeId;
  final DateTime date;
  final Meal meal;
  final Level level;
  final Category category;

  const Sheet({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.employeeId,
    required this.date,
    required this.meal,
    required this.level,
    required this.category,
  });

  factory Sheet.build({
    required String id,
    required String employeeId,
    required DateTime date,
    required Meal meal,
    required Level level,
    required Category category,
  }) {
    final now = DateTime.now();
    return Sheet(
      id: id,
      createdAt: now,
      updatedAt: now,
      date: date.beginningOfDay,
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
      date: date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      employeeId: employeeId,
      meal: meal,
      level: level,
      category: category,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        date,
        employeeId,
        meal,
        level,
        category,
      ];
}

extension SheetFromJson on Map<String, dynamic> {
  Sheet toSheet() => _$SheetFromJson(this);
}
