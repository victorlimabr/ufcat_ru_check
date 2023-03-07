import 'package:firebase_auth/firebase_auth.dart';
import 'package:ufcat_ru_check/data/employee/employee.dart';
import 'package:ufcat_ru_check/data/employee/employee_repository.dart';
import 'package:ufcat_ru_check/domain/auth/auth_exception.dart';
import 'package:ufcat_ru_check/domain/use_case.dart';

class AuthCheckUseCaseOutput {
  final Employee employee;

  AuthCheckUseCaseOutput(this.employee);
}

class AuthCheckUseCase extends FutureUseCase<void, AuthCheckUseCaseOutput> {
  final FirebaseAuth _auth;
  final EmployeeDao _repository;

  AuthCheckUseCase(this._auth, this._repository);

  @override
  Future<AuthCheckUseCaseOutput> perform(void input) async {
    final user = _auth.currentUser;
    if (user == null) throw UnauthorizedException();
    final employee = await _repository.find(user.uid);
    if (employee == null) throw AuthException();
    return AuthCheckUseCaseOutput(employee);
  }
}
