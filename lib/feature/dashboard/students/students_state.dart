import 'package:ufcat_ru_check/data/sheet/entry/entry.dart';
import 'package:ufcat_ru_check/data/sheet/sheet.dart';
import 'package:ufcat_ru_check/data/student/student.dart';

class StudentsState {
  final List<Student> students;
  final DateTime? lastUpdate;

  const StudentsState({this.lastUpdate, this.students = const []});

  StudentsState copyWith({
    List<Student>? students,
  }) {
    return StudentsState(
      students: students ?? this.students,
    );
  }
}
