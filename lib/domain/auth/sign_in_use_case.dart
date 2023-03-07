import 'package:firebase_auth/firebase_auth.dart';
import 'package:ufcat_ru_check/data/employee/employee.dart';
import 'package:ufcat_ru_check/data/employee/employee_repository.dart';
import 'package:ufcat_ru_check/domain/auth/auth_exception.dart';
import 'package:ufcat_ru_check/domain/use_case.dart';

class SignInUseCaseInput {
  final String email;
  final String password;

  SignInUseCaseInput(this.email, this.password);
}

class SignInUseCaseOutput {
  final Employee employee;

  SignInUseCaseOutput(this.employee);
}

class SignInUseCase
    extends FutureUseCase<SignInUseCaseInput, SignInUseCaseOutput> {
  final FirebaseAuth _auth;
  final EmployeeDao _employeeDao;

  SignInUseCase(this._auth, this._employeeDao);

  @override
  Future<SignInUseCaseOutput> perform(SignInUseCaseInput input) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: input.email,
        password: input.password,
      );
      final user = credential.user;
      if (user == null) throw AuthException();
      final employee = await _employeeDao.find(user.uid);
      if (employee == null) throw UnauthorizedException();
      return SignInUseCaseOutput(employee);
    } on FirebaseAuthException catch (e) {
      throw e.toAppException();
    }
  }
}
