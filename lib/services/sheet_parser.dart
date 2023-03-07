import 'dart:typed_data';

import 'package:excel/excel.dart' as excel;
import 'package:intl/intl.dart';
import 'package:ufcat_ru_check/data/category/category.dart';
import 'package:ufcat_ru_check/data/level/level.dart';
import 'package:ufcat_ru_check/data/meal/meal.dart';
import 'package:ufcat_ru_check/data/setting/sheet_settings.dart';
import 'package:ufcat_ru_check/data/sheet/entry/entry.dart';
import 'package:ufcat_ru_check/data/sheet/entry/entry_status.dart';
import 'package:ufcat_ru_check/data/sheet/sheet_repository.dart';

class SheetParser {
  final SheetDao _sheetRepository;

  SheetParser(this._sheetRepository);

  Future<void> call(
    Uint8List bytes, {
    required String employeeId,
    required Meal meal,
    required Level level,
    required Category category,
    required SheetSettings settings,
    DateTime? at,
  }) async {
    final external = excel.Excel.decodeBytes(bytes);
    final table = external.tables.values.first;
    final sheet = _sheetRepository.build(
      date: at ?? DateTime.now(),
      employeeId: employeeId,
      meal: meal,
      level: level,
      category: category,
    );
    final entries = _sheetRepository.parseEntries(
      table,
      sheet.id,
      at: at,
      settings: settings,
    );
    await _sheetRepository.save(sheet);
    await _sheetRepository.addEntries(sheet, entries);
  }
}

extension on SheetDao {
  Iterable<Entry> parseEntries(
    excel.Sheet sheet,
    String sheetId, {
    DateTime? at,
    required SheetSettings settings,
  }) {
    final rows = sheet.rows.sublist(
      settings.firstEntryLine,
      sheet.maxRows - settings.footerLineCount,
    );
    return rows
        .map((row) => _parseEntry(
              sheetId,
              row,
              at: at,
              settings: settings,
            ))
        .toList();
  }

  Entry _parseEntry(
    String sheetId,
    List<excel.Data?> row, {
    DateTime? at,
    required SheetSettings settings,
  }) {
    print(row);
    return buildEntry(
      sheetId: sheetId,
      time: _parseEntryTime(row, at: at, settings: settings),
      studentId: _parseStudentId(row, settings),
      studentName: _parseStudentName(row, settings),
      status: _parseStatus(row, settings),
    );
  }

  DateFormat get timeFormat => DateFormat.Hms('pt');

  DateTime _parseEntryTime(
    List<excel.Data?> row, {
    DateTime? at,
    required SheetSettings settings,
  }) {
    final rowTime =
        timeFormat.parse(row[settings.timeColumn]!.value.toString());
    final time = (at ?? DateTime.now()).copyWith(
      hour: rowTime.hour,
      minute: rowTime.minute,
      second: rowTime.second,
    );
    return time;
  }

  String _parseStudentId(List<excel.Data?> row, SheetSettings settings) =>
      row[settings.registerColumn]!.value.toString();

  String _parseStudentName(List<excel.Data?> row, SheetSettings settings) =>
      row[settings.nameColumn]!.value.toString();

  EntryStatus _parseStatus(List<excel.Data?> row, SheetSettings settings) {
    if (row[settings.statusColumn]!.value.toString() == 'Entrada') {
      return EntryStatus.permitted;
    }
    return EntryStatus.denied;
  }
}
