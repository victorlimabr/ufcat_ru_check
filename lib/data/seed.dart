import 'dart:math';

import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:decimal/decimal.dart';
import 'package:ufcat_ru_check/data/auto_id_generator.dart';
import 'package:ufcat_ru_check/data/category/category.dart' as entity;
import 'package:ufcat_ru_check/data/employee/employee.dart';
import 'package:ufcat_ru_check/data/employee/employee_repository.dart';
import 'package:ufcat_ru_check/data/level/level.dart';
import 'package:ufcat_ru_check/data/meal/meal.dart';
import 'package:ufcat_ru_check/data/setting/income_range_settings.dart';
import 'package:ufcat_ru_check/data/sheet/entry/entry_status.dart';
import 'package:ufcat_ru_check/data/sheet/sheet_repository.dart';
import 'package:ufcat_ru_check/data/student/student.dart';
import 'package:ufcat_ru_check/data/student/student_repository.dart';
import 'package:ufcat_ru_check/domain/report/check_out_of_range_students_use_case.dart';
import 'package:ufcat_ru_check/utils/duration_extensions.dart';
import 'package:unique_names_generator/unique_names_generator.dart';

/// SEED = Popular o banco com dados para testes

final nameGenerator = UniqueNamesGenerator(
  config: Config(
    seperator: ' ',
    style: Style.capital,
    dictionaries: [names, names, names],
  ),
);
final registerGenerator = StudentRegisterGenerator();

class StudentRegisterGenerator {
  final int startYear;
  final int endYear;

  StudentRegisterGenerator({this.startYear = 2018, this.endYear = 2023});

  String generate() {
    final year = startYear + Random().nextInt(endYear - startYear);
    final register = Random().nextInt(99999).toString().padLeft(5, '0');
    return '$year$register';
  }
}

extension SeedStudents on StudentDao {
  Future<List<Student>> seedStudents({
    required amount,
    required IncomeRangeSettings settings,
  }) async {
    if ((await collection.limit(1).get()).size > 0) return [];
    List<String> names = [];
    final students = List.generate(amount, (_) {
      final category = (List.of(entity.Category.values)..shuffle()).first;
      final student = Student.build(
        registerId: registerGenerator.generate(),
        name: nameGenerator.notEqualsTo(names),
        document: CPFValidator.generate(),
        regular: Random().nextBool(),
        category: category,
        level: (List.from(Level.values)..shuffle()).first,
        declaredIncomes: Decimal.fromInt(
            500 + Random().nextInt(category.max(settings).toBigInt().toInt())),
      );
      names.add(student.name);
      return student;
    });
    await saveAll(students);
    return students;
  }
}

extension SeedEmployee on EmployeeDao {
  Future<List<Employee>> seedEmployees({int amount = 4}) async {
    if ((await collection.limit(1).get()).size > 0) return [];
    List<String> names = [];
    final employees = List.generate(amount, (_) {
      final name = nameGenerator.notEqualsTo(names);
      final employee = Employee.build(
        id: AutoIdGenerator.autoId(),
        name: name,
        email: '${name.split(' ').take(2).join().toLowerCase()}@ufcat.br',
        identifier: Random().nextInt(10000).toString().padLeft(4, '0'),
        document: CPFValidator.generate(),
      );
      names.add(employee.name);
      return employee;
    });
    await saveAll(employees);
    return employees;
  }
}

extension SeedSheet on SheetDao {
  Future<void> seedSheets({
    required List<Student> students,
    required List<Employee> employees,
    int daysAgo = 30,
  }) async {
    if ((await collection.limit(1).get()).size > 0) return;

    for (var backN = 1; backN <= daysAgo; backN++) {
      final day = backN.days.ago;
      final bat = collection.firestore.batch();
      for (var level in Level.values) {
        for (var category in entity.Category.values) {
          final sheetFutures = List.generate(
            Random().nextInt(3),
            (mealInt) async {
              final inParams = students
                  .where((s) => s.level == level)
                  .where((s) => s.category == category);
              final sheet = build(
                date: day,
                employeeId: (List.of(employees)..shuffle()).first.id,
                meal: Meal.fromInt(mealInt),
                level: level,
                category: category,
              );
              final entries = inParams.map(
                (s) => buildEntry(
                  time: day,
                  sheetId: sheet.id,
                  studentId: s.id,
                  studentName: s.name,
                  status: EntryStatus.permitted,
                ),
              );
              saveWithEntries(sheet, entries);
            },
          );
          await Future.wait(sheetFutures);
        }
      }

      await bat.commit();
    }
  }
}

extension on UniqueNamesGenerator {
  String notEqualsTo(List<String> names) {
    final another = generate();
    if (names.contains(another)) return notEqualsTo(names);
    return another;
  }
}
