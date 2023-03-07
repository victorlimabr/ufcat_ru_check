import 'package:flutter/material.dart';
import 'package:ufcat_ru_check/data/category/category.dart';
import 'package:ufcat_ru_check/data/level/level.dart';
import 'package:ufcat_ru_check/data/meal/meal.dart';
import 'package:ufcat_ru_check/data/student/student.dart';
import 'package:ufcat_ru_check/utils/date_extensions.dart';
import 'package:ufcat_ru_check/utils/duration_extensions.dart';

class EntriesFilterData {
  final DateTimeRange dateRange;
  final Set<Level> levels;
  final Set<Meal> meals;
  final Set<Category> categories;
  final bool applied;
  final List<Student> allStudents;
  final Set<Student> students;

  const EntriesFilterData({
    required this.dateRange,
    this.levels = const {},
    this.meals = const {},
    this.categories = const {},
    this.applied = false,
    this.allStudents = const [],
    this.students = const {},
  });

  factory EntriesFilterData.initial() {
    return EntriesFilterData(
      dateRange: DateTimeRange(
        start: 30.days.ago.beginningOfDay,
        end: DateTime.now().beginningOfDay,
      ),
      levels: Level.values.toSet(),
      meals: Meal.values.toSet(),
      categories: Category.values.toSet(),
    );
  }

  EntriesFilterData copyWith({
    DateTimeRange? dateRange,
    Set<Level>? levels,
    Set<Meal>? meals,
    Set<Category>? categories,
    bool? applied,
    List<Student>? allStudents,
    Set<Student>? students,
  }) {
    return EntriesFilterData(
      dateRange: dateRange ?? this.dateRange,
      levels: levels ?? this.levels,
      meals: meals ?? this.meals,
      categories: categories ?? this.categories,
      applied: applied ?? this.applied,
      allStudents: allStudents ?? this.allStudents,
      students: students ?? this.students,
    );
  }

  List<Student> filterStudents(String search) {
    if (search.isEmpty) return [];
    return allStudents
        .where((s) =>
            s.name.toLowerCase().contains(search.toLowerCase()) ||
            s.id.contains(search) ||
            s.document.contains(search))
        .toList();
  }
}
