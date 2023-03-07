import 'package:ufcat_ru_check/data/category/category.dart';
import 'package:ufcat_ru_check/data/sheet/entry/entry.dart';
import 'package:ufcat_ru_check/data/sheet/sheet.dart';
import 'package:ufcat_ru_check/data/sheet/sheet_repository.dart';
import 'package:ufcat_ru_check/data/student/student.dart';
import 'package:ufcat_ru_check/domain/use_case.dart';

class GetEntriesByCategoryInput {
  final Set<Student> students;
  final List<Sheet> sheets;

  GetEntriesByCategoryInput(this.students, this.sheets);
}

class GetEntriesByCategory extends FutureUseCase<GetEntriesByCategoryInput,
    Map<Category, List<Entry>>> {
  final SheetDao _sheetRepository;

  GetEntriesByCategory(this._sheetRepository);

  @override
  Future<Map<Category, List<Entry>>> perform(
      GetEntriesByCategoryInput input) async {
    final map = <Category, List<Entry>>{};
    for (var sheet in input.sheets) {
      final snap = await _sheetRepository
          .queryEntries(sheet.id)
          .filterStudents(input.students)
          .get();
      final entries = snap.docs.map((e) => e.data());
      final byCategory = map[sheet.category];
      if (byCategory != null) {
        byCategory.addAll(entries);
      } else {
        map[sheet.category] = entries.toList();
      }
    }
    return map;
  }
}
