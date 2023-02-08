import 'package:firebase_auth/firebase_auth.dart';
import 'package:ufcat_ru_check/data/employee/employee.dart';
import 'package:ufcat_ru_check/di/service_locator.dart';
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

class SignUpUseCase extends UseCase<SignUpUseCaseInput, SignUpUseCaseOutput> {
  final _auth = ServiceLocator.get<FirebaseAuth>();

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
        uid: user.uid,
        name: input.name,
        email: input.email,
        identifier: input.identifier,
        document: input.document,
      );
      await employee.save();
      return SignUpUseCaseOutput(employee);
    } on FirebaseAuthException catch (e) {
      throw e.toAppException();
    }
  }
}
