import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ufcat_ru_check/data/category/category.dart';
import 'package:ufcat_ru_check/data/level/level.dart';
import 'package:ufcat_ru_check/data/meal/meal.dart';
import 'package:ufcat_ru_check/data/sheet/entry/entry.dart';
import 'package:ufcat_ru_check/data/sheet/entry/entry_status.dart';
import 'package:ufcat_ru_check/data/sheet/sheet.dart';
import 'package:ufcat_ru_check/data/student/student.dart';
import 'package:ufcat_ru_check/data/auto_id_generator.dart';
import 'package:ufcat_ru_check/infra/db/dao.dart';

class SheetDao extends Dao<Sheet> {
  SheetDao(super.collection);

  Future<void> saveWithEntries(Sheet sheet, Iterable<Entry> entries) async {
    final bat = collection.firestore.batch();
    await save(sheet, batch: bat);
    await addEntries(sheet, entries, batch: bat);
    await bat.commit();
  }

  Future<void> addEntries(
    Sheet sheet,
    Iterable<Entry> entries, {
    WriteBatch? batch,
  }) async {
    final bat = batch ?? collection.firestore.batch();
    for (var entry in entries) {
      final now = DateTime.now();
      final entryRef = _entryReference(sheet.id, entry.id);
      if (await entryRef.exists) {
        bat.set<Entry>(entryRef, entry.copyWith(updatedAt: now));
      } else {
        bat.set<Entry>(
          entryRef,
          entry.copyWith(createdAt: now, updatedAt: now),
        );
      }
    }
    await bat.commit();
  }

  DocumentReference<Entry> _entryReference(String sheetId, String id) {
    return reference(sheetId).entriesCollection.doc(id);
  }

  Query<Entry> queryEntries(String sheetId) =>
      reference(sheetId).entriesCollection;

  Entry buildEntry({
    required String sheetId,
    required String studentId,
    required String studentName,
    required DateTime time,
    required EntryStatus status,
  }) {
    return Entry.build(
      id: AutoIdGenerator.autoId(),
      sheetId: sheetId,
      studentId: studentId,
      studentName: studentName,
      time: time,
      status: status,
    );
  }

  Sheet build({
    required DateTime date,
    required String employeeId,
    required Meal meal,
    required Level level,
    required Category category,
  }) {
    return Sheet.build(
      id: AutoIdGenerator.autoId(),
      employeeId: employeeId,
      date: date,
      meal: meal,
      level: level,
      category: category,
    );
  }
}

extension SheetReference on DocumentReference<Sheet> {
  CollectionReference<Entry> get entriesCollection =>
      collection('entry').withConverter(
        fromFirestore: (snap, _) => snap.data()!.toEntry(),
        toFirestore: (entry, _) => entry.toJson(),
      );
}

extension EntryQuery on Query<Entry> {
  Query<Entry> filterStudents(Set<Student> students) {
    if (students.isEmpty) return this;

    return where('student_id', whereIn: students.map((e) => e.id).toList());
  }
}

extension SheetCollection on Query<Sheet> {
  Stream<List<Sheet>> get observe {
    return snapshots().map(
      (sheets) => sheets.docs.map((entry) => entry.data()).toList(),
    );
  }

  Query<Sheet> filterDateRange(DateTimeRange range) {
    return where(
      'date',
      isGreaterThanOrEqualTo: range.start,
      isLessThanOrEqualTo: range.end,
    );
  }

  Query<Sheet> filterLevel(Set<Level> levels) {
    if (levels.length == Level.values.length) return this;
    return where(
      'level',
      whereIn: levels.map((e) => e.toInt()).toList(),
    );
  }

  Query<Sheet> filterMeal(Set<Meal> meals) {
    if (meals.length == Meal.values.length) return this;
    return where(
      'meal',
      whereIn: meals.map((e) => e.toInt()).toList(),
    );
  }

  Query<Sheet> filterCategory(Set<Category> categories) {
    if (categories.length == Category.values.length) return this;
    return where(
      'category',
      whereIn: categories.map((e) => e.toInt()).toList(),
    );
  }
}
