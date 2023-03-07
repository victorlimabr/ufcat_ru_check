import 'package:firebase_auth/firebase_auth.dart';
import 'package:ufcat_ru_check/data/employee/employee_repository.dart';
import 'package:ufcat_ru_check/domain/user/listen_current_employee_use_case.dart';
import 'package:ufcat_ru_check/domain/use_case.dart';

class GetCurrentEmployeeUseCase
    extends FutureUseCase<void, CurrentEmployeeOutput> {
  final FirebaseAuth _auth;
  final EmployeeDao _repository;

  GetCurrentEmployeeUseCase(this._auth, this._repository);

  @override
  Future<CurrentEmployeeOutput> perform(void input) async {
    final user = _auth.currentUser;
    if (user == null) return CurrentEmployeeOutput(null);
    final employee = await _repository.find(user.uid);
    if (employee == null) return CurrentEmployeeOutput(null);
    return CurrentEmployeeOutput(employee);
  }
}
