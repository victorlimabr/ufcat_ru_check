import 'package:firebase_auth/firebase_auth.dart';
import 'package:ufcat_ru_check/domain/use_case.dart';

class SignOutUseCase extends FutureUseCase<void, void> {
  final FirebaseAuth _auth;

  SignOutUseCase(this._auth);

  @override
  Future<void> perform(void input) async {
    await _auth.signOut();
  }
}
