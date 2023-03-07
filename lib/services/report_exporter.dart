import 'package:excel/excel.dart' as excel;
import 'package:intl/intl.dart';
import 'package:ufcat_ru_check/feature/dashboard/entries_filter/entries_filter_data.dart';
import 'package:ufcat_ru_check/feature/dashboard/report/entries_report_data.dart';
import 'package:ufcat_ru_check/ui/extensions/category_extensions.dart';
import 'package:ufcat_ru_check/ui/extensions/date_range_extensions.dart';
import 'package:ufcat_ru_check/ui/extensions/level_extensions.dart';
import 'package:ufcat_ru_check/ui/extensions/meal_extensions.dart';

class ReportExporter {
  excel.Excel call(
    EntriesFilterData filter,
    EntriesReportData report,
  ) {
    final ex = excel.Excel.createExcel();
    final sheet = ex['Relatório'];
    ex.setDefaultSheet('Relatório');

    sheet.appendRow(['Relatórios de entradas do Restaurante Universitário']);
    final title = sheet.cell(excel.CellIndex.indexByString('A1'));
    title.cellStyle = excel.CellStyle(fontSize: 16, bold: true);

    sheet.appendRow(['Período:', filter.dateRange.format(DateFormat.yMd())]);
    final subtitle = sheet.cell(excel.CellIndex.indexByString('A2'));
    subtitle.cellStyle = excel.CellStyle(fontSize: 14, bold: false);

    sheet.appendRow(['']);
    sheet.appendRow(['Estudantes não encontrados na base']);
    final section1 = sheet.cell(excel.CellIndex.indexByString('A4'));
    section1.cellStyle = excel.CellStyle(fontSize: 14, bold: true);

    sheet.appendRow(['Matrícula', 'Nome']);
    for (var entry in report.notFoundStudents) {
      sheet.appendRow([entry.studentId, entry.studentName]);
    }

    sheet.appendRow(['']);
    sheet.appendRow(['Estudantes não matriculados no semestre']);
    final section2 = sheet.cell(excel.CellIndex.indexByString(
        'A${report.notFoundStudents.length + 7}'));
    section2.cellStyle = excel.CellStyle(fontSize: 14, bold: true);

    sheet.appendRow(['Matrícula', 'Nome']);
    for (var entry in report.irregularStudents) {
      sheet.appendRow([entry.studentId, entry.studentName]);
    }

    sheet.appendRow(['']);
    sheet.appendRow(['Estudantes fora da faixa de renda']);
    final section3 = sheet.cell(excel.CellIndex.indexByString(
        'A${report.notFoundStudents.length + report.irregularStudents.length + 10}'));
    section3.cellStyle = excel.CellStyle(fontSize: 14, bold: true);

    sheet.appendRow(['Matrícula', 'Nome']);
    for (var entry in report.studentsOutOfRange) {
      sheet.appendRow([entry.studentId, entry.studentName]);
    }

    sheet.appendRow(['']);
    sheet.appendRow(['Quantidade de refeições']);
    final section4 = sheet.cell(excel.CellIndex.indexByString(
        'A${report.notFoundStudents.length + report.irregularStudents.length + report.studentsOutOfRange.length + 13}'));
    section4.cellStyle = excel.CellStyle(fontSize: 14, bold: true);

    sheet.appendRow(['Por subsídio: ']);
    report.entriesByCategory.forEach((key, value) {
      sheet.appendRow([key.label, value.length]);
    });
    sheet.appendRow(['Por nível do curso: ']);
    report.entriesByLevel.forEach((key, value) {
      sheet.appendRow([key.label, value.length]);
    });
    sheet.appendRow(['Por refeição: ']);
    report.entriesByMeal.forEach((key, value) {
      sheet.appendRow([key.label, value.length]);
    });

    sheet.appendRow(['']);
    sheet.appendRow(['Valor das refeições']);
    final section5 = sheet.cell(excel.CellIndex.indexByString(
        'A${report.notFoundStudents.length + report.irregularStudents.length + report.studentsOutOfRange.length + report.entriesByCategory.length + report.entriesByLevel.length + report.entriesByMeal.length + 18}'));
    section5.cellStyle = excel.CellStyle(fontSize: 14, bold: true);
    sheet.appendRow([
      'Valor subsidiado:',
      'R\$ ${report.mealCosts.subsidized.toStringAsFixed(2)}',
    ]);
    sheet.appendRow([
      'Valor pago:',
      'R\$ ${report.mealCosts.paid.toStringAsFixed(2)}',
    ]);
    sheet.appendRow([
      'Valor total:',
      'R\$ ${report.mealCosts.total.toStringAsFixed(2)}',
    ]);
    return ex;
  }
}
