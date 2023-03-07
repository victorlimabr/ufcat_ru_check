import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ufcat_ru_check/data/result.dart';
import 'package:ufcat_ru_check/domain/auth/auth_check_use_case.dart';
import 'package:ufcat_ru_check/domain/auth/sign_in_use_case.dart';
import 'package:ufcat_ru_check/feature/sign_in/bloc/sign_in_event.dart';
import 'package:ufcat_ru_check/feature/sign_in/bloc/sign_in_state.dart';
import 'package:ufcat_ru_check/feature/sign_in/models/email.dart';
import 'package:ufcat_ru_check/feature/sign_in/models/password.dart';

class SignInBLoC extends Bloc<SignInEvent, SignInState> {
  final SignInUseCase _signInUseCase;
  final AuthCheckUseCase _authCheckUseCase;

  SignInBLoC(this._signInUseCase, this._authCheckUseCase)
      : super(const SignInState()) {
    on<SignInEmailChanged>(_onEmailChanged);
    on<SignInPasswordChanged>(_onPasswordChanged);
    on<SignInSubmitted>(_onSubmitted);
    on<AuthCheck>(_onAuthCheck);
  }

  void _onEmailChanged(
    SignInEmailChanged event,
    Emitter<SignInState> emit,
  ) async {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        status: Formz.validate([state.password, email]),
      ),
    );
  }

  void _onPasswordChanged(
    SignInPasswordChanged event,
    Emitter<SignInState> emit,
  ) async {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        status: Formz.validate([password, state.email]),
      ),
    );
  }

  Future<void> _onSubmitted(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      final result = await _signInUseCase(state.use);
      if (result is ResultSuccess<SignInUseCaseOutput>) {
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }

  void _onAuthCheck(
    AuthCheck event,
    Emitter<SignInState> emit,
  ) async {
    final result = await _authCheckUseCase(null);
    if (result is ResultSuccess<AuthCheckUseCaseOutput>) {
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } else {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}

extension on SignInState {
  SignInUseCaseInput get use => SignInUseCaseInput(email.value, password.value);
}
