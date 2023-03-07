import 'package:firebase_auth/firebase_auth.dart';
import 'package:ufcat_ru_check/domain/auth/auth_exception.dart';
import 'package:ufcat_ru_check/domain/use_case.dart';

class UpdateUserPasswordInput {
  final String currentPassword;
  final String newPassword;

  UpdateUserPasswordInput(this.currentPassword, this.newPassword);
}

class UpdateUserPasswordUseCase
    extends FutureUseCase<UpdateUserPasswordInput, void> {
  final FirebaseAuth _auth;

  UpdateUserPasswordUseCase(this._auth);

  @override
  Future<void> perform(UpdateUserPasswordInput input) async {
    final user = _auth.currentUser;
    if (user == null) throw UnauthorizedException();
    final authenticated = EmailAuthProvider.credential(
      email: user.email!,
      password: input.currentPassword,
    );
    await user.reauthenticateWithCredential(authenticated);
    await user.updatePassword(input.newPassword);
  }
}
