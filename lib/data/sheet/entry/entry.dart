import 'package:json_annotation/json_annotation.dart';
import 'package:ufcat_ru_check/data/entity.dart';
import 'package:ufcat_ru_check/data/sheet/entry/entry_status.dart';
import 'package:ufcat_ru_check/utils/firestore_utils.dart';

part 'entry.g.dart';

@JsonSerializable()
class Entry extends Entity<Entry> {
  final String sheetId;
  final String studentId;
  final String studentName;
  @TimestampConverter()
  final DateTime time;
  final EntryStatus status;

  const Entry({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.sheetId,
    required this.studentId,
    required this.studentName,
    required this.time,
    required this.status,
  });

  factory Entry.build({
    required String id,
    required String sheetId,
    required String studentId,
    required String studentName,
    required DateTime time,
    required EntryStatus status,
  }) {
    final now = DateTime.now();
    return Entry(
      id: id,
      sheetId: sheetId,
      studentId: studentId,
      studentName: studentName,
      time: time,
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
      studentName: studentName,
      time: time,
      status: status,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        sheetId,
        studentId,
        studentName,
        time,
        status,
      ];

}

extension EntryFromJson on Map<String, dynamic> {
  Entry toEntry() => _$EntryFromJson(this);
}
