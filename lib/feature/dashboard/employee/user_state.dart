

class UserPasswordState {
  final String currentPassword;
  final String newPassword;
  final String passwordConfirmation;
  final bool saved;

  const UserPasswordState({
    this.currentPassword = '',
    this.newPassword = '',
    this.passwordConfirmation = '',
    this.saved = false,
  });

  UserPasswordState copyWith({
    String? currentPassword,
    String? newPassword,
    String? passwordConfirmation,
    bool? saved,
  }) {
    return UserPasswordState(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      saved: saved ?? this.saved,
    );
  }
}
