import 'package:ufcat_ru_check/data/level/level.dart';
import 'package:ufcat_ru_check/data/sheet/entry/entry.dart';
import 'package:ufcat_ru_check/data/sheet/sheet.dart';
import 'package:ufcat_ru_check/data/sheet/sheet_repository.dart';
import 'package:ufcat_ru_check/data/student/student.dart';
import 'package:ufcat_ru_check/domain/use_case.dart';

class GetEntriesByLevelInput {
  final Set<Student> students;
  final List<Sheet> sheets;

  GetEntriesByLevelInput(this.students, this.sheets);
}

class GetEntriesByLevel
    extends FutureUseCase<GetEntriesByLevelInput, Map<Level, List<Entry>>> {
  final SheetDao _sheetRepository;

  GetEntriesByLevel(this._sheetRepository);

  @override
  Future<Map<Level, List<Entry>>> perform(GetEntriesByLevelInput input) async {
    final map = <Level, List<Entry>>{};
    for (var sheet in input.sheets) {
      final snap = await _sheetRepository
          .queryEntries(sheet.id)
          .filterStudents(input.students)
          .get();
      final entries = snap.docs.map((e) => e.data());
      final byLevel = map[sheet.level];
      if (byLevel != null) {
        byLevel.addAll(entries);
      } else {
        map[sheet.level] = entries.toList();
      }
    }
    return map;
  }
}
