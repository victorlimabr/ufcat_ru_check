import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ufcat_ru_check/data/result.dart';
import 'package:ufcat_ru_check/domain/auth/sign_up_use_case.dart';

typedef SignUpState = Result<SignUpUseCaseOutput>;
typedef SignUpSuccessState = ResultSuccess<SignUpUseCaseOutput>;

class SignUpBLoC extends Bloc<SignUpEvent, SignUpState> {
  SignUpBLoC() : super(ResultEmpty()) {
    on<SignUpSignEvent>(_handleSignEvent);
  }

  void _handleSignEvent(
    SignUpSignEvent event,
    Emitter<SignUpState> emit,
  ) async {
    await emit.forEach(SignUpUseCase()(event.use), onData: (result) => result);
  }
}

@sealed
abstract class SignUpEvent {}

class SignUpSignEvent extends SignUpEvent {
  final String name;
  final String identifier;
  final String document;
  final String email;
  final String password;

  SignUpSignEvent(
    this.name,
    this.identifier,
    this.document,
    this.email,
    this.password,
  );
}

extension on SignUpSignEvent {
  SignUpUseCaseInput get use => SignUpUseCaseInput(
        email,
        password,
        name,
        identifier,
        document,
      );
}
