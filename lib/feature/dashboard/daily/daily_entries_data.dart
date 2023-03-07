import 'package:ufcat_ru_check/data/sheet/entry/entry.dart';
import 'package:ufcat_ru_check/data/sheet/sheet.dart';

class DailyEntriesData {
  final List<SheetEntries> sheets;

  const DailyEntriesData({this.sheets = const []});

  DailyEntriesData copyWith({
    List<SheetEntries>? sheets,
  }) {
    return DailyEntriesData(
      sheets: sheets ?? this.sheets,
    );
  }
}

class SheetEntries {
  final Sheet sheet;
  final List<Entry> entries;

  SheetEntries(this.sheet, this.entries);
}
