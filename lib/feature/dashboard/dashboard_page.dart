import 'package:async/async.dart' as async;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ufcat_ru_check/data/employee/employee.dart';
import 'package:ufcat_ru_check/data/result.dart';
import 'package:ufcat_ru_check/data/sheet/entry/entry.dart';
import 'package:ufcat_ru_check/data/sheet/entry/entry_dao.dart';
import 'package:ufcat_ru_check/data/sheet/sheet.dart';
import 'package:ufcat_ru_check/data/sheet/sheet_dao.dart';
import 'package:ufcat_ru_check/di/service_locator.dart';
import 'package:ufcat_ru_check/domain/auth/sign_out_use_case.dart';
import 'package:ufcat_ru_check/feature/dashboard/sheet_picker_dialog.dart';
import 'package:ufcat_ru_check/ui/components/authenticated_page.dart';
import 'package:ufcat_ru_check/ui/components/dashboard_page_builder.dart';
import 'package:ufcat_ru_check/utils/context_extensions.dart';

class DashboardPage extends AuthenticatedPage {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget authBuild(BuildContext context, Employee employee) {
    return DashboardPageBuilder(
      userName: employee.name,
      pageSections: [
        DashboardPageSectionData(
          title: 'Entradas',
          menus: [
            const NavigationDrawerDestination(
              icon: Icon(MdiIcons.notebook),
              label: Text('Diário'),
            ),
            const NavigationDrawerDestination(
              icon: Icon(MdiIcons.chartBox),
              label: Text('Relatórios'),
            )
          ],
          pages: [
            DashboardPageData(
              title: 'Diário de Entradas',
              action: DashboardActionData(
                MdiIcons.plus,
                'Adicionar planilha',
                () => SheetPickerDialog.show(context, employeeId: employee.id),
              ),
              contentBuilder: (context) => StreamBuilder<Result<List<Sheet>>>(
                stream:
                    ServiceLocator.get<CollectionReference<Sheet>>().observe,
                builder: (context, snapshot) {
                  final result = snapshot.data;
                  if (result is ResultSuccess<List<Sheet>>) {
                    if (result.data.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text('Nenhuma planilha foi encontrada'),
                            ),
                            FilledButton.icon(
                              onPressed: () => SheetPickerDialog.show(context,
                                  employeeId: employee.id),
                              style: const ButtonStyle(),
                              icon: Icon(MdiIcons.plus),
                              label: Text('Adicionar planilha'),
                            ),
                          ],
                        ),
                      );
                    }
                    return _buildSheet(result.data);
                  }
                  return Container();
                },
              ),
              sideBuilder: (context) => ListView(
                children: [
                  Text('Filtros', style: context.titleMedium),
                  _filterDivider(),
                  const TextField(
                    decoration: InputDecoration(
                      label: Text('Data'),
                      hintText: '01/01/2023',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  _filterDivider(),
                  _filterTitleSection(context, 'Nível do curso'),
                  _filterCheckbox(context, 'Graduação'),
                  _filterCheckbox(context, 'Pós graduação'),
                  _filterCheckbox(context, 'Mestrado'),
                  _filterDivider(),
                  _filterTitleSection(context, 'Categoria do subsídio'),
                  _filterCheckbox(context, 'Bolsa integral'),
                  _filterCheckbox(context, 'Subsidiado - R\$ 4,00'),
                  _filterCheckbox(context, 'Subsidiado - R\$ 6,40'),
                  _filterCheckbox(context, 'Não subsidiado'),
                  _filterDivider(),
                  _filterTitleSection(context, 'Refeição'),
                  _filterCheckbox(context, 'Almoço'),
                  _filterCheckbox(context, 'Janta'),
                ],
              ),
            ),
            DashboardPageData(
              title: 'Relatório de Entradas',
              contentBuilder: (context) => Container(),
            )
          ],
        ),
        DashboardPageSectionData(
          title: 'Cadastros',
          menus: [
            const NavigationDrawerDestination(
              icon: Icon(MdiIcons.accountMultiple),
              label: Text('Funcionários'),
            ),
            const NavigationDrawerDestination(
              icon: Icon(MdiIcons.accountSchool),
              label: Text('Estudantes'),
            )
          ],
          pages: [
            DashboardPageData(
              title: 'Cadastro de Funcionários',
              contentBuilder: (context) => Container(),
            ),
            DashboardPageData(
              title: 'Cadastro de Estudantes',
              contentBuilder: (context) => Container(),
            ),
          ],
        ),
        DashboardPageSectionData(
          title: 'Outros',
          menus: [
            const NavigationDrawerDestination(
              icon: Icon(MdiIcons.cog),
              label: Text('Configurações'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ListTile(
                horizontalTitleGap: 0,
                leading: Icon(MdiIcons.logout),
                title: Text('Sair'),
                onTap: () => SignOutUseCase().call(null),
              ),
            )
          ],
          pages: [
            DashboardPageData(
              title: 'Configurações',
              contentBuilder: (context) => Container(),
            )
          ],
        )
      ],
    );
  }

  Padding _filterDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Divider(),
    );
  }

  Text _filterTitleSection(BuildContext context, String title) {
    return Text(
      title,
      style: context.bodyMedium,
    );
  }

  Widget _filterCheckbox(BuildContext context, String label) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Checkbox(
            value: true,
            onChanged: (value) {},
          ),
        ),
        Expanded(
          child: Text(
            label,
            style: context.bodyLarge,
          ),
        )
      ],
    );
  }

  Widget _buildSheet(List<Sheet> sheets) {
    if (sheets.isEmpty) {
      return Container();
    }
    return StreamBuilder(
      stream: async.StreamZip(sheets.map((e) => e.entries.observe)),
      builder: (context, snap) {
        final result = snap.data;
        final success = result?.whereType<ResultSuccess<List<Entry>>>();
        return SingleChildScrollView(
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Matrícula')),
              DataColumn(label: Text('Horário')),
              DataColumn(label: Text('Nome')),
              DataColumn(label: Text('Refeição')),
              DataColumn(label: Text('Nível')),
              DataColumn(label: Text('Categoria')),
            ],
            rows: (success ?? []).expand((r) => (r as ResultSuccess<List<Entry>>).data).map((entry) {
              final sheet = sheets.firstWhere((s) => s.id == entry.sheetId);
              return DataRow(cells: [
                DataCell(Text(entry.studentId)),
                DataCell(Text(DateFormat.Hms().format(entry.createdAt))),
                DataCell(Text(entry.studentName)),
                DataCell(Text(sheet.meal.label)),
                DataCell(Text(sheet.level.label)),
                DataCell(Text(sheet.category.label)),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }
}
