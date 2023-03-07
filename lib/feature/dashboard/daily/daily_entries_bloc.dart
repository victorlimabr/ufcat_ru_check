import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufcat_ru_check/data/sheet/sheet_repository.dart';
import 'package:ufcat_ru_check/feature/dashboard/daily/daily_entries_data.dart';
import 'package:ufcat_ru_check/feature/dashboard/entries_filter/entries_filter_data.dart';

class DailyEntriesBloc extends Cubit<DailyEntriesData> {
  final SheetDao sheetRepository;

  DailyEntriesBloc(this.sheetRepository) : super(const DailyEntriesData());

  void applyFilter(EntriesFilterData data) async {
    final snaps = await sheetRepository.query
        .filterDateRange(data.dateRange)
        .filterMeal(data.meals)
        .filterLevel(data.levels)
        .filterCategory(data.categories)
        .get();

    final futureEntries = snaps.docs.map((sheet) async {
      final entries = await sheetRepository
          .queryEntries(sheet.id)
          .filterStudents(data.students)
          .get();
      return SheetEntries(
        sheet.data(),
        entries.docs.map((entry) => entry.data()).toList(),
      );
    });
    emit(state.copyWith(sheets: await Future.wait(futureEntries)));
  }
}
