import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:ufcat_ru_check/data/category/category.dart';
import 'package:ufcat_ru_check/data/setting/income_range_settings.dart';
import 'package:ufcat_ru_check/data/sheet/entry/entry.dart';
import 'package:ufcat_ru_check/data/sheet/sheet.dart';
import 'package:ufcat_ru_check/data/sheet/sheet_repository.dart';
import 'package:ufcat_ru_check/data/student/student.dart';
import 'package:ufcat_ru_check/data/student/student_repository.dart';
import 'package:ufcat_ru_check/domain/use_case.dart';

class CheckOutOfRangeStudentsInput {
  final List<Sheet> sheets;
  final IncomeRangeSettings settings;

  CheckOutOfRangeStudentsInput(this.sheets, this.settings);
}

class CheckOutOfRangeStudentsUseCase
    extends FutureUseCase<CheckOutOfRangeStudentsInput, List<Entry>> {
  final SheetDao _sheetRepository;
  final StudentDao _studentRepository;

  CheckOutOfRangeStudentsUseCase(
      this._sheetRepository, this._studentRepository);

  @override
  Future<List<Entry>> perform(CheckOutOfRangeStudentsInput input) async {
    final students = await _studentRepository.findAll();
    final entriesFuture = input.sheets.map(
      (sheet) async {
        final snap = await _sheetRepository.queryEntries(sheet.id).get();
        final entries = snap.docs.map((e) => e.data());
        return entries.where((entry) {
          final student = students.firstWhereOrNull(
            (student) => student.id == entry.studentId,
          );
          if (student == null) return false;
          return student.declaredIncomes >=
                  sheet.category.min(input.settings) &&
              student.declaredIncomes <= sheet.category.max(input.settings);
        });
      },
    );
    return (await Future.wait(entriesFuture)).expand((e) => e).toList();
  }
}

extension StudentsScope on Iterable<Student> {
  Iterable<Student> get regular => where((student) => student.regular);
}

extension RangeCategory on Category {
  Decimal max(IncomeRangeSettings settings) {
    switch (this) {
      case Category.free:
        return settings.freeLimit;
      case Category.highSubsidized:
        return settings.highLimit;
      case Category.lowSubsidized:
        return settings.lowLimit;
      case Category.full:
        return Decimal.fromInt(1000000);
    }
  }

  Decimal min(IncomeRangeSettings settings) {
    switch (this) {
      case Category.free:
        return Decimal.fromInt(0);
      case Category.highSubsidized:
        return settings.freeLimit;
      case Category.lowSubsidized:
        return settings.highLimit;
      case Category.full:
        return settings.lowLimit;
    }
  }
}
