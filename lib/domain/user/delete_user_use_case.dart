import 'package:firebase_auth/firebase_auth.dart';
import 'package:ufcat_ru_check/data/employee/employee_repository.dart';
import 'package:ufcat_ru_check/domain/auth/auth_exception.dart';
import 'package:ufcat_ru_check/domain/use_case.dart';

class DeleteUserInput {
  final String password;
  final String employeeId;

  DeleteUserInput(this.password, this.employeeId);
}

class DeleteUserUseCase extends FutureUseCase<DeleteUserInput, void> {
  final FirebaseAuth _auth;
  final EmployeeDao _dao;

  DeleteUserUseCase(this._auth, this._dao);

  @override
  Future<void> perform(DeleteUserInput input) async {
    final user = _auth.currentUser;
    if (user == null) throw UnauthorizedException();
    final authenticated = EmailAuthProvider.credential(
      email: user.email!,
      password: input.password,
    );
    await user.reauthenticateWithCredential(authenticated);
    await user.delete();
    await _dao.delete(input.employeeId);
  }
}
