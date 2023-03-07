part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  final Employee? employee;

  const AuthenticationState._({
    this.employee,
  });

  const AuthenticationState.authenticated(Employee user)
      : this._(employee: user);

  const AuthenticationState.unauthenticated() : this._();

  @override
  List<Object?> get props => [employee];
}
