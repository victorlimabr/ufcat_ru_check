import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:decimal/decimal.dart';
import 'package:ufcat_ru_check/data/category/category.dart' as entity;
import 'package:ufcat_ru_check/data/employee/employee.dart';
import 'package:ufcat_ru_check/data/level/level.dart';
import 'package:ufcat_ru_check/data/meal/meal.dart';
import 'package:ufcat_ru_check/data/sheet/entry/entry.dart';
import 'package:ufcat_ru_check/data/sheet/entry/entry_status.dart';
import 'package:ufcat_ru_check/data/sheet/sheet.dart';
import 'package:ufcat_ru_check/data/student/student.dart';
import 'package:ufcat_ru_check/db/auto_id_generator.dart';
import 'package:ufcat_ru_check/db/collections.dart';
import 'package:ufcat_ru_check/utils/duration_extensions.dart';
import 'package:unique_names_generator/unique_names_generator.dart';

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

extension SeedDatabase on FirebaseFirestore {
  Future<void> seedStudents({int amount = 500}) async {
    if ((await students.limit(1).get()).size > 0) return;
    List<String> names = [];
    final bat = batch();
    for (var _ = 0; _ < amount; _++) {
      final student = Student.build(
        registerId: registerGenerator.generate(),
        name: nameGenerator.notEqualsTo(names),
        document: CPFValidator.generate(),
        regular: Random().nextBool(),
        category: (List.from(entity.Category.values)..shuffle()).first,
        level: (List.from(Level.values)..shuffle()).first,
        declaredIncomes: Decimal.fromInt(500 + Random().nextInt(5000)),
      );
      names.add(student.name);
      bat.set(student.ref, student);
    }
    return bat.commit();
  }

  Future<void> seedEmployees({int amount = 4}) async {
    if ((await employees.limit(1).get()).size > 0) return;

    List<String> names = [];
    final bat = batch();
    for (var _ = 0; _ < amount; _++) {
      final name = nameGenerator.notEqualsTo(names);
      final employee = Employee.build(
        uid: AutoIdGenerator.autoId(),
        name: name,
        email: '${name.split(' ').take(2).join().toLowerCase()}@ufcat.br',
        identifier: Random().nextInt(10000).toString().padLeft(4, '0'),
        document: CPFValidator.generate(),
      );
      names.add(employee.name);
      bat.set(employee.ref, employee);
    }
    await bat.commit();
  }

  Future<void> seedSheets({int daysAgo = 30}) async {
    if ((await sheets.limit(1).get()).size > 0) return;
    final regular = students.where('regular', isEqualTo: true);

    final employeeDocs = await employees.get();
    for (var backN = 1; backN <= daysAgo; backN++) {
      final day = backN.days.ago;
      final bat = batch();
      for (var level in Level.values) {
        for (var category in entity.Category.values) {
          final sheetFutures = List.generate(
            Random().nextInt(3),
            (mealInt) async {
              final inParams = await regular
                  .where('level', isEqualTo: level.toInt())
                  .where('category', isEqualTo: category.toInt())
                  .get();
              final sheet = Sheet.build(
                at: day,
                employeeId: (List.of(employeeDocs.docs)..shuffle()).first.id,
                meal: Meal.fromInt(mealInt),
                level: level,
                category: category,
              );
              bat.set(sheet.ref, sheet);
              for (var student in inParams.docs) {
                final entry = Entry.build(
                  at: day,
                  sheetId: sheet.id,
                  studentId: student.id,
                  studentName: student.data().name,
                  status: EntryStatus.permitted,
                );
                bat.set(entry.ref, entry);
              }
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
