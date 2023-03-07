import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ufcat_ru_check/data/setting/subsidy_settings.dart';
import 'package:ufcat_ru_check/di/service_locator.dart';
import 'package:ufcat_ru_check/feature/dashboard/daily/daily_entries_bloc.dart';
import 'package:ufcat_ru_check/feature/dashboard/daily/daily_entries_data.dart';
import 'package:ufcat_ru_check/feature/dashboard/entries_filter/entries_filter_bloc.dart';
import 'package:ufcat_ru_check/feature/dashboard/entries_filter/entries_filter_data.dart';
import 'package:ufcat_ru_check/feature/dashboard/settings/app_settings_bloc.dart';
import 'package:ufcat_ru_check/feature/dashboard/settings/app_settings_state.dart';
import 'package:ufcat_ru_check/feature/dashboard/sheet_picker_dialog.dart';
import 'package:ufcat_ru_check/ui/extensions/category_extensions.dart';
import 'package:ufcat_ru_check/ui/extensions/level_extensions.dart';
import 'package:ufcat_ru_check/ui/extensions/meal_extensions.dart';

class DailyEntriesContent extends StatelessWidget {
  final String employeeId;

  const DailyEntriesContent({
    Key? key,
    required this.employeeId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final filter = context.read<EntriesFilterBloc>().state;
        return ServiceLocator.get<DailyEntriesBloc>()..applyFilter(filter);
      },
      child: BlocListener<EntriesFilterBloc, EntriesFilterData>(
        listenWhen: (previous, current) {
          return !previous.applied && current.applied;
        },
        listener: (context, filter) {
          context.read<DailyEntriesBloc>().applyFilter(filter);
        },
        child: BlocBuilder<AppSettingsBloc, AppSettingsState>(
          builder: (context, settingsState) => Card(
            elevation: 0,
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: BlocBuilder<DailyEntriesBloc, DailyEntriesData>(
                builder: (context, dailyState) {
                  if (dailyState.sheets.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Text('Nenhuma planilha foi encontrada'),
                          ),
                          FilledButton.icon(
                            onPressed: () => SheetPickerDialog.show(
                              context,
                              employeeId: employeeId,
                              settings: settingsState.settings,
                            ),
                            style: const ButtonStyle(),
                            icon: const Icon(MdiIcons.plus),
                            label: const Text('Adicionar planilha'),
                          ),
                        ],
                      ),
                    );
                  }
                  return _buildSheet(
                    context,
                    dailyState.sheets,
                    settingsState.settings.subsidySettings,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSheet(
    BuildContext context,
    List<SheetEntries> sheets,
    SubsidySettings settings,
  ) {
    if (sheets.isEmpty) {
      return Container();
    }

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
            columns: const [
              DataColumn(label: Text('Matrícula')),
              DataColumn(label: Text('Horário')),
              DataColumn(label: Text('Nome')),
              DataColumn(label: Text('Refeição')),
              DataColumn(label: Text('Nível')),
              DataColumn(label: Text('Categoria')),
            ],
            rows: sheets
                .expand((sheetEntry) =>
                    sheetEntry.entries.map((entry) => DataRow(cells: [
                          DataCell(Text(entry.studentId)),
                          DataCell(Text(DateFormat.Hms().format(entry.time))),
                          DataCell(Text(entry.studentName)),
                          DataCell(Text(sheetEntry.sheet.meal.label)),
                          DataCell(Text(sheetEntry.sheet.level.label)),
                          DataCell(
                              Text(sheetEntry.sheet.category.label(settings))),
                        ])))
                .toList()),
      ),
    );
  }
}
