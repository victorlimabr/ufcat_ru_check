import 'package:ufcat_ru_check/data/meal/meal.dart';
import 'package:ufcat_ru_check/data/sheet/entry/entry.dart';
import 'package:ufcat_ru_check/data/sheet/sheet.dart';
import 'package:ufcat_ru_check/data/sheet/sheet_repository.dart';
import 'package:ufcat_ru_check/data/student/student.dart';
import 'package:ufcat_ru_check/domain/use_case.dart';

class GetEntriesByMealInput {
  final Set<Student> students;
  final List<Sheet> sheets;

  GetEntriesByMealInput(this.students, this.sheets);
}

class GetEntriesByMeal
    extends FutureUseCase<GetEntriesByMealInput, Map<Meal, List<Entry>>> {
  final SheetDao _sheetRepository;

  GetEntriesByMeal(this._sheetRepository);

  @override
  Future<Map<Meal, List<Entry>>> perform(GetEntriesByMealInput input) async {
    final map = <Meal, List<Entry>>{};
    for (var sheet in input.sheets) {
      final snap = await _sheetRepository
          .queryEntries(sheet.id)
          .filterStudents(input.students)
          .get();
      final entries = snap.docs.map((e) => e.data());
      final byMeal = map[sheet.meal];
      if (byMeal != null) {
        byMeal.addAll(entries);
      } else {
        map[sheet.meal] = entries.toList();
      }
    }
    return map;
  }
}
