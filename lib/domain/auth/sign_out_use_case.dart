import 'package:firebase_auth/firebase_auth.dart';
import 'package:ufcat_ru_check/di/service_locator.dart';
import 'package:ufcat_ru_check/domain/use_case.dart';

class SignOutUseCase extends UseCase<void, void> {
  final _auth = ServiceLocator.get<FirebaseAuth>();

  @override
  Future<void> perform(void input) async {
    await _auth.signOut();
  }
}
