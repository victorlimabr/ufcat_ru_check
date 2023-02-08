import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ufcat_ru_check/data/entity.dart';
import 'package:ufcat_ru_check/data/sheet/entry/entry_dao.dart';
import 'package:ufcat_ru_check/data/sheet/entry/entry_status.dart';
import 'package:ufcat_ru_check/db/auto_id_generator.dart';
import 'package:ufcat_ru_check/db/dao.dart';
import 'package:ufcat_ru_check/utils/firestore_utils.dart';

part 'entry.g.dart';

@JsonSerializable()
class Entry extends Entity<Entry> with Dao<Entry> {
  final String sheetId;
  final String studentId;
  final String studentName;
  final EntryStatus status;

  const Entry({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.sheetId,
    required this.studentId,
    required this.studentName,
    required this.status,
  });

  factory Entry.build({
    DateTime? at,
    required String sheetId,
    required String studentId,
    required String studentName,
    required EntryStatus status,
  }) {
    final now = at ?? DateTime.now();
    return Entry(
      id: AutoIdGenerator.autoId(),
      sheetId: sheetId,
      studentId: studentId,
      studentName: studentName,
      status: status,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Map<String, dynamic> toJson() => _$EntryToJson(this);

  @override
  Entry copyWith({DateTime? createdAt, DateTime? updatedAt}) {
    return Entry(
      id: id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sheetId: sheetId,
      studentId: studentId,
      status: status,
      studentName: studentName,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        sheetId,
        studentId,
        status,
        studentName,
      ];

  @override
  CollectionReference<Entry> get collection => sheetRef.entries;
}

extension EntryFromJson on Map<String, dynamic> {
  Entry toEntry() => _$EntryFromJson(this);
}
