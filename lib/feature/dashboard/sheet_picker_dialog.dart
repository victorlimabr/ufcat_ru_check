import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ufcat_ru_check/data/category/category.dart';
import 'package:ufcat_ru_check/data/level/level.dart';
import 'package:ufcat_ru_check/data/meal/meal.dart';
import 'package:ufcat_ru_check/services/sheet_parser.dart';

class SheetPickerDialog extends StatefulWidget {
  final String employeeId;

  const SheetPickerDialog({
    Key? key,
    required this.employeeId,
  }) : super(key: key);

  @override
  State<SheetPickerDialog> createState() => _SheetPickerDialogState();

  static Future<void> show(
    BuildContext context, {
    required String employeeId,
  }) {
    return showDialog(
      context: context,
      builder: (context) => SheetPickerDialog(employeeId: employeeId),
    );
  }
}

class _SheetPickerDialogState extends State<SheetPickerDialog> {
  Meal _selectedMeal = Meal.lunch;
  Level _selectedLevel = Level.undergraduate;
  Category _selectedCategory = Category.free;
  DateTime _selectedDate = DateTime.now();
  PlatformFile? _selectedFile;
  final TextEditingController _fileController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    _dateController.text = _dateFormat.format(_selectedDate);
    super.initState();
  }

  DateFormat get _dateFormat => DateFormat.yMd('pt');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nova planilha'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            final parser = SheetParser(
              widget.employeeId,
              _selectedMeal,
              _selectedLevel,
              _selectedCategory,
            );
            final file = _selectedFile;
            if (file != null) {
              await parser(file.bytes!);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Confirmar'),
        )
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text('Selecione uma planilha do excel'),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Arquivo'),
                helperText: 'Clique para selecionar um arquivo',
              ),
              controller: _fileController,
              onTap: () => _onTapAddSheets(),
            ),
          ),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Data'),
            ),
            controller: _dateController,
            onTap: () => _onTapSelectDate(),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('Refeição'),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SegmentedButton<Meal>(
              segments: Meal.values
                  .map(
                    (meal) => ButtonSegment(
                      value: meal,
                      label: Text(meal.label),
                    ),
                  )
                  .toList(),
              selected: {_selectedMeal},
              onSelectionChanged: (meal) {
                setState(() => _selectedMeal = meal.first);
              },
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 200,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nível'),
                    ...Level.values
                        .map(
                          (level) => RadioListTile<Level>(
                            value: level,
                            groupValue: _selectedLevel,
                            title: Text(level.label),
                            onChanged: (level) =>
                                setState(() => _selectedLevel = level!),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
              SizedBox(
                width: 280,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Categoria'),
                    ...Category.values
                        .map(
                          (category) => RadioListTile<Category>(
                            value: category,
                            groupValue: _selectedCategory,
                            title: Text(category.label),
                            onChanged: (category) =>
                                setState(() => _selectedCategory = category!),
                          ),
                        )
                        .toList(),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _onTapAddSheets() async {
    final result = await FilePickerWeb.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xlsm'],
    );
    if (result != null) {
      _selectedFile = result.files.first;
      _fileController.text = _selectedFile?.name ?? '';
    }
  }

  Future<void> _onTapSelectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.fromMillisecondsSinceEpoch(0),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      _selectedDate = pickedDate;
      _dateController.text = _dateFormat.format(pickedDate);
    }
  }
}

extension MealLabel on Meal {
  String get label {
    switch (this) {
      case Meal.lunch:
        return 'Almoço';
      case Meal.dinner:
        return 'Jantar';
    }
  }
}

extension LevelLabel on Level {
  String get label {
    switch (this) {
      case Level.undergraduate:
        return 'Graduação';
      case Level.latoSensu:
        return 'Pós-graduação';
      case Level.strictoSensu:
        return 'Mestrado';
    }
  }
}

extension CategoryLabel on Category {
  String get label {
    switch (this) {
      case Category.free:
        return 'Bolsista integral';
      case Category.highSubsidized:
        return 'Subsidiado - R\$ 4,00';
      case Category.lowSubsidized:
        return 'Subsidiado - R\$ 6,40';
      case Category.full:
        return 'Não subsidiado';
    }
  }
}
