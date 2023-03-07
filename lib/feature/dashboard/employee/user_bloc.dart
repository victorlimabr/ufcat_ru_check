import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufcat_ru_check/data/result.dart';
import 'package:ufcat_ru_check/domain/user/delete_user_use_case.dart';
import 'package:ufcat_ru_check/domain/user/update_user_password_use_case.dart';
import 'package:ufcat_ru_check/feature/dashboard/employee/user_state.dart';

class UserBloc extends Cubit<UserPasswordState> {
  final UpdateUserPasswordUseCase _passwordUserCase;
  final DeleteUserUseCase _deleteUseCase;

  UserBloc(
    this._passwordUserCase,
    this._deleteUseCase,
  ) : super(const UserPasswordState());

  void savePasswordChanges() async {
    if (state.newPassword == state.passwordConfirmation) {
      final result = await _passwordUserCase(UpdateUserPasswordInput(
        state.currentPassword,
        state.newPassword,
      ));
      if (result is ResultSuccess<void>) {
        emit(state.copyWith(saved: true));
      }
    }
  }

  void deleteAccount(String employeeId) async {
    await _deleteUseCase(DeleteUserInput(state.currentPassword, employeeId));
  }

  void changeCurrentPassword(String currentPassword) {
    emit(state.copyWith(currentPassword: currentPassword, saved: false));
  }

  void changeNewPassword(String newPassword) {
    emit(state.copyWith(newPassword: newPassword, saved: false));
  }

  void changePasswordConfirmation(String passwordConfirmation) {
    emit(state.copyWith(
      passwordConfirmation: passwordConfirmation,
      saved: false,
    ));
  }
}
