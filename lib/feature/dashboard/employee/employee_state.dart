import 'package:ufcat_ru_check/data/employee/employee.dart';

class EmployeeState {
  final Employee? employee;
  final bool saved;

  const EmployeeState({
    this.employee,
    this.saved = false,
  });

  EmployeeState copyWith({Employee? employee, bool? saved}) {
    return EmployeeState(
      employee: employee ?? this.employee,
      saved: saved ?? this.saved,
    );
  }
}
