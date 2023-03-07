import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufcat_ru_check/data/employee/employee.dart';
import 'package:ufcat_ru_check/data/employee/employee_repository.dart';
import 'package:ufcat_ru_check/feature/dashboard/employee/employee_state.dart';

class EmployeeBloc extends Cubit<EmployeeState> {
  final EmployeeDao _employeeRepository;

  EmployeeBloc(
    this._employeeRepository
  ) : super(const EmployeeState());

  void initEmployee(Employee employee) async {
    emit(state.copyWith(employee: employee));
  }

  void saveChanges() async {
    final employee = state.employee;
    if (employee != null) {
      await _employeeRepository.save(employee);
      emit(state.copyWith(saved: true));
    }
  }

  void changeName(String name) {
    emit(state.copyWith(
      employee: state.employee?.copyWith(name: name),
      saved: false,
    ));
  }

  void changeEmail(String email) {
    emit(state.copyWith(
      employee: state.employee?.copyWith(email: email),
      saved: false,
    ));
  }

  void changeIdentifier(String identifier) {
    emit(state.copyWith(
      employee: state.employee?.copyWith(identifier: identifier),
      saved: false,
    ));
  }

  void changeDocument(String document) {
    emit(state.copyWith(
      employee: state.employee?.copyWith(document: document),
      saved: false,
    ));
  }
}
