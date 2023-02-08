import 'package:firebase_auth/firebase_auth.dart';
import 'package:ufcat_ru_check/data/employee/employee_dao.dart';
import 'package:ufcat_ru_check/di/service_locator.dart';
import 'package:ufcat_ru_check/domain/auth/auth_exception.dart';
import 'package:ufcat_ru_check/domain/auth/sign_in_use_case.dart';
import 'package:ufcat_ru_check/domain/use_case.dart';

class AuthCheckUseCase extends UseCase<void, SignInUseCaseOutput> {
  final _auth = ServiceLocator.get<FirebaseAuth>();

  @override
  Future<SignInUseCaseOutput> perform(void input) async {
    final user = _auth.currentUser;
    if (user == null) throw AuthException();
    final employee = await EmployeeEntity.find(user.uid);
    if (employee == null) throw UnauthorizedException();
    return SignInUseCaseOutput(employee);
  }
}
