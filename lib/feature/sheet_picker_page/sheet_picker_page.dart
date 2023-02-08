import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ufcat_ru_check/data/category/category.dart';
import 'package:ufcat_ru_check/data/level/level.dart';
import 'package:ufcat_ru_check/data/meal/meal.dart';
import 'package:ufcat_ru_check/services/sheet_parser.dart';
import 'package:ufcat_ru_check/ui/assets.dart';
import 'package:ufcat_ru_check/ui/components/ru_check_app_bar.dart';

class SheetPickerPage extends StatefulWidget {
  final String employeeId;

  const SheetPickerPage({Key? key, required this.employeeId}) : super(key: key);

  @override
  State<SheetPickerPage> createState() => _SheetPickerPageState();
}

class _SheetPickerPageState extends State<SheetPickerPage> {
  late final parser = SheetParser(
    widget.employeeId,
    Meal.lunch,
    Level.undergraduate,
    Category.lowSubsidized,
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: const Color(0xFFD6E4FF),
        appBar: RUCheckAppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: 'Importar planilha de usuários',
        ),
        body: Center(
          child: FractionallySizedBox(
            widthFactor: 2 / 3,
            heightFactor: 2 / 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: const BorderRadius.all(
                  Radius.circular(48),
                ),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.center,
                widthFactor: 2 / 3,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image(image: Assets.pdfIcon, height: 120),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: _pdfPickButton(context),
                      ),
                      //const Text('ou arraste e solte o PDF aqui')
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _pdfPickButton(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 80,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
          ),
        ),
        onPressed: () async {
          final result = await FilePickerWeb.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['xlsx'],
          );
          if (result != null) {
            await parser(result.files.first.bytes!);
          }
        },
        child: const Text('Selecionar arquivo PDF',
            style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
      ),
    );
  }
}
