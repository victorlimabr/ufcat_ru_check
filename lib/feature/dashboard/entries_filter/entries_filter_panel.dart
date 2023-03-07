import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ufcat_ru_check/data/category/category.dart';
import 'package:ufcat_ru_check/data/level/level.dart';
import 'package:ufcat_ru_check/data/meal/meal.dart';
import 'package:ufcat_ru_check/feature/dashboard/entries_filter/entries_filter_bloc.dart';
import 'package:ufcat_ru_check/feature/dashboard/entries_filter/entries_filter_data.dart';
import 'package:ufcat_ru_check/feature/dashboard/settings/app_settings_bloc.dart';
import 'package:ufcat_ru_check/feature/dashboard/settings/app_settings_state.dart';
import 'package:ufcat_ru_check/ui/extensions/category_extensions.dart';
import 'package:ufcat_ru_check/ui/extensions/date_range_extensions.dart';
import 'package:ufcat_ru_check/ui/extensions/level_extensions.dart';
import 'package:ufcat_ru_check/ui/extensions/meal_extensions.dart';
import 'package:ufcat_ru_check/utils/context_extensions.dart';

class EntriesFilterPanel extends StatefulWidget {
  const EntriesFilterPanel({Key? key}) : super(key: key);

  @override
  State<EntriesFilterPanel> createState() => _EntriesFilterPanelState();
}

class _EntriesFilterPanelState extends State<EntriesFilterPanel> {
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    context.read<EntriesFilterBloc>().loadStudents();
    _dateController.text =
        context.read<EntriesFilterBloc>().state.dateRange.format(_dateFormat);
    super.initState();
  }

  DateFormat get _dateFormat => DateFormat.yMd('pt');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
        builder: (context, settingsState) {
      return BlocBuilder<EntriesFilterBloc, EntriesFilterData>(
        builder: (context, filterState) => ListView(
          children: [
            Row(
              children: [
                Expanded(child: Text('Filtros', style: context.titleMedium)),
                TextButton(
                  onPressed: filterState.applied
                      ? null
                      : () {
                          context.read<EntriesFilterBloc>().apply();
                        },
                  child: const Text('APLICAR'),
                )
              ],
            ),
            _filterDivider(),
            TextField(
              controller: _dateController,
              onTap: () => _onTapSelectDate(context, filterState),
              decoration: const InputDecoration(
                label: Text('Período'),
                hintText: '01/01/2023 a 31/01/2023',
                border: OutlineInputBorder(),
              ),
            ),
            _filterDivider(),
            _filterTitleSection(context, 'Filtrar por aluno'),
            Visibility(
              visible: filterState.students.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Wrap(
                  children: [
                    ...filterState.students.map(
                      (e) => InputChip(
                        label: Text(e.name),
                        onDeleted: () =>
                            context.read<EntriesFilterBloc>().removeStudent(e),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Autocomplete(
                optionsBuilder: (editing) =>
                    filterState.filterStudents(editing.text),
                displayStringForOption: (student) {
                  return '${student.id} - ${student.name} (${student.document})';
                },
                onSelected: (student) =>
                    context.read<EntriesFilterBloc>().addStudent(student),
                fieldViewBuilder: (_, controller, focus, onSubmit) => TextField(
                  controller: controller,
                  focusNode: focus,
                  decoration: InputDecoration(
                    label: const Text('Estudante'),
                    hintText: 'Pesquise por nome, matrícula ou CPF',
                    border: const OutlineInputBorder(),
                    suffix: InkWell(
                      onTap: () => controller.text = '',
                      child: const Icon(MdiIcons.closeCircleOutline),
                    ),
                  ),
                ),
              ),
            ),
            _filterDivider(),
            _filterTitleSection(context, 'Nível do curso'),
            ...Level.values.map(
              (e) => _filterCheckbox(
                  context,
                  e.label,
                  filterState.levels.contains(e),
                  (checked) =>
                      context.read<EntriesFilterBloc>().toggleLevel(e)),
            ),
            _filterDivider(),
            _filterTitleSection(context, 'Categoria do subsídio'),
            ...Category.values.map((e) => _filterCheckbox(
                context,
                e.label(settingsState.settings.subsidySettings),
                filterState.categories.contains(e),
                (checked) =>
                    context.read<EntriesFilterBloc>().toggleCategory(e))),
            _filterDivider(),
            _filterTitleSection(context, 'Refeição'),
            ...Meal.values.map((e) => _filterCheckbox(
                context,
                e.label,
                filterState.meals.contains(e),
                (checked) => context.read<EntriesFilterBloc>().toggleMeal(e))),
          ],
        ),
      );
    });
  }

  Future<void> _onTapSelectDate(
    BuildContext context,
    EntriesFilterData state,
  ) async {
    final pickedRange = await showDateRangePicker(
      context: context,
      initialDateRange: state.dateRange,
      firstDate: DateTime.fromMillisecondsSinceEpoch(0),
      lastDate: DateTime.now(),
    );
    if (pickedRange != null && context.mounted) {
      context.read<EntriesFilterBloc>().changeDateRange(pickedRange);
      _dateController.text = pickedRange.format(_dateFormat);
    }
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

  Widget _filterCheckbox(
    BuildContext context,
    String label,
    bool checked,
    ValueChanged<bool?>? onChanged,
  ) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Checkbox(value: checked, onChanged: onChanged),
        ),
        Expanded(child: Text(label, style: context.bodyLarge))
      ],
    );
  }
}
