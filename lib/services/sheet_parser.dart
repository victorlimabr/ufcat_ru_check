import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:ufcat_ru_check/data/category/category.dart';
import 'package:ufcat_ru_check/data/level/level.dart';
import 'package:ufcat_ru_check/data/meal/meal.dart';
import 'package:ufcat_ru_check/data/sheet/entry/entry.dart';
import 'package:ufcat_ru_check/data/sheet/entry/entry_dao.dart';
import 'package:ufcat_ru_check/data/sheet/entry/entry_status.dart';
import 'package:ufcat_ru_check/data/sheet/sheet.dart' as entity;
import 'package:ufcat_ru_check/data/sheet/sheet_dao.dart';

class SheetParser {
  final String employeeId;
  final Meal meal;
  final Level level;
  final Category category;
  final DateTime? at;

  const SheetParser(
    this.employeeId,
    this.meal,
    this.level,
    this.category, {
    this.at,
  });

  Future<void> call(Uint8List bytes) async {
    final excel = Excel.decodeBytes(bytes);
    final table = excel.tables.values.first;
    final sheet = entity.Sheet.build(
      at: at ?? DateTime.now(),
      employeeId: employeeId,
      meal: meal,
      level: level,
      category: category,
    );
    final timeFormat = DateFormat.Hms('pt');
    final entries = table.rows.mapIndexed((index, row) {
      if (index < 4 || index == table.maxRows - 1) return null;
      final time = timeFormat.parse(row[2]!.value.toString());
      return Entry.build(
        at: (at ?? DateTime.now()).copyWith(
          hour: time.hour,
          minute: time.minute,
          second: time.second,
        ),
        sheetId: sheet.id,
        studentId: row[0]!.value.toString(),
        studentName: row[1]!.value.toString(),
        status: row[4]!.value.toString() == 'Entrada'
            ? EntryStatus.permitted
            : EntryStatus.denied,
      );
    }).whereNotNull().toList();
    await sheet.save();
    await sheet.entries.addEntries(entries);
  }

  String _parseRegisterId(dynamic value) {
    if (value is int) return value.toString();
    if (value is SharedString) return value.toString();
    return value as String;
  }
}
