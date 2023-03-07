import 'package:firebase_auth/firebase_auth.dart';
import 'package:ufcat_ru_check/data/employee/employee.dart';
import 'package:ufcat_ru_check/data/employee/employee_repository.dart';
import 'package:ufcat_ru_check/domain/auth/auth_exception.dart';
import 'package:ufcat_ru_check/domain/use_case.dart';

class SignUpUseCaseInput {
  final String name;
  final String identifier;
  final String document;
  final String email;
  final String password;

  SignUpUseCaseInput(
    this.email,
    this.password,
    this.name,
    this.identifier,
    this.document,
  );
}

class SignUpUseCaseOutput {
  final Employee employee;

  SignUpUseCaseOutput(this.employee);
}

class SignUpUseCase
    extends FutureUseCase<SignUpUseCaseInput, SignUpUseCaseOutput> {
  final FirebaseAuth _auth;
  final EmployeeDao _employeeDao;

  SignUpUseCase(this._auth, this._employeeDao);

  @override
  Future<SignUpUseCaseOutput> perform(SignUpUseCaseInput input) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: input.email,
        password: input.password,
      );
      final user = credential.user;
      if (user == null) throw AuthException();
      final employee = Employee.build(
        id: user.uid,
        name: input.name,
        email: input.email,
        identifier: input.identifier,
        document: input.document,
      );
      await _employeeDao.save(employee);
      await user.getIdToken(true);
      return SignUpUseCaseOutput(employee);
    } on FirebaseAuthException catch (e) {
      throw e.toAppException();
    }
  }
}
