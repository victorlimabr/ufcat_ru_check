import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufcat_ru_check/data/category/category.dart';
import 'package:ufcat_ru_check/data/level/level.dart';
import 'package:ufcat_ru_check/data/meal/meal.dart';
import 'package:ufcat_ru_check/feature/dashboard/entries_filter/entries_filter_bloc.dart';
import 'package:ufcat_ru_check/feature/dashboard/entries_filter/entries_filter_data.dart';
import 'package:ufcat_ru_check/feature/dashboard/report/entries_report_bloc.dart';
import 'package:ufcat_ru_check/feature/dashboard/report/entries_report_data.dart';
import 'package:ufcat_ru_check/feature/dashboard/settings/app_settings_bloc.dart';
import 'package:ufcat_ru_check/feature/dashboard/settings/app_settings_state.dart';
import 'package:ufcat_ru_check/ui/extensions/category_extensions.dart';
import 'package:ufcat_ru_check/ui/extensions/level_extensions.dart';
import 'package:ufcat_ru_check/ui/extensions/meal_extensions.dart';
import 'package:ufcat_ru_check/utils/context_extensions.dart';

class EntriesReportContent extends StatelessWidget {
  final String employeeId;

  const EntriesReportContent({
    Key? key,
    required this.employeeId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      builder: (context, settingsState) =>
          BlocListener<EntriesFilterBloc, EntriesFilterData>(
        listenWhen: (previous, current) {
          return !previous.applied && current.applied;
        },
        listener: (context, filter) {
          context.read<EntriesReportBLoC>().applyFilter(
                filter,
                settingsState.settings,
              );
        },
        child: BlocBuilder<EntriesReportBLoC, EntriesReportData>(
          builder: (context, reportState) => SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Visibility(
                        visible: reportState.notFoundStudents.isNotEmpty,
                        child: _filterCard(
                          context,
                          'Estudantes não encontrados na base',
                          builder: (_) => DataTable(
                            columns: const [
                              DataColumn(label: Text('Matrícula')),
                              DataColumn(label: Text('Nome')),
                            ],
                            rows: [
                              ...reportState.notFoundStudents.map(
                                (e) => DataRow(
                                  cells: [
                                    DataCell(Text(e.studentId)),
                                    DataCell(Text(e.studentName)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: reportState.irregularStudents.isNotEmpty,
                        child: _filterCard(
                          context,
                          'Estudantes não matriculados no semestre',
                          builder: (_) => DataTable(
                            columns: const [
                              DataColumn(label: Text('Matrícula')),
                              DataColumn(label: Text('Nome')),
                            ],
                            rows: [
                              ...reportState.irregularStudents.map(
                                (e) => DataRow(
                                  cells: [
                                    DataCell(Text(e.studentId)),
                                    DataCell(Text(e.studentName)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: reportState.studentsOutOfRange.isNotEmpty,
                        child: _filterCard(
                          context,
                          'Estudantes com subsídio fora da faixa de renda',
                          builder: (_) => DataTable(
                            columns: const [
                              DataColumn(label: Text('Matrícula')),
                              DataColumn(label: Text('Nome')),
                            ],
                            rows: [
                              ...reportState.studentsOutOfRange.map(
                                (e) => DataRow(
                                  cells: [
                                    DataCell(Text(e.studentId)),
                                    DataCell(Text(e.studentName)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Visibility(
                        visible: reportState.mealCosts.total != Decimal.zero,
                        child: _filterCard(
                          context,
                          'Valor das refeições',
                          builder: (_) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Valor total subsidiado: R\$ ${reportState.mealCosts.subsidized.toStringAsFixed(2)}',
                              ),
                              Text(
                                'Valor pago pelas refeições: R\$ ${reportState.mealCosts.paid.toStringAsFixed(2)}',
                              ),
                              Text(
                                'Valor total das refeições: R\$ ${reportState.mealCosts.total.toStringAsFixed(2)}',
                              )
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: reportState.entriesByCategory.hasAny ||
                            reportState.entriesByLevel.hasAny ||
                            reportState.entriesByMeal.hasAny,
                        child: _filterCard(
                          context,
                          'Quantidade de refeições',
                          builder: (_) => Wrap(
                            children: [
                              Visibility(
                                visible: reportState.entriesByCategory.hasAny,
                                child: _getGraph(
                                  context,
                                  'Por categoria do subsidio',
                                  reportState.entriesByCategory.entries.map(
                                    (e) => PieChartSectionData(
                                      value: e.value.length.toDouble(),
                                      color: e.key.color,
                                      title: e.key.label(settingsState
                                          .settings.subsidySettings),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: reportState.entriesByLevel.hasAny,
                                child: _getGraph(
                                  context,
                                  'Por nível do curso',
                                  reportState.entriesByLevel.entries.map(
                                    (e) => PieChartSectionData(
                                      value: e.value.length.toDouble(),
                                      color: e.key.color,
                                      title: e.key.label,
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: reportState.entriesByMeal.hasAny,
                                child: _getGraph(
                                  context,
                                  'Por refeição',
                                  reportState.entriesByMeal.entries.map(
                                    (e) => PieChartSectionData(
                                      value: e.value.length.toDouble(),
                                      color: e.key.color,
                                      title: e.key.label,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: false,
                        child: _filterCard(
                          context,
                          'Refeições do estudante',
                          builder: (_) => Container(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getGraph(
    BuildContext context,
    String title,
    Iterable<PieChartSectionData> sections,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.titleSmall),
          Container(
            height: 160,
            width: 160,
            padding: const EdgeInsets.only(bottom: 24, top: 16),
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 0,
                sections: [
                  ...sections.map(
                    (e) => e.copyWith(
                        title: e.value.toInt().toString(),
                        radius: 60,
                        titleStyle: const TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
          ),
          ...sections.map(
            (e) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 10,
                  width: 10,
                  color: e.color,
                  margin: const EdgeInsets.all(4),
                ),
                Text(e.title, style: context.labelMedium)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterCard(
    BuildContext context,
    String title, {
    required WidgetBuilder builder,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: context.titleMedium),
            builder(context),
          ],
        ),
      ),
    );
  }
}

extension on Category {
  Color get color {
    switch (this) {
      case Category.free:
        return const Color(0xFFE78787);
      case Category.highSubsidized:
        return const Color(0xFFE787CD);
      case Category.lowSubsidized:
        return const Color(0xFF87B3E7);
      case Category.full:
        return const Color(0xFF94E787);
    }
  }
}

extension on Level {
  Color get color {
    switch (this) {
      case Level.undergraduate:
        return const Color(0xFFE787CD);
      case Level.latoSensu:
        return const Color(0xFF87B3E7);
      case Level.strictoSensu:
        return const Color(0xFF94E787);
    }
  }
}

extension on Meal {
  Color get color {
    switch (this) {
      case Meal.lunch:
        return const Color(0xFF87B3E7);
      case Meal.dinner:
        return const Color(0xFF94E787);
    }
  }
}
