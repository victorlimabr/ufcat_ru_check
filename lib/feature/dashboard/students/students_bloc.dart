import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufcat_ru_check/data/student/student_repository.dart';
import 'package:ufcat_ru_check/feature/dashboard/students/students_state.dart';

class StudentsBloc extends Cubit<StudentsState> {
  final StudentDao _studentRepository;

  StudentsBloc(this._studentRepository) : super(const StudentsState());

  void loadStudents() async {
    final students = await _studentRepository.findAll();
    emit(state.copyWith(students: students));
  }
}
