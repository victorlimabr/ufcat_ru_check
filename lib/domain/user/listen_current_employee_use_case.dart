import 'package:firebase_auth/firebase_auth.dart';
import 'package:ufcat_ru_check/data/employee/employee.dart';
import 'package:ufcat_ru_check/data/employee/employee_repository.dart';
import 'package:ufcat_ru_check/domain/use_case.dart';

class CurrentEmployeeOutput {
  final Employee? employee;

  CurrentEmployeeOutput(this.employee);
}

class ListenCurrentEmployeeUseCase
    extends StreamUseCase<void, CurrentEmployeeOutput> {
  final FirebaseAuth _auth;
  final EmployeeDao _repository;

  ListenCurrentEmployeeUseCase(this._auth, this._repository);

  @override
  Stream<CurrentEmployeeOutput> perform(void input) {
    return _auth.userChanges().asyncMap((user) async {
      if (user == null) return CurrentEmployeeOutput(null);
      final employee = await _repository.find(user.uid);
      if (employee == null) return CurrentEmployeeOutput(null);
      return CurrentEmployeeOutput(employee);
    });
  }
}
