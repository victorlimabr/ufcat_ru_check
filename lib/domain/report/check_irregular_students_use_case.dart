import 'package:ufcat_ru_check/data/sheet/entry/entry.dart';
import 'package:ufcat_ru_check/data/sheet/sheet.dart';
import 'package:ufcat_ru_check/data/sheet/sheet_repository.dart';
import 'package:ufcat_ru_check/data/student/student.dart';
import 'package:ufcat_ru_check/data/student/student_repository.dart';
import 'package:ufcat_ru_check/domain/use_case.dart';

class CheckIrregularStudentsUseCase
    extends FutureUseCase<List<Sheet>, List<Entry>> {
  final SheetDao _sheetRepository;
  final StudentDao _studentRepository;

  CheckIrregularStudentsUseCase(this._sheetRepository, this._studentRepository);

  @override
  Future<List<Entry>> perform(List<Sheet> input) async {
    final entriesFuture = input.map(
      (sheet) => _sheetRepository.queryEntries(sheet.id).get(),
    );
    final snaps = await Future.wait(entriesFuture);
    final entries = snaps.expand((snap) => snap.docs.map((e) => e.data()));
    final students = await _studentRepository.findAll();
    final studentIds = students.regular.map((student) => student.id);
    return entries
        .where((entry) => !studentIds.contains(entry.studentId))
        .toList();
  }
}

extension StudentsScope on Iterable<Student> {
  Iterable<Student> get regular => where((student) => student.regular);
}

