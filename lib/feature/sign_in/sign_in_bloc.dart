import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ufcat_ru_check/data/result.dart';
import 'package:ufcat_ru_check/domain/auth/auth_check_use_case.dart';
import 'package:ufcat_ru_check/domain/auth/sign_in_use_case.dart';

typedef SignInState = Result<SignInUseCaseOutput>;
typedef SignInSuccessState = ResultSuccess<SignInUseCaseOutput>;

class SignInBLoC extends Bloc<SignInEvent, SignInState> {
  SignInBLoC() : super(ResultEmpty()) {
    on<SignInSignEvent>(_handleSignEvent);
    on<AuthCheckEvent>(_handleCheckEvent);
  }

  void _handleSignEvent(
    SignInSignEvent event,
    Emitter<SignInState> emit,
  ) async {
    await emit.forEach(SignInUseCase()(event.use), onData: (result) => result);
  }

  void _handleCheckEvent(
    AuthCheckEvent event,
    Emitter<SignInState> emit,
  ) async {
    await emit.forEach(AuthCheckUseCase()(null), onData: (result) => result);
  }
}

@sealed
abstract class SignInEvent {}

class AuthCheckEvent extends SignInEvent {}

class SignInSignEvent extends SignInEvent {
  final String email;
  final String password;

  SignInSignEvent(this.email, this.password);
}

extension on SignInSignEvent {
  SignInUseCaseInput get use => SignInUseCaseInput(email, password);
}
