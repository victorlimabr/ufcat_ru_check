import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ufcat_ru_check/feature/sign_in/models/email.dart';
import 'package:ufcat_ru_check/feature/sign_in/models/password.dart';

class SignInState extends Equatable {
  final FormzStatus status;
  final Email email;
  final Password password;

  const SignInState({
    this.status = FormzStatus.pure,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });

  SignInState copyWith({
    FormzStatus? status,
    Email? email,
    Password? password,
  }) {
    return SignInState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [status, email, password];
}
