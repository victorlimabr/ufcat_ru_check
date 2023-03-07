import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufcat_ru_check/data/category/category.dart';
import 'package:ufcat_ru_check/data/level/level.dart';
import 'package:ufcat_ru_check/data/meal/meal.dart';
import 'package:ufcat_ru_check/data/result.dart';
import 'package:ufcat_ru_check/data/setting/app_settings.dart';
import 'package:ufcat_ru_check/data/sheet/entry/entry.dart';
import 'package:ufcat_ru_check/data/sheet/sheet_repository.dart';
import 'package:ufcat_ru_check/domain/report/check_invalid_students_use_case.dart';
import 'package:ufcat_ru_check/domain/report/check_irregular_students_use_case.dart';
import 'package:ufcat_ru_check/domain/report/check_out_of_range_students_use_case.dart';
import 'package:ufcat_ru_check/domain/report/get_entries_by_category.dart';
import 'package:ufcat_ru_check/domain/report/get_entries_by_level.dart';
import 'package:ufcat_ru_check/domain/report/get_entries_by_meal.dart';
import 'package:ufcat_ru_check/domain/report/get_meal_costs_use_case.dart';
import 'package:ufcat_ru_check/feature/dashboard/entries_filter/entries_filter_data.dart';
import 'package:ufcat_ru_check/feature/dashboard/report/entries_report_data.dart';
import 'package:ufcat_ru_check/infra/db/dao.dart';

class EntriesReportBLoC extends Cubit<EntriesReportData> {
  final CheckInvalidStudentsUseCase _invalidUseCase;
  final CheckIrregularStudentsUseCase _irregularUseCase;
  final CheckOutOfRangeStudentsUseCase _outOfRangeUseCase;
  final GetMealCostsUseCase _mealCostsUseCase;
  final GetEntriesByCategory _entriesByCategory;
  final GetEntriesByLevel _entriesByLevel;
  final GetEntriesByMeal _entriesByMeal;
  final SheetDao _sheetRepository;

  EntriesReportBLoC(
    this._invalidUseCase,
    this._irregularUseCase,
    this._outOfRangeUseCase,
    this._mealCostsUseCase,
    this._sheetRepository,
    this._entriesByCategory,
    this._entriesByLevel,
    this._entriesByMeal,
  ) : super(EntriesReportData.initial());

  void applyFilter(EntriesFilterData data, AppSettings settings) async {
    final sheets = await _sheetRepository.query
        .filterDateRange(data.dateRange)
        .filterMeal(data.meals)
        .filterLevel(data.levels)
        .filterCategory(data.categories)
        .entities;

    final invalid = await _invalidUseCase(sheets);
    if (invalid is ResultSuccess<List<Entry>>) {
      emit(state.copyWith(notFoundStudents: invalid.data));
    }
    final irregular = await _irregularUseCase(sheets);
    if (irregular is ResultSuccess<List<Entry>>) {
      emit(state.copyWith(irregularStudents: irregular.data));
    }
    final outOfRange = await _outOfRangeUseCase(
      CheckOutOfRangeStudentsInput(sheets, settings.incomeSettings),
    );
    if (outOfRange is ResultSuccess<List<Entry>>) {
      emit(state.copyWith(studentsOutOfRange: outOfRange.data));
    }
    final cost = await _mealCostsUseCase(
      GetMealCostsInput(data.students, sheets, settings.subsidySettings),
    );
    if (cost is ResultSuccess<MealCosts>) {
      emit(state.copyWith(mealCosts: cost.data));
    }
    final entriesByCategory = await _entriesByCategory(
      GetEntriesByCategoryInput(data.students, sheets),
    );
    if (entriesByCategory is ResultSuccess<Map<Category, List<Entry>>>) {
      emit(state.copyWith(entriesByCategory: entriesByCategory.data));
    }
    final entriesByLevel = await _entriesByLevel(
      GetEntriesByLevelInput(data.students, sheets),
    );
    if (entriesByLevel is ResultSuccess<Map<Level, List<Entry>>>) {
      emit(state.copyWith(entriesByLevel: entriesByLevel.data));
    }
    final entriesByMeal = await _entriesByMeal(
      GetEntriesByMealInput(data.students, sheets),
    );
    if (entriesByMeal is ResultSuccess<Map<Meal, List<Entry>>>) {
      emit(state.copyWith(entriesByMeal: entriesByMeal.data));
    }
  }
}
