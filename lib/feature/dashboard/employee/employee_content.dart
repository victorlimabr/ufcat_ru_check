import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufcat_ru_check/data/employee/employee.dart';
import 'package:ufcat_ru_check/di/service_locator.dart';
import 'package:ufcat_ru_check/feature/dashboard/employee/employee_bloc.dart';
import 'package:ufcat_ru_check/feature/dashboard/employee/employee_state.dart';
import 'package:ufcat_ru_check/feature/dashboard/employee/user_bloc.dart';
import 'package:ufcat_ru_check/feature/dashboard/employee/user_state.dart';
import 'package:ufcat_ru_check/ui/design_system.dart';
import 'package:ufcat_ru_check/utils/context_extensions.dart';

class EmployeeContent extends StatelessWidget {
  final Employee employee;

  const EmployeeContent({Key? key, required this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              ServiceLocator.get<EmployeeBloc>()..initEmployee(employee),
        ),
        BlocProvider(
          create: (_) => ServiceLocator.get<UserBloc>(),
        ),
      ],
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              BlocBuilder<EmployeeBloc, EmployeeState>(
                builder: (context, data) {
                  return Expanded(
                    child: Column(
                      children: [
                        _employeeField(
                          'Nome completo',
                          initialValue: data.employee?.name,
                          onChanged: (name) =>
                              context.read<EmployeeBloc>().changeName(name),
                        ),
                        _employeeField(
                          'E-mail',
                          initialValue: data.employee?.email,
                          onChanged: (email) =>
                              context.read<EmployeeBloc>().changeEmail(email),
                        ),
                        _employeeField(
                          'Usuário',
                          initialValue: data.employee?.identifier,
                          onChanged: (identifier) => context
                              .read<EmployeeBloc>()
                              .changeIdentifier(identifier),
                        ),
                        _employeeField(
                          'CPF',
                          initialValue: data.employee?.document,
                          onChanged: (document) => context
                              .read<EmployeeBloc>()
                              .changeDocument(document),
                        ),
                        FilledButton(
                          onPressed: () =>
                              context.read<EmployeeBloc>().saveChanges(),
                          child: const Text('Salvar alterações'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              BlocBuilder<UserBloc, UserPasswordState>(
                builder: (context, state) => Expanded(
                  child: Column(
                    children: [
                      _employeeField(
                        'Senha atual',
                        initialValue: state.currentPassword,
                        obscure: true,
                        onChanged: (currentPassword) => context
                            .read<UserBloc>()
                            .changeCurrentPassword(currentPassword),
                      ),
                      _employeeField(
                        'Nova senha',
                        initialValue: state.newPassword,
                        obscure: true,
                        onChanged: (newPassword) => context
                            .read<UserBloc>()
                            .changeNewPassword(newPassword),
                      ),
                      _employeeField(
                        'Confirmação da nova senha',
                        initialValue: state.passwordConfirmation,
                        obscure: true,
                        onChanged: (confirmation) => context
                            .read<UserBloc>()
                            .changePasswordConfirmation(confirmation),
                      ),
                      FilledButton(
                        onPressed: () =>
                            context.read<UserBloc>().savePasswordChanges(),
                        child: const Text('Alterar senha'),
                      ),
                      FilledButton(
                        onPressed: () =>
                            context.read<UserBloc>().deleteAccount(employee.id),
                        style: FilledButton.styleFrom(
                            backgroundColor: context.errorColor),
                        child: const Text('Excluir conta'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _employeeField(
    String label, {
    String? initialValue,
    required ValueChanged<String> onChanged,
    bool obscure = false
  }) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        obscureText: obscure,
        decoration: DesignSystem.inputDecoration.copyWith(
          label: Text(label),
        ),
      ),
    );
  }
}
