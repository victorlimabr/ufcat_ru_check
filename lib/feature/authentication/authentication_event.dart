part of 'authentication_bloc.dart';

abstract class CurrentEmployeeEvent {
  const CurrentEmployeeEvent();
}

class _CurrentEmployeeChanged extends CurrentEmployeeEvent {
  final Employee? employee;

  const _CurrentEmployeeChanged(this.employee);
}

class EmployeeLogoutRequested extends CurrentEmployeeEvent {}
