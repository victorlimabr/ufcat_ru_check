import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ufcat_ru_check/data/employee/employee.dart';
import 'package:ufcat_ru_check/di/service_locator.dart';
import 'package:ufcat_ru_check/feature/authentication/authenticated_page.dart';
import 'package:ufcat_ru_check/feature/authentication/authentication_bloc.dart';
import 'package:ufcat_ru_check/feature/dashboard/daily/daily_entries_content.dart';
import 'package:ufcat_ru_check/feature/dashboard/employee/employee_content.dart';
import 'package:ufcat_ru_check/feature/dashboard/entries_filter/entries_filter_bloc.dart';
import 'package:ufcat_ru_check/feature/dashboard/entries_filter/entries_filter_panel.dart';
import 'package:ufcat_ru_check/feature/dashboard/report/entries_report_bloc.dart';
import 'package:ufcat_ru_check/feature/dashboard/report/entries_report_content.dart';
import 'package:ufcat_ru_check/feature/dashboard/settings/app_settings_bloc.dart';
import 'package:ufcat_ru_check/feature/dashboard/settings/app_settings_content.dart';
import 'package:ufcat_ru_check/feature/dashboard/sheet_picker_dialog.dart';
import 'package:ufcat_ru_check/feature/dashboard/students/students_content.dart';
import 'package:ufcat_ru_check/services/report_exporter.dart';
import 'package:ufcat_ru_check/ui/components/dashboard_page_builder.dart';

class DashboardPage extends AuthenticatedPage {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget authBuild(BuildContext context, Employee employee) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ServiceLocator.get<AppSettingsBloc>()..loadSettings(),
        ),
        BlocProvider(create: (_) => ServiceLocator.get<EntriesFilterBloc>()),
        BlocProvider(create: (context) {
          final filterState = context.read<EntriesFilterBloc>().state;
          final settingsState = context.read<AppSettingsBloc>().state;
          return ServiceLocator.get<EntriesReportBLoC>()
            ..applyFilter(
              filterState,
              settingsState.settings,
            );
        }),
      ],
      child: Builder(builder: (context) {
        return DashboardPageBuilder(
          userName: employee.name,
          pageSections: [
            DashboardPageSectionData(
              title: 'Entradas',
              menus: [
                _navigationMenu(MdiIcons.notebook, 'Diário'),
                _navigationMenu(MdiIcons.chartBox, 'Relatórios'),
              ],
              pages: [
                _dailyEntriesPage(context, employee),
                _reportPage(context, employee),
              ],
            ),
            DashboardPageSectionData(
              title: 'Cadastros',
              menus: [
                _navigationMenu(MdiIcons.accountMultiple, 'Funcionário'),
                _navigationMenu(MdiIcons.accountSchool, 'Estudantes'),
              ],
              pages: [
                _employeesPage(context, employee),
                _studentsPage(context)
              ],
            ),
            DashboardPageSectionData(
              title: 'Outros',
              menus: [
                _navigationMenu(MdiIcons.cog, 'Configurações'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: ListTile(
                    horizontalTitleGap: 0,
                    leading: const Icon(MdiIcons.logout),
                    title: const Text('Sair'),
                    onTap: () => _signOut(context),
                  ),
                )
              ],
              pages: [_settingsPage(context)],
            )
          ],
        );
      }),
    );
  }

  Future<void> _signOut(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Atenção'),
        content: const Text('Deseja realmente sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => context
                .read<AuthenticationBloc>()
                .add(EmployeeLogoutRequested()),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  NavigationDrawerDestination _navigationMenu(IconData icon, String label) {
    return NavigationDrawerDestination(
      icon: Icon(icon),
      label: Text(label),
    );
  }

  DashboardPageData _employeesPage(BuildContext context, Employee employee) {
    return DashboardPageData(
      title: 'Cadastro do Funcionário',
      contentBuilder: (context) => EmployeeContent(employee: employee),
    );
  }

  DashboardPageData _studentsPage(BuildContext context) {
    return DashboardPageData(
      title: 'Cadastro de Estudantes',
      action: DashboardActionData(
        Icons.save,
        'Atualizar dados do SIGAA',
        () => context.read<AppSettingsBloc>().saveSettings(),
      ),
      contentBuilder: (context) => const StudentsContent(),
    );
  }

  DashboardPageData _settingsPage(BuildContext context) {
    return DashboardPageData(
      title: 'Configurações',
      action: DashboardActionData(
        Icons.save,
        'Salvar configurações',
        () => context.read<AppSettingsBloc>().saveSettings(),
      ),
      contentBuilder: (_) => const AppSettingsContent(),
    );
  }

  DashboardPageData _dailyEntriesPage(BuildContext context, Employee employee) {
    return DashboardPageData(
      title: 'Diário de Entradas',
      action: DashboardActionData(
        MdiIcons.plus,
        'Adicionar planilha',
        () => SheetPickerDialog.show(
          context,
          employeeId: employee.id,
          settings: context.read<AppSettingsBloc>().state.settings,
        ),
      ),
      contentBuilder: (context) => DailyEntriesContent(employeeId: employee.id),
      sideBuilder: (context) => const EntriesFilterPanel(),
    );
  }

  DashboardPageData _reportPage(BuildContext context, Employee employee) {
    return DashboardPageData(
      title: 'Relatório de Entradas',
      action: DashboardActionData(
        MdiIcons.plus,
        'Exportar relatório',
        () => ReportExporter()(
          context.read<EntriesFilterBloc>().state,
          context.read<EntriesReportBLoC>().state,
        ).save(),
      ),
      contentBuilder: (_) => EntriesReportContent(employeeId: employee.id),
      sideBuilder: (context) => const EntriesFilterPanel(),
    );
  }
}
