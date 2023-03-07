import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufcat_ru_check/data/category/category.dart';
import 'package:ufcat_ru_check/data/level/level.dart';
import 'package:ufcat_ru_check/data/meal/meal.dart';
import 'package:ufcat_ru_check/data/student/student.dart';
import 'package:ufcat_ru_check/data/student/student_repository.dart';
import 'package:ufcat_ru_check/feature/dashboard/entries_filter/entries_filter_data.dart';

class EntriesFilterBloc extends Cubit<EntriesFilterData> {
  final StudentDao _studentRepository;

  EntriesFilterBloc(this._studentRepository)
      : super(EntriesFilterData.initial());

  void loadStudents() async {
    final students = await _studentRepository.findAll();
    emit(state.copyWith(allStudents: students));
  }

  void changeDateRange(DateTimeRange range) => emit(
        state.copyWith(dateRange: range, applied: false),
      );

  void toggleLevel(Level level) {
    late final Set<Level> levels;
    if (state.levels.contains(level)) {
      levels = state.levels.where((l) => l != level).toSet();
    } else {
      levels = {...state.levels, level};
    }
    emit(state.copyWith(levels: levels, applied: false));
  }

  void toggleCategory(Category category) {
    late final Set<Category> categories;
    if (state.categories.contains(category)) {
      categories = state.categories.where((c) => c != category).toSet();
    } else {
      categories = {...state.categories, category};
    }
    emit(state.copyWith(categories: categories, applied: false));
  }

  void toggleMeal(Meal meal) {
    late final Set<Meal> meals;
    if (state.meals.contains(meal)) {
      meals = state.meals.where((m) => m != meal).toSet();
    } else {
      meals = {...state.meals, meal};
    }
    emit(state.copyWith(meals: meals, applied: false));
  }

  void apply() {
    emit(state.copyWith(applied: true));
  }

  void addStudent(Student student) {
    emit(state.copyWith(
      students: {...state.students, student},
      applied: false,
    ));
  }

  void removeStudent(Student student) {
    emit(state.copyWith(
      students: state.students.where((s) => s != s).toSet(),
      applied: false,
    ));
  }
}
