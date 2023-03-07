import 'package:decimal/decimal.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ufcat_ru_check/data/category/category.dart';
import 'package:ufcat_ru_check/data/entity.dart';
import 'package:ufcat_ru_check/data/level/level.dart';
import 'package:ufcat_ru_check/utils/firestore_utils.dart';

part 'student.g.dart';

@JsonSerializable()
class Student extends Entity<Student> {
  final String name;
  final String document;
  final bool regular;
  final Category category;
  final Decimal declaredIncomes;
  final Level level;

  const Student({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.name,
    required this.document,
    required this.regular,
    required this.category,
    required this.declaredIncomes,
    required this.level,
  });

  factory Student.build({
    required String registerId,
    required String name,
    required String document,
    required bool regular,
    required Category category,
    required Decimal declaredIncomes,
    required Level level,
  }) {
    final now = DateTime.now();
    return Student(
      id: registerId,
      createdAt: now,
      updatedAt: now,
      name: name,
      document: document,
      regular: regular,
      category: category,
      declaredIncomes: declaredIncomes,
      level: level,
    );
  }

  @override
  Map<String, dynamic> toJson() => _$StudentToJson(this);

  @override
  Student copyWith({DateTime? createdAt, DateTime? updatedAt}) {
    return Student(
      id: id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name,
      document: document,
      regular: regular,
      category: category,
      declaredIncomes: declaredIncomes,
      level: level,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        name,
        document,
        regular,
        category,
        declaredIncomes,
        level,
      ];
}

extension StudentFromJson on Map<String, dynamic> {
  Student toStudent() => _$StudentFromJson(this);
}
