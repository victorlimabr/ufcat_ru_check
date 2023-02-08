import 'package:firebase_auth/firebase_auth.dart';
import 'package:ufcat_ru_check/data/employee/employee.dart';
import 'package:ufcat_ru_check/data/employee/employee_dao.dart';
import 'package:ufcat_ru_check/di/service_locator.dart';
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

class SignInUseCase extends UseCase<SignInUseCaseInput, SignInUseCaseOutput> {
  final _auth = ServiceLocator.get<FirebaseAuth>();

  @override
  Future<SignInUseCaseOutput> perform(SignInUseCaseInput input) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: input.email,
        password: input.password,
      );
      final user = credential.user;
      if (user == null) throw AuthException();
      final employee = await EmployeeEntity.find(user.uid);
      if (employee == null) throw UnauthorizedException();
      return SignInUseCaseOutput(employee);
    } on FirebaseAuthException catch (e) {
      throw e.toAppException();
    }
  }
}
