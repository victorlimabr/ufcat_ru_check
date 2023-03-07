import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufcat_ru_check/data/employee/employee.dart';
import 'package:ufcat_ru_check/data/result.dart';
import 'package:ufcat_ru_check/domain/user/listen_current_employee_use_case.dart';
import 'package:ufcat_ru_check/domain/auth/sign_out_use_case.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<CurrentEmployeeEvent, AuthenticationState> {
  final ListenCurrentEmployeeUseCase _getCurrentEmployee;
  final SignOutUseCase _signOutUseCase;

  late StreamSubscription<Result<CurrentEmployeeOutput>>
      _authenticationStatusSubscription;

  AuthenticationBloc(this._getCurrentEmployee, this._signOutUseCase)
      : super(const AuthenticationState.unauthenticated()) {
    on<_CurrentEmployeeChanged>(_onAuthenticationStatusChanged);
    on<EmployeeLogoutRequested>(_onAuthenticationLogoutRequested);
    _authenticationStatusSubscription = _getCurrentEmployee(null).listen(
      (result) {
        if (result is ResultSuccess<CurrentEmployeeOutput>) {
          add(_CurrentEmployeeChanged(result.data.employee));
        } else {
          add(const _CurrentEmployeeChanged(null));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    return super.close();
  }

  Future<void> _onAuthenticationStatusChanged(
    _CurrentEmployeeChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    final employee = event.employee;
    if (employee == null) {
      return emit(const AuthenticationState.unauthenticated());
    } else {
      return emit(AuthenticationState.authenticated(employee));
    }
  }

  void _onAuthenticationLogoutRequested(
    EmployeeLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    _signOutUseCase(null);
  }
}
