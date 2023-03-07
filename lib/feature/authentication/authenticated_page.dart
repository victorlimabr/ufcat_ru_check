import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufcat_ru_check/data/employee/employee.dart';
import 'package:ufcat_ru_check/feature/authentication/authentication_bloc.dart';

abstract class AuthenticatedPage extends StatelessWidget {
  const AuthenticatedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        final employee = state.employee;
        if (employee != null) {
          return authBuild(context, employee);
        }
        return Container();
      },
    );
  }

  Widget authBuild(BuildContext context, Employee employee);
}
