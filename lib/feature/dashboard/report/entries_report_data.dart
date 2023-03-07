import 'package:ufcat_ru_check/data/category/category.dart';
import 'package:ufcat_ru_check/data/level/level.dart';
import 'package:ufcat_ru_check/data/meal/meal.dart';
import 'package:ufcat_ru_check/data/sheet/entry/entry.dart';
import 'package:ufcat_ru_check/domain/report/get_meal_costs_use_case.dart';

class EntriesReportData {
  final List<Entry> notFoundStudents;
  final List<Entry> irregularStudents;
  final List<Entry> studentsOutOfRange;
  final MealCosts mealCosts;
  final Map<Level, List<Entry>> entriesByLevel;
  final Map<Category, List<Entry>> entriesByCategory;
  final Map<Meal, List<Entry>> entriesByMeal;

  const EntriesReportData({
    this.notFoundStudents = const [],
    this.irregularStudents = const [],
    this.studentsOutOfRange = const [],
    required this.mealCosts,
    this.entriesByLevel = const {},
    this.entriesByCategory = const {},
    this.entriesByMeal = const {},
  });

  factory EntriesReportData.initial() =>
      EntriesReportData(mealCosts: MealCosts.empty());

  EntriesReportData copyWith({
    List<Entry>? notFoundStudents,
    List<Entry>? irregularStudents,
    List<Entry>? studentsOutOfRange,
    MealCosts? mealCosts,
    Map<Level, List<Entry>>? entriesByLevel,
    Map<Meal, List<Entry>>? entriesByMeal,
    Map<Category, List<Entry>>? entriesByCategory,
  }) {
    return EntriesReportData(
      notFoundStudents: notFoundStudents ?? this.notFoundStudents,
      irregularStudents: irregularStudents ?? this.irregularStudents,
      studentsOutOfRange: studentsOutOfRange ?? this.studentsOutOfRange,
      mealCosts: mealCosts ?? this.mealCosts,
      entriesByLevel: entriesByLevel ?? this.entriesByLevel,
      entriesByMeal: entriesByMeal ?? this.entriesByMeal,
      entriesByCategory: entriesByCategory ?? this.entriesByCategory,
    );
  }
}

extension EntriesMap on Map<dynamic, List<Entry>> {
  bool get hasAny => entries.any((e) => e.value.isNotEmpty);
}
