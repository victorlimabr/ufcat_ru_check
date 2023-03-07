import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufcat_ru_check/feature/dashboard/settings/app_settings_bloc.dart';
import 'package:ufcat_ru_check/feature/dashboard/settings/app_settings_state.dart';
import 'package:ufcat_ru_check/ui/design_system.dart';
import 'package:ufcat_ru_check/utils/context_extensions.dart';

class AppSettingsContent extends StatelessWidget {
  const AppSettingsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      builder: (context, state) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _settingsCard(
                  context,
                  'Configurações de planilhas',
                  builder: (_) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _settingsField(
                              'Coluna de matrícula',
                              initialValue: state
                                  .settings.sheetSettings.registerColumn
                                  .toString(),
                              onChanged: (value) {
                                context
                                    .read<AppSettingsBloc>()
                                    .changeRegisterColumn(value);
                              },
                            ),
                            _settingsField(
                              'Coluna do nome',
                              initialValue: state
                                  .settings.sheetSettings.nameColumn
                                  .toString(),
                              onChanged: (value) {
                                context
                                    .read<AppSettingsBloc>()
                                    .changeNameColumn(value);
                              },
                            ),
                            _settingsField(
                              'Coluna do horário',
                              initialValue: state
                                  .settings.sheetSettings.timeColumn
                                  .toString(),
                              onChanged: (value) {
                                context
                                    .read<AppSettingsBloc>()
                                    .changeTimeColumn(value);
                              },
                            ),
                            _settingsField(
                              'Coluna do status',
                              initialValue: state
                                  .settings.sheetSettings.statusColumn
                                  .toString(),
                              onChanged: (value) {
                                context
                                    .read<AppSettingsBloc>()
                                    .changeStatusColumn(value);
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _settingsField(
                              'Linha do primeiro registro',
                              initialValue: state
                                  .settings.sheetSettings.firstEntryLine
                                  .toString(),
                              onChanged: (value) {
                                context
                                    .read<AppSettingsBloc>()
                                    .changeFirstEntryLine(value);
                              },
                            ),
                            _settingsField(
                              'Linhas de rodapé',
                              initialValue: state
                                  .settings.sheetSettings.footerLineCount
                                  .toString(),
                              onChanged: (value) {
                                context
                                    .read<AppSettingsBloc>()
                                    .changeFooterLineCount(value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _settingsCard(
                  context,
                  'Configurações de subsídios',
                  builder: (_) => Column(
                    children: [
                      _settingsField(
                        'Valor da refeição',
                        initialValue:
                            state.settings.subsidySettings.fullCost.toString(),
                        onChanged: (value) {
                          context.read<AppSettingsBloc>().changeFullCost(value);
                        },
                      ),
                      _settingsField(
                        'Subsídio nível 1',
                        initialValue: state.settings.subsidySettings.lowSubsidy
                            .toString(),
                        onChanged: (value) {
                          context
                              .read<AppSettingsBloc>()
                              .changeLowSubsidy(value);
                        },
                      ),
                      _settingsField(
                        'Subsídio nível 2',
                        initialValue: state.settings.subsidySettings.highSubsidy
                            .toString(),
                        onChanged: (value) {
                          context
                              .read<AppSettingsBloc>()
                              .changeHighSubsidy(value);
                        },
                      ),
                    ],
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
                _settingsCard(
                  context,
                  'Configurações de faixas de renda',
                  builder: (_) => Column(
                    children: [
                      _settingsField(
                        'Limite para bolsista integral',
                        initialValue:
                            state.settings.incomeSettings.freeLimit.toString(),
                        onChanged: (value) {
                          context
                              .read<AppSettingsBloc>()
                              .changeFreeLimit(value);
                        },
                      ),
                      _settingsField(
                        'Subsídio - ${state.settings.subsidySettings.lowSubsidy.toStringAsFixed(2)}',
                        initialValue:
                            state.settings.incomeSettings.lowLimit.toString(),
                        onChanged: (value) {
                          context.read<AppSettingsBloc>().changeLowLimit(value);
                        },
                      ),
                      _settingsField(
                        'Subsídio - ${state.settings.subsidySettings.highSubsidy.toStringAsFixed(2)}',
                        initialValue:
                            state.settings.incomeSettings.highLimit.toString(),
                        onChanged: (value) {
                          context
                              .read<AppSettingsBloc>()
                              .changeHighLimit(value);
                        },
                      ),
                    ],
                  ),
                ),
                _settingsCard(
                  context,
                  'Configurações de relatório',
                  builder: (_) => Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _settingsField(
                              'Alerta de atualização de dados do estudante',
                              initialValue: state.settings.reportSettings
                                  .studentUpdateTimeoutInDays
                                  .toString(),
                              onChanged: (value) {
                                context
                                    .read<AppSettingsBloc>()
                                    .changeStudentUpdateTimeout(value);
                              },
                            ),
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _settingsField(
    String label, {
    String initialValue = '',
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        decoration: DesignSystem.inputDecoration.copyWith(
          label: Text(label),
        ),
      ),
    );
  }

  Widget _settingsCard(
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
